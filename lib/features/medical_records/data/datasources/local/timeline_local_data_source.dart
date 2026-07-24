import 'package:injectable/injectable.dart';

import '../../../domain/entities/patient_timeline.dart';
import '../../../domain/entities/timeline_event.dart';

/// In-memory timeline for DOC-04, seeded to match the design (Marie Uwase's
/// chronological history and the BP/glucose trend). Read-only for now — the
/// screen filters and searches over this in the Bloc.
abstract interface class TimelineLocalDataSource {
  PatientTimeline readTimeline();
}

@LazySingleton(as: TimelineLocalDataSource)
class TimelineLocalDataSourceImpl implements TimelineLocalDataSource {
  @override
  PatientTimeline readTimeline() => _seed();

  PatientTimeline _seed() {
    return const PatientTimeline(
      patient: TimelinePatient(
        name: 'Marie Uwase',
        summary: '52F · HTN + T2DM + CKD · RW-2847',
        criticality: 'Critical',
      ),
      trend: [
        TrendPoint(label: 'Jan', systolic: 138, glucose: 8.2),
        TrendPoint(label: 'Feb', systolic: 142, glucose: 8.8),
        TrendPoint(label: 'Mar', systolic: 150, glucose: 9.6),
        TrendPoint(label: 'Apr', systolic: 158, glucose: 10.9),
        TrendPoint(label: 'May', systolic: 168, glucose: 12.4),
        TrendPoint(label: 'Jun', systolic: 182, glucose: 13.1),
      ],
      events: [
        TimelineEvent(
          id: 'evt-htn-crisis',
          category: EventCategory.emergency,
          title: 'Hypertensive Crisis',
          dateLabel: '1 Jun 2025',
          year: 2025,
          detail: 'BP 182/110 · IV labetalol · Admitted for 48h observation',
        ),
        TimelineEvent(
          id: 'evt-labs-may',
          category: EventCategory.labResult,
          title: 'HbA1c & Renal Panel',
          dateLabel: '28 May 2025',
          year: 2025,
          detail: 'HbA1c 9.1% · eGFR 44 · K+ 5.3 · Creatinine 168',
        ),
        TimelineEvent(
          id: 'evt-rx-sitagliptin',
          category: EventCategory.prescription,
          title: 'Sitagliptin Added · Metformin Adjusted',
          dateLabel: '20 May 2025',
          year: 2025,
          detail: 'Metformin 500mg BD + Sitagliptin 50mg OD',
        ),
        TimelineEvent(
          id: 'evt-chw-review',
          category: EventCategory.visit,
          title: 'Routine CHW Review',
          dateLabel: '12 May 2025',
          year: 2025,
          detail: 'BP 158/96 · Glucose 12.4 · Weight 74kg · Oedema noted',
        ),
        TimelineEvent(
          id: 'evt-ckd-dx',
          category: EventCategory.diagnosis,
          title: 'CKD Stage 2 Confirmed',
          dateLabel: 'Nov 2024',
          year: 2024,
          detail: 'eGFR 44 · Referred to nephrology for monitoring',
        ),
        TimelineEvent(
          id: 'evt-nephro-ref',
          category: EventCategory.referral,
          title: 'Nephrology Referral',
          dateLabel: 'Aug 2024',
          year: 2024,
          detail: 'Rising creatinine · CHUK nephrology clinic',
        ),
        TimelineEvent(
          id: 'evt-t2dm-dx',
          category: EventCategory.diagnosis,
          title: 'Type 2 Diabetes Mellitus',
          dateLabel: 'Mar 2023',
          year: 2023,
          detail: 'HbA1c 7.9% · Started on metformin · Dietary counselling',
        ),
        TimelineEvent(
          id: 'evt-htn-dx',
          category: EventCategory.diagnosis,
          title: 'Essential Hypertension',
          dateLabel: '2019',
          year: 2019,
          detail: 'BP 152/94 · Single agent amlodipine · Annual review',
        ),
      ],
      aiSummary:
          'Progressive dual-condition escalation over 6 years: hypertension '
          '(2019) → T2DM (2023) → early CKD (2024). BP and glucose trends '
          'have both climbed sharply since March, and the June crisis '
          'suggests control has slipped. Consider a combined management '
          'review and tighter monitoring.',
    );
  }
}
