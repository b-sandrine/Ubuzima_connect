import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../dummy/dummy_doctor_dashboard_data.dart';

/// Firestore-backed store for the Doctor Dashboard. Layout:
///
///   doctors/{doctorId}                        → the doctor + stat counts
///   doctors/{doctorId}/emergency_alerts/{id}   → Emergency Alerts panel
///   doctors/{doctorId}/schedule/{id}           → Today's Schedule
///   doctors/{doctorId}/queue/{id}              → Patient Queue
///   doctors/{doctorId}/referral_status/{id}    → Referral Status list
///
/// Seeded from [DummyDoctorDashboardData] on first read. [DashboardStat]'s
/// icon/colour aren't stored — Firestore only carries the stat counts —
/// they're looked up by the stat's stable id, the same way the app already
/// maps status enums to colour/icon elsewhere (`DashboardStyle`).
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

  DoctorDashboardRemoteDataSourceImpl(this._firestore);

  static const String _doctorId = AppConstants.demoDoctorId;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(FirestorePaths.doctors).doc(_doctorId);

  CollectionReference<Map<String, dynamic>> get _alerts =>
      _doc.collection('emergency_alerts');

  CollectionReference<Map<String, dynamic>> get _schedule =>
      _doc.collection('schedule');

  CollectionReference<Map<String, dynamic>> get _queue =>
      _doc.collection('queue');

  CollectionReference<Map<String, dynamic>> get _referralStatus =>
      _doc.collection('referral_status');

  /// Seeded state is checked via `schedule` rather than the shared
  /// `doctors/{doctorId}` doc's existence — that doc is also written by
  /// [PatientSearchRemoteDataSourceImpl] for its own stats, so checking the
  /// doc itself would make whichever screen loads second skip seeding.
  Future<void> _ensureSeeded() async {
    if ((await _schedule.limit(1).get()).docs.isNotEmpty) return;
    await _seedFirestore();
  }

  @override
  Future<Doctor> getCurrentDoctor() async {
    try {
      await _ensureSeeded();
      final data = (await _doc.get()).data() ?? const {};
      return Doctor(
        id: _doctorId,
        fullName: data['fullName'] as String? ?? '',
        hospital: data['hospital'] as String? ?? '',
        onDuty: data['onDuty'] as bool? ?? false,
        photoUrl: data['photoUrl'] as String?,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the doctor.');
    }
  }

  @override
  Future<List<EmergencyAlert>> getEmergencyAlerts() async {
    try {
      await _ensureSeeded();
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
      await _ensureSeeded();
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
      await _ensureSeeded();
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

  @override
  Future<List<QueuePatient>> getPatientQueue() async {
    try {
      await _ensureSeeded();
      final docs = await _queue.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return QueuePatient(
          id: d.id,
          queueNumber: (data['queueNumber'] as num?)?.toInt() ?? 0,
          name: data['name'] as String? ?? '',
          reason: data['reason'] as String? ?? '',
          priority: QueuePriority.values.byName(
            data['priority'] as String? ?? 'routine',
          ),
          photoUrl: data['photoUrl'] as String?,
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the patient queue.');
    }
  }

  @override
  Future<List<Referral>> getReferrals() async {
    try {
      await _ensureSeeded();
      final docs = await _referralStatus.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return Referral(
          id: d.id,
          patientName: data['patientName'] as String? ?? '',
          specialty: data['specialty'] as String? ?? '',
          facility: data['facility'] as String? ?? '',
          status: ReferralStatus.values.byName(
            data['status'] as String? ?? 'pending',
          ),
          note: data['note'] as String? ?? '',
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load referral status.');
    }
  }

  Future<void> _seedFirestore() async {
    final batch = _firestore.batch();
    final doctor = DummyDoctorDashboardData.doctor;
    final stats = {
      for (final stat in DummyDoctorDashboardData.dashboardStats)
        stat.id: stat.value,
    };

    batch.set(_doc, {
      'fullName': doctor.fullName,
      'hospital': doctor.hospital,
      'onDuty': doctor.onDuty,
      'photoUrl': doctor.photoUrl,
      'stats': stats,
    }, SetOptions(merge: true));

    final alerts = DummyDoctorDashboardData.emergencyAlerts;
    for (var i = 0; i < alerts.length; i++) {
      final a = alerts[i];
      batch.set(_alerts.doc(a.id), {
        'severity': a.severity.name,
        'patientName': a.patientName,
        'location': a.location,
        'description': a.description,
        'sortOrder': i,
      });
    }

    final schedule = DummyDoctorDashboardData.todaySchedule;
    for (var i = 0; i < schedule.length; i++) {
      final s = schedule[i];
      batch.set(_schedule.doc(s.id), {
        'time': s.time,
        'patientName': s.patientName,
        'reason': s.reason,
        'durationMinutes': s.durationMinutes,
        'status': s.status.name,
        'sortOrder': i,
      });
    }

    final queue = DummyDoctorDashboardData.patientQueue;
    for (var i = 0; i < queue.length; i++) {
      final q = queue[i];
      batch.set(_queue.doc(q.id), {
        'queueNumber': q.queueNumber,
        'name': q.name,
        'reason': q.reason,
        'priority': q.priority.name,
        'photoUrl': q.photoUrl,
        'sortOrder': i,
      });
    }

    final referrals = DummyDoctorDashboardData.referrals;
    for (var i = 0; i < referrals.length; i++) {
      final r = referrals[i];
      batch.set(_referralStatus.doc(r.id), {
        'patientName': r.patientName,
        'specialty': r.specialty,
        'facility': r.facility,
        'status': r.status.name,
        'note': r.note,
        'sortOrder': i,
      });
    }

    await batch.commit();
  }
}
