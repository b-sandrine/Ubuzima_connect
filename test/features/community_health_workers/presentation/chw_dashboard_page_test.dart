import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/repositories/chw_caseload_repository.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/entities/chw_day_briefing.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/entities/chw_upcoming_visit.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/pages/chw_dashboard_page.dart';
import 'package:ubuzima_connect/features/notifications/domain/models/notification_section.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/entities/patient_intake_draft.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/entities/registered_patient.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/repositories/patient_intake_repository.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/usecases/list_registered_patients.dart';

class _MockPatientIntakeRepository extends Mock
    implements PatientIntakeRepository {}

class _MockChwCaseloadRepository extends Mock implements ChwCaseloadRepository {}

void main() {
  late _MockPatientIntakeRepository repository;
  late _MockChwCaseloadRepository caseload;
  late ListRegisteredPatients listRegisteredPatients;

  const patients = [
    RegisteredPatient(
      id: 'p1',
      fullName: 'Amina Uwase',
      gender: 'female',
      riskScore: 40,
      riskLevel: RiskLevel.moderate,
    ),
    RegisteredPatient(
      id: 'p2',
      fullName: 'Jean Habimana',
      gender: 'male',
      riskScore: 72,
      riskLevel: RiskLevel.high,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const <ChwEmergencyAlert>[]);
    registerFallbackValue(const <ChwUpcomingVisit>[]);
  });

  setUp(() {
    repository = _MockPatientIntakeRepository();
    caseload = _MockChwCaseloadRepository();
    listRegisteredPatients = ListRegisteredPatients(repository);
    when(
      () => repository.listRegisteredPatients(
        forCurrentUserOnly: any(named: 'forCurrentUserOnly'),
      ),
    ).thenAnswer((_) async => const Right(patients));
    when(
      () => repository.listRegisteredPatients(),
    ).thenAnswer((_) async => const Right(patients));
    when(() => caseload.listUpcomingVisits(limit: any(named: 'limit')))
        .thenAnswer(
          (_) async => const [
            ChwUpcomingVisit(
              id: 'v1',
              patientId: 'p1',
              patientName: 'Amina Uwase',
              type: 'Prenatal check',
              timeLabel: '09:00',
              detail: 'Follow-up',
            ),
          ],
        );
    when(() => caseload.listUpcomingVisits()).thenAnswer(
      (_) async => const [
        ChwUpcomingVisit(
          id: 'v1',
          patientId: 'p1',
          patientName: 'Amina Uwase',
          type: 'Prenatal check',
          timeLabel: '09:00',
          detail: 'Follow-up',
        ),
      ],
    );
    when(() => caseload.alertCount()).thenAnswer((_) async => 1);
    when(() => caseload.getSections()).thenAnswer((_) async => const <NotificationSection>[]);
    when(() => caseload.listEmergencyAlerts(limit: any(named: 'limit')))
        .thenAnswer(
          (_) async => const [
            ChwEmergencyAlert(
              patientId: 'p2',
              patientName: 'Jean Habimana',
              location: 'Gasabo, Kigali',
              flags: ['fever', 'difficulty_breathing'],
              riskLevel: 'high',
            ),
          ],
        );
    when(() => caseload.listEmergencyAlerts()).thenAnswer(
      (_) async => const [
        ChwEmergencyAlert(
          patientId: 'p2',
          patientName: 'Jean Habimana',
          location: 'Gasabo, Kigali',
          flags: ['fever', 'difficulty_breathing'],
          riskLevel: 'high',
        ),
      ],
    );
    when(
      () => caseload.getDayBriefing(
        emergencies: any(named: 'emergencies'),
        visits: any(named: 'visits'),
        patientCount: any(named: 'patientCount'),
        alertCount: any(named: 'alertCount'),
      ),
    ).thenAnswer(
      (_) async => const ChwDayBriefing(
        summary:
            'Start with Jean Habimana — fever and breathing issues need a same-day check.',
        recommendations: [
          'See Jean Habimana today — Fever · Difficulty breathing',
          'Complete 1 scheduled visit (next: Amina Uwase)',
        ],
      ),
    );
  });

  testWidgets('renders the CHW dashboard with real recent patients', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 4000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: ChwDashboardPage(
          listRegisteredPatients: listRegisteredPatients,
          caseload: caseload,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ChwDashboardPage), findsOneWidget);
    expect(find.text('Amina Uwase', skipOffstage: false), findsWidgets);
    expect(find.text('Jean Habimana', skipOffstage: false), findsWidgets);
    expect(find.text('2', skipOffstage: false), findsWidgets);
    expect(find.text('1', skipOffstage: false), findsWidgets);
    expect(find.text('Emergency Alerts', skipOffstage: false), findsOneWidget);
    expect(find.text('AI Recommendations', skipOffstage: false), findsOneWidget);
    expect(
      find.textContaining('fever and breathing', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text('Fever · Difficulty breathing', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('See all', skipOffstage: false), findsWidgets);
    expect(find.text('Recent Patients', skipOffstage: false), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Prenatal check', skipOffstage: false),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Prenatal check', skipOffstage: false), findsOneWidget);
    expect(find.text('24', skipOffstage: false), findsNothing);
  });
}
