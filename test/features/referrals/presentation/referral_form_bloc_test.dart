import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral_draft.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/create_referral.dart';
import 'package:ubuzima_connect/features/referrals/presentation/bloc/referral_form_bloc.dart';

class _MockCreateReferral extends Mock implements CreateReferral {}

class _FakeDraft extends Fake implements ReferralDraft {}

void main() {
  late _MockCreateReferral createReferral;

  setUpAll(() => registerFallbackValue(_FakeDraft()));

  setUp(() => createReferral = _MockCreateReferral());

  ReferralFormBloc build() => ReferralFormBloc(createReferral);

  blocTest<ReferralFormBloc, ReferralFormState>(
    'editing fields builds up the draft and enables submit when complete',
    build: build,
    act: (bloc) => bloc
      ..add(
        const ReferralFormEvent.fieldChanged(
          ReferralField.patientName,
          'Marie Uwase',
        ),
      )
      ..add(
        const ReferralFormEvent.fieldChanged(
          ReferralField.destinationFacility,
          'CHUK',
        ),
      )
      ..add(
        const ReferralFormEvent.fieldChanged(
          ReferralField.specialty,
          'Cardiology',
        ),
      )
      ..add(
        const ReferralFormEvent.fieldChanged(
          ReferralField.reason,
          'Suspected early HF',
        ),
      ),
    verify: (bloc) => expect(bloc.state.canSubmit, isTrue),
  );

  blocTest<ReferralFormBloc, ReferralFormState>(
    'submitting an incomplete draft is ignored',
    build: build,
    act: (bloc) => bloc.add(const ReferralFormEvent.submitted()),
    expect: () => const <ReferralFormState>[],
    verify: (_) => verifyNever(() => createReferral(any())),
  );

  blocTest<ReferralFormBloc, ReferralFormState>(
    'submitting a complete draft reaches success with the reference',
    setUp: () => when(
      () => createReferral(any()),
    ).thenAnswer((_) async => const Right('RW-REF-0042')),
    build: build,
    seed: () => const ReferralFormState(
      draft: ReferralDraft(
        patientName: 'Marie Uwase',
        destinationFacility: 'CHUK',
        specialty: 'Cardiology',
        urgency: ReferralUrgency.urgent,
        reason: 'Suspected early HF',
      ),
    ),
    act: (bloc) => bloc.add(const ReferralFormEvent.submitted()),
    expect: () => [
      isA<ReferralFormState>().having(
        (s) => s.status,
        'status',
        ReferralFormStatus.submitting,
      ),
      isA<ReferralFormState>()
          .having((s) => s.status, 'status', ReferralFormStatus.success)
          .having((s) => s.createdReference, 'reference', 'RW-REF-0042'),
    ],
  );

  blocTest<ReferralFormBloc, ReferralFormState>(
    'a rejected submission surfaces the failure',
    setUp: () => when(
      () => createReferral(any()),
    ).thenAnswer((_) async => const Left(ValidationFailure('missing fields'))),
    build: build,
    seed: () => const ReferralFormState(
      draft: ReferralDraft(
        patientName: 'Marie Uwase',
        destinationFacility: 'CHUK',
        specialty: 'Cardiology',
        urgency: ReferralUrgency.urgent,
        reason: 'Suspected early HF',
      ),
    ),
    act: (bloc) => bloc.add(const ReferralFormEvent.submitted()),
    expect: () => [
      isA<ReferralFormState>().having(
        (s) => s.status,
        'status',
        ReferralFormStatus.submitting,
      ),
      isA<ReferralFormState>()
          .having((s) => s.status, 'status', ReferralFormStatus.failure)
          .having((s) => s.errorMessage, 'error', 'missing fields'),
    ],
  );
}
