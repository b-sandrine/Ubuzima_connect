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
      totalEvents: 24,
      earlierCount: 6,
      aiViewLabel: '7-year view',
      patient: TimelinePatient(
        name: 'Marie Uwase',
        summary: 'ID: RW-2847 · 52F · Kigali District',
        criticality: 'Critical',
        careHistory: '7 yrs',
      ),
      trend: [
        TrendPoint(label: '2018', systolic: 162, glucose: 7.8),
        TrendPoint(label: '2020', systolic: 150, glucose: 8.6),
        TrendPoint(label: '2022', systolic: 156, glucose: 11.0),
        TrendPoint(label: '2024', systolic: 170, glucose: 13.4),
        TrendPoint(label: '2025', systolic: 185, glucose: 15.2),
      ],
      events: [
        TimelineEvent(
          id: 'evt-htn-crisis',
          category: EventCategory.emergency,
          title: 'Hypertensive Crisis',
          dateLabel: '2 Jun 2025',
          year: 2025,
          detail: 'BP 185/112 · ED admission · ICU observation',
        ),
        TimelineEvent(
          id: 'evt-labs-may',
          category: EventCategory.labResult,
          title: 'HbA1c & Renal Panel',
          dateLabel: '28 May 2025',
          year: 2025,
          detail: 'HbA1c 9.2% · Creatinine 168 · eGFR 44',
        ),
        TimelineEvent(
          id: 'evt-rx-sitagliptin',
          category: EventCategory.prescription,
          title: 'Sitagliptin Added · Metformin Adjusted',
          dateLabel: '20 May 2025',
          year: 2025,
          detail: 'Metformin 1000mg BD + Sitagliptin 50mg OD',
        ),
        TimelineEvent(
          id: 'evt-opd-review',
          category: EventCategory.visit,
          title: 'Routine OPD Review',
          dateLabel: '14 Mar 2025',
          year: 2025,
          detail: 'BP 148/90 · Glucose 12.4 · Weight 74kg',
        ),
        TimelineEvent(
          id: 'evt-ckd-dx',
          category: EventCategory.diagnosis,
          title: 'CKD Stage 2 Confirmed',
          dateLabel: 'Nov 2024',
          year: 2024,
          detail: 'eGFR 68 · Creatinine 112 µmol/L',
        ),
        TimelineEvent(
          id: 'evt-nephro-ref',
          category: EventCategory.referral,
          title: 'Nephrology Referral',
          dateLabel: 'Aug 2024',
          year: 2024,
          detail: 'King Faisal Hospital · Dr. Mutimura',
        ),
        TimelineEvent(
          id: 'evt-t2dm-dx',
          category: EventCategory.diagnosis,
          title: 'Type 2 Diabetes Mellitus',
          dateLabel: 'Mar 2022',
          year: 2022,
          detail: 'FBG 11.2 mmol/L · HbA1c 8.1%',
        ),
        TimelineEvent(
          id: 'evt-htn-dx',
          category: EventCategory.diagnosis,
          title: 'Essential Hypertension',
          dateLabel: 'Jan 2018',
          year: 2018,
          detail: 'BP 162/98 · Stage 2 HTN · First diagnosis',
        ),
      ],
      // Filled by ClinicalAiService on first remote read.
      aiSummary: '',
    );
  }
}
