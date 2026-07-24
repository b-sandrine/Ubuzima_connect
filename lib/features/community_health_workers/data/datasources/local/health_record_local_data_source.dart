import 'package:injectable/injectable.dart';

import '../../../domain/entities/health_record.dart';

/// In-memory source for the CHW health record, seeded to match the design
/// (Marie Uwimana's record). Read-only for now; swapping in Firestore later
/// means implementing this same interface against the real collection.
abstract interface class HealthRecordLocalDataSource {
  HealthRecord readHealthRecord();
}

@LazySingleton(as: HealthRecordLocalDataSource)
class HealthRecordLocalDataSourceImpl implements HealthRecordLocalDataSource {
  @override
  HealthRecord readHealthRecord() => _seed();

  HealthRecord _seed() {
    return const HealthRecord(
      sector: 'CHW · Kigali Sector',
      dateLabel: 'Sunday, 01 Jun 2025',
      patient: HealthRecordPatient(
        name: 'Marie Uwimana',
        demographics: 'Female · 28 years · Blood: O+',
        riskLevel: RiskLevel.moderate,
        recordId: 'RW-KGL-2025-04822',
        pregnancy: 'Pregnant · 24w',
        location: 'Gasabo, Kigali',
        insurance: 'Mutuelle',
      ),
      demographics: [
        DemographicRow('Date of Birth', '15 Mar 1997'),
        DemographicRow('Household', 'Remera Village'),
        DemographicRow('Household Size', '4 members'),
        DemographicRow('Phone', '+250 781 234 567'),
        DemographicRow('Emergency Contact', 'Jean Uwimana'),
        DemographicRow('Language', 'Kinyarwanda'),
      ],
      assessment: HealthAssessment(
        riskScore: 62,
        riskLevel: RiskLevel.moderate,
        updatedLabel: 'Updated today',
        summary:
            'Fatigue and nausea in a 24-week pregnancy. Swelling observed. '
            'Recommend ANC follow-up within 3 days and hydration monitoring.',
        keyRiskFactor: 'Pregnancy + Swelling',
        recommendation: 'ANC Visit in 3d',
      ),
      conditions: ConditionsSummary(
        activeSymptoms: [
          Symptom('Fatigue', SymptomTone.caution),
          Symptom('Nausea', SymptomTone.caution),
          Symptom('Swelling', SymptomTone.watch),
        ],
        chronicConditions: [],
        specialStatus: ['Pregnant · 24w', 'COVID Vaccinated'],
      ),
      nextSteps: [
        NextStep(
          kind: NextStepKind.visit,
          title: 'ANC Follow-up Visit',
          detail: 'Due: 04 Jun 2025 · Gasabo Health Center',
          badge: '3d',
        ),
        NextStep(
          kind: NextStepKind.check,
          title: 'Blood Pressure Check',
          detail: 'Monitor swelling · Weekly check',
          badge: '7d',
        ),
        NextStep(
          kind: NextStepKind.referral,
          title: 'Referral to Gynecologist',
          detail: 'CHUK Hospital · Pending approval',
          badge: 'Pending',
        ),
      ],
    );
  }
}
