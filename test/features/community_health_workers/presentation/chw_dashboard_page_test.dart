import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/pages/chw_dashboard_page.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/entities/patient_intake_draft.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/entities/registered_patient.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/repositories/patient_intake_repository.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/usecases/list_registered_patients.dart';

class _MockPatientIntakeRepository extends Mock
    implements PatientIntakeRepository {}

void main() {
  late _MockPatientIntakeRepository repository;
  late ListRegisteredPatients listRegisteredPatients;

  setUp(() {
    repository = _MockPatientIntakeRepository();
    listRegisteredPatients = ListRegisteredPatients(repository);
    when(
      () => repository.listRegisteredPatients(
        forCurrentUserOnly: any(named: 'forCurrentUserOnly'),
      ),
    ).thenAnswer(
      (_) async => const Right([
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
      ]),
    );
    when(() => repository.listRegisteredPatients()).thenAnswer(
      (_) async => const Right([
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
      ]),
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
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ChwDashboardPage), findsOneWidget);
    expect(find.text('Amina Uwase', skipOffstage: false), findsWidgets);
    expect(find.text('Jean Habimana', skipOffstage: false), findsOneWidget);
    expect(find.text('See all', skipOffstage: false), findsOneWidget);
    expect(find.text('Recent Patients', skipOffstage: false), findsOneWidget);
  });
}
