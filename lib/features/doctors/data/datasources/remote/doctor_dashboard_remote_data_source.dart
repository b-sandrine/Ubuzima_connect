import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/dashboard_stat.dart';
import '../../../domain/models/doctor.dart';
import '../../../domain/models/emergency_alert.dart';
import '../../../domain/models/queue_patient.dart';
import '../../../domain/models/referral.dart';
import '../../../domain/models/schedule_item.dart';

/// Firestore-backed store for the Doctor Dashboard, scoped to the
/// signed-in doctor's own Firebase Auth uid. Layout:
///
///   users/{uid}                        → real identity (name/email),
///                                         written by registration
///   doctors/{uid}                      → doctor-only extras (hospital,
///                                         onDuty) + stat counts
///   doctors/{uid}/emergency_alerts/{id} → Emergency Alerts panel
///   doctors/{uid}/schedule/{id}         → Today's Schedule
///
/// Referral Status *and* Patient Queue both read the same `referrals`
/// collection DOC-06's Referral Management screen owns — not separate
/// copies — so a referral actually routed to this doctor shows up in
/// both places.
///
/// No seed data — a fresh account reads back empty lists/blank fields
/// until real activity exists. [DashboardStat]'s icon/colour aren't
/// stored — Firestore only carries the stat counts — they're looked up by
/// the stat's stable id, the same way the app already maps status enums
/// to colour/icon elsewhere (`DashboardStyle`).
abstract interface class DoctorDashboardRemoteDataSource {
  Future<Doctor> getCurrentDoctor();

  Future<List<EmergencyAlert>> getEmergencyAlerts();

  Future<List<DashboardStat>> getDashboardStats();

  Future<List<ScheduleItem>> getTodaySchedule();

  Future<List<QueuePatient>> getPatientQueue();

  Future<List<Referral>> getReferrals();
}

@LazySingleton(as: DoctorDashboardRemoteDataSource)
class DoctorDashboardRemoteDataSourceImpl
    implements DoctorDashboardRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DoctorDashboardRemoteDataSourceImpl(this._firestore, this._auth);

  /// The signed-in doctor's uid — falls back to the old fixed demo id only
  /// if somehow no one is signed in (shouldn't happen; every doctor route
  /// requires auth).
  String get _doctorId => _auth.currentUser?.uid ?? AppConstants.demoDoctorId;

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _firestore.collection(FirestorePaths.users).doc(_doctorId);

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(FirestorePaths.doctors).doc(_doctorId);

  CollectionReference<Map<String, dynamic>> get _alerts =>
      _doc.collection('emergency_alerts');

  CollectionReference<Map<String, dynamic>> get _schedule =>
      _doc.collection('schedule');

  CollectionReference<Map<String, dynamic>> get _referrals =>
      _firestore.collection(FirestorePaths.referrals);

  DocumentReference<Map<String, dynamic>> get _referralPatientDoc => _firestore
      .collection(FirestorePaths.patients)
      .doc(AppConstants.demoPatientId);

  @override
  Future<Doctor> getCurrentDoctor() async {
    try {
      final results = await Future.wait([_userDoc.get(), _doc.get()]);
      final user = results[0].data() ?? const {};
      final doctor = results[1].data() ?? const {};
      return Doctor(
        id: _doctorId,
        fullName: (user['displayName'] as String?)?.trim().isNotEmpty == true
            ? user['displayName'] as String
            : doctor['fullName'] as String? ?? '',
        hospital: doctor['hospital'] as String? ?? '',
        onDuty: doctor['onDuty'] as bool? ?? true,
        photoUrl: doctor['photoUrl'] as String?,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the doctor.');
    }
  }

  @override
  Future<List<EmergencyAlert>> getEmergencyAlerts() async {
    try {
      final docs = await _alerts.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return EmergencyAlert(
          id: d.id,
          severity: AlertSeverity.values.byName(
            data['severity'] as String? ?? 'urgent',
          ),
          patientName: data['patientName'] as String? ?? '',
          location: data['location'] as String? ?? '',
          description: data['description'] as String? ?? '',
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load emergency alerts.');
    }
  }

  @override
  Future<List<DashboardStat>> getDashboardStats() async {
    try {
      final data = (await _doc.get()).data() ?? const {};
      final stats = (data['stats'] as Map?) ?? const {};
      return [
        DashboardStat(
          id: 'stat-patients',
          label: 'Patients Today',
          value: (stats['stat-patients'] as num?)?.toInt() ?? 0,
          icon: LucideIcons.users,
          color: AppColors.primary,
        ),
        DashboardStat(
          id: 'stat-queue',
          label: 'In Queue',
          value: (stats['stat-queue'] as num?)?.toInt() ?? 0,
          icon: LucideIcons.clock,
          color: AppColors.secondary,
        ),
        DashboardStat(
          id: 'stat-referrals',
          label: 'Referrals',
          value: (stats['stat-referrals'] as num?)?.toInt() ?? 0,
          icon: LucideIcons.send,
          color: AppColors.warning,
        ),
      ];
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load dashboard stats.');
    }
  }

  @override
  Future<List<ScheduleItem>> getTodaySchedule() async {
    try {
      final docs = await _schedule.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return ScheduleItem(
          id: d.id,
          time: data['time'] as String? ?? '',
          patientName: data['patientName'] as String? ?? '',
          reason: data['reason'] as String? ?? '',
          durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 0,
          status: ScheduleStatus.values.byName(
            data['status'] as String? ?? 'none',
          ),
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? "Could not load today's schedule.");
    }
  }

  /// Patients actually referred to this doctor (incoming, not declined) —
  /// the same underlying data [getReferrals] reads, just re-shaped into the
  /// Dashboard's queue tile. Queue position is the item's index in this
  /// list; there's no separate stored position.
  @override
  Future<List<QueuePatient>> getPatientQueue() async {
    try {
      final referrals = await _incomingReferrals();
      return [
        for (var i = 0; i < referrals.length; i++)
          QueuePatient(
            id: referrals[i].$1.id,
            queueNumber: i + 1,
            name: referrals[i].$2,
            reason: referrals[i].$1.data()['reason'] as String? ?? '',
            priority: _queuePriorityFor(
              referrals[i].$1.data()['urgency'] as String?,
            ),
          ),
      ];
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the patient queue.');
    }
  }

  /// Referred patients actually routed to this doctor — reads DOC-06's
  /// real `referrals` collection (incoming, not declined), not a
  /// separate/duplicated list.
  @override
  Future<List<Referral>> getReferrals() async {
    try {
      final referrals = await _incomingReferrals();
      return [
        for (final (doc, patientName) in referrals)
          Referral(
            id: doc.id,
            patientName: patientName,
            specialty: doc.data()['specialty'] as String? ?? '',
            facility: doc.data()['facility'] as String? ?? '',
            status: doc.data()['status'] == 'accepted'
                ? ReferralStatus.approved
                : ReferralStatus.pending,
            note: doc.data()['receivedLabel'] as String? ?? '',
          ),
      ];
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load referral status.');
    }
  }

  /// Incoming, non-declined referral documents paired with the (single,
  /// shared) referred patient's name.
  Future<List<(QueryDocumentSnapshot<Map<String, dynamic>>, String)>>
  _incomingReferrals() async {
    final results = await Future.wait([
      _referrals.where('direction', isEqualTo: 'incoming').get(),
      _referralPatientDoc.get(),
    ]);
    final docs = results[0] as QuerySnapshot<Map<String, dynamic>>;
    final patientName =
        (results[1] as DocumentSnapshot<Map<String, dynamic>>)
            .data()?['name'] as String? ??
        '';

    return docs.docs
        .where((d) => d.data()['status'] != 'declined')
        .map((d) => (d, patientName))
        .toList();
  }

  QueuePriority _queuePriorityFor(String? urgency) => switch (urgency) {
    'urgent' => QueuePriority.urgent,
    'routine' => QueuePriority.routine,
    _ => QueuePriority.moderate,
  };
}
