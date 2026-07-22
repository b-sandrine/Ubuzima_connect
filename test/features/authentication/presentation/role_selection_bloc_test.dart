import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/authentication/domain/entities/user_role.dart';
import 'package:ubuzima_connect/features/authentication/domain/usecases/get_selected_role.dart';
import 'package:ubuzima_connect/features/authentication/domain/usecases/save_selected_role.dart';
import 'package:ubuzima_connect/features/authentication/presentation/bloc/role_selection_bloc.dart';

class _MockGetSelectedRole extends Mock implements GetSelectedRole {}

class _MockSaveSelectedRole extends Mock implements SaveSelectedRole {}

void main() {
  late _MockGetSelectedRole getSelectedRole;
  late _MockSaveSelectedRole saveSelectedRole;

  setUpAll(() => registerFallbackValue(UserRole.patient));

  setUp(() {
    getSelectedRole = _MockGetSelectedRole();
    saveSelectedRole = _MockSaveSelectedRole();
  });

  RoleSelectionBloc build() =>
      RoleSelectionBloc(getSelectedRole, saveSelectedRole);

  blocTest<RoleSelectionBloc, RoleSelectionState>(
    'started highlights the previously saved role',
    setUp: () => when(
      () => getSelectedRole(),
    ).thenAnswer((_) async => const Right(UserRole.doctor)),
    build: build,
    act: (bloc) => bloc.add(const RoleSelectionEvent.started()),
    expect: () => const [RoleSelectionState(highlightedRole: UserRole.doctor)],
  );

  blocTest<RoleSelectionBloc, RoleSelectionState>(
    'started falls back to an empty selection when the read fails',
    setUp: () => when(
      () => getSelectedRole(),
    ).thenAnswer((_) async => const Left(CacheFailure())),
    build: build,
    act: (bloc) => bloc.add(const RoleSelectionEvent.started()),
    expect: () => const [RoleSelectionState()],
  );

  blocTest<RoleSelectionBloc, RoleSelectionState>(
    'highlighting a role enables confirmation',
    build: build,
    act: (bloc) => bloc.add(
      const RoleSelectionEvent.roleHighlighted(UserRole.communityHealthWorker),
    ),
    expect: () => const [
      RoleSelectionState(highlightedRole: UserRole.communityHealthWorker),
    ],
    verify: (bloc) => expect(bloc.state.canConfirm, isTrue),
  );

  blocTest<RoleSelectionBloc, RoleSelectionState>(
    'confirming saves the role and reaches saved',
    setUp: () => when(
      () => saveSelectedRole(any()),
    ).thenAnswer((_) async => const Right(unit)),
    build: build,
    seed: () => const RoleSelectionState(highlightedRole: UserRole.patient),
    act: (bloc) =>
        bloc.add(const RoleSelectionEvent.confirmed(AuthDestination.signIn)),
    expect: () => const [
      RoleSelectionState(
        status: RoleSelectionStatus.saving,
        highlightedRole: UserRole.patient,
        destination: AuthDestination.signIn,
      ),
      RoleSelectionState(
        status: RoleSelectionStatus.saved,
        highlightedRole: UserRole.patient,
        destination: AuthDestination.signIn,
      ),
    ],
    verify: (_) => verify(() => saveSelectedRole(UserRole.patient)).called(1),
  );

  blocTest<RoleSelectionBloc, RoleSelectionState>(
    'confirming surfaces the failure message when the save fails',
    setUp: () => when(
      () => saveSelectedRole(any()),
    ).thenAnswer((_) async => const Left(CacheFailure('no space left'))),
    build: build,
    seed: () => const RoleSelectionState(highlightedRole: UserRole.patient),
    act: (bloc) => bloc.add(
      const RoleSelectionEvent.confirmed(AuthDestination.createAccount),
    ),
    expect: () => const [
      RoleSelectionState(
        status: RoleSelectionStatus.saving,
        highlightedRole: UserRole.patient,
        destination: AuthDestination.createAccount,
      ),
      RoleSelectionState(
        status: RoleSelectionStatus.failure,
        highlightedRole: UserRole.patient,
        destination: AuthDestination.createAccount,
        errorMessage: 'no space left',
      ),
    ],
  );

  blocTest<RoleSelectionBloc, RoleSelectionState>(
    'confirming with nothing highlighted is ignored',
    build: build,
    act: (bloc) =>
        bloc.add(const RoleSelectionEvent.confirmed(AuthDestination.signIn)),
    expect: () => const <RoleSelectionState>[],
    verify: (_) => verifyNever(() => saveSelectedRole(any())),
  );
}
