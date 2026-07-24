import 'package:injectable/injectable.dart';

import '../../../domain/entities/medication_dose.dart';
import '../../../domain/entities/medication_schedule.dart';

/// In-memory source of PAT-03's schedule. The seed data mirrors the design
/// exactly (Marie Uwase, Amlodipine/Lisinopril taken, Metformin due). It
/// holds the schedule in a mutable field so "Take" and "Request refill"
/// survive within a session; swapping in Firestore later means implementing
/// this same interface against the real collection.
abstract interface class MedicationLocalDataSource {
  MedicationSchedule readTodaySchedule();

  /// Marks [doseId] taken, updating adherence + taken-count, and returns the
  /// new schedule. No-op if the dose is already taken or unknown.
  MedicationSchedule markDoseTaken(String doseId);

  MedicationSchedule requestRefill();
}

@LazySingleton(as: MedicationLocalDataSource)
class MedicationLocalDataSourceImpl implements MedicationLocalDataSource {
  MedicationSchedule _schedule = _seed();

  @override
  MedicationSchedule readTodaySchedule() => _schedule;

  @override
  MedicationSchedule markDoseTaken(String doseId) {
    final index = _schedule.doses.indexWhere((d) => d.id == doseId);
    if (index == -1) return _schedule;

    final dose = _schedule.doses[index];
    if (dose.status == DoseStatus.taken) return _schedule;

    final updatedDoses = [..._schedule.doses];
    updatedDoses[index] = dose.copyWith(
      status: DoseStatus.taken,
      instruction: 'Taken · ${dose.timeLabel}',
    );

    final takenToday = _schedule.summary.takenToday + 1;
    final adherence = ((takenToday / _schedule.summary.totalToday) * 100)
        .round()
        .clamp(0, 100);

    _schedule = _schedule.copyWith(
      doses: updatedDoses,
      summary: _schedule.summary.copyWith(
        takenToday: takenToday,
        adherencePercent: adherence,
      ),
    );
    return _schedule;
  }

  @override
  MedicationSchedule requestRefill() {
    final refill = _schedule.refill;
    if (refill == null) return _schedule;
    _schedule = _schedule.copyWith(refill: refill.copyWith(requested: true));
    return _schedule;
  }

  static MedicationSchedule _seed() {
    return const MedicationSchedule(
      dateLabel: 'Mon, Jun 2, 2025',
      summary: MedicationSummary(
        patientName: 'Marie Uwase',
        conditionLine: 'HTN · T2DM · 3 Active Prescriptions',
        adherencePercent: 82,
        takenToday: 2,
        totalToday: 3,
        refillsDue: 1,
        streakDays: 30,
      ),
      refill: RefillReminder(
        medication: 'Metformin 500mg',
        detail: '5 tablets left · Runs out Jun 7',
      ),
      doses: [
        MedicationDose(
          id: 'amlodipine-am',
          name: 'Amlodipine',
          dosage: '5mg',
          amount: '1 tablet',
          dayPart: DayPart.morning,
          timeLabel: '7:00 AM',
          instruction: 'Taken at 7:03 AM',
          status: DoseStatus.taken,
          tags: [
            DoseTag.condition('Hypertension'),
            DoseTag.instruction('With food'),
          ],
        ),
        MedicationDose(
          id: 'lisinopril-am',
          name: 'Lisinopril',
          dosage: '10mg',
          amount: '1 tablet',
          dayPart: DayPart.morning,
          timeLabel: '7:00 AM',
          instruction: 'Taken at 7:05 AM',
          status: DoseStatus.taken,
          tags: [
            DoseTag.condition('Hypertension'),
            DoseTag.instruction('With water'),
          ],
        ),
        MedicationDose(
          id: 'metformin-pm',
          name: 'Metformin',
          dosage: '500mg',
          amount: '1 tablet',
          dayPart: DayPart.afternoon,
          timeLabel: '1:00 PM',
          instruction: 'With lunch',
          status: DoseStatus.dueSoon,
          tags: [
            DoseTag.condition('Diabetes'),
            DoseTag.instruction('With meal'),
          ],
        ),
        MedicationDose(
          id: 'metformin-eve',
          name: 'Metformin',
          dosage: '500mg',
          amount: '1 tablet',
          dayPart: DayPart.evening,
          timeLabel: '8:00 PM',
          instruction: 'With dinner',
          status: DoseStatus.pending,
          tags: [DoseTag.instruction('Evening dose')],
        ),
      ],
      aiInsight:
          "You've maintained 82% adherence this month — excellent progress! "
          'Taking Metformin consistently with meals reduces gastrointestinal '
          'side effects and improves glucose control by up to 18%.',
    );
  }
}
