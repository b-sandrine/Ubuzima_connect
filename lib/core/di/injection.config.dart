// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/authentication/data/datasources/local/role_selection_local_data_source.dart'
    as _i838;
import '../../features/authentication/data/repositories/role_selection_repository_impl.dart'
    as _i1028;
import '../../features/authentication/domain/repositories/role_selection_repository.dart'
    as _i451;
import '../../features/authentication/domain/usecases/get_selected_role.dart'
    as _i999;
import '../../features/authentication/domain/usecases/save_selected_role.dart'
    as _i945;
import '../../features/authentication/presentation/bloc/role_selection_bloc.dart'
    as _i41;
import '../../features/community_health_workers/data/datasources/local/health_record_local_data_source.dart'
    as _i554;
import '../../features/community_health_workers/data/datasources/remote/health_record_remote_data_source.dart'
    as _i552;
import '../../features/community_health_workers/data/repositories/health_record_repository_impl.dart'
    as _i74;
import '../../features/community_health_workers/domain/repositories/health_record_repository.dart'
    as _i245;
import '../../features/community_health_workers/domain/usecases/complete_next_step.dart'
    as _i665;
import '../../features/community_health_workers/domain/usecases/get_health_record.dart'
    as _i509;
import '../../features/community_health_workers/presentation/bloc/health_record_bloc.dart'
    as _i1071;
import '../../features/medical_records/data/datasources/local/timeline_local_data_source.dart'
    as _i231;
import '../../features/medical_records/data/datasources/remote/timeline_remote_data_source.dart'
    as _i596;
import '../../features/medical_records/data/repositories/timeline_repository_impl.dart'
    as _i659;
import '../../features/medical_records/domain/repositories/timeline_repository.dart'
    as _i984;
import '../../features/medical_records/domain/usecases/get_patient_timeline.dart'
    as _i209;
import '../../features/medical_records/presentation/bloc/timeline_bloc.dart'
    as _i855;
import '../../features/onboarding/data/datasources/local/onboarding_local_data_source.dart'
    as _i645;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/complete_onboarding.dart'
    as _i561;
import '../../features/onboarding/domain/usecases/get_onboarding_complete.dart'
    as _i826;
import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i153;
import '../../features/prescriptions/data/datasources/local/medication_local_data_source.dart'
    as _i325;
import '../../features/prescriptions/data/datasources/remote/medication_remote_data_source.dart'
    as _i694;
import '../../features/prescriptions/data/repositories/medication_repository_impl.dart'
    as _i521;
import '../../features/prescriptions/domain/repositories/medication_repository.dart'
    as _i552;
import '../../features/prescriptions/domain/usecases/get_today_schedule.dart'
    as _i566;
import '../../features/prescriptions/domain/usecases/mark_dose_taken.dart'
    as _i340;
import '../../features/prescriptions/domain/usecases/request_refill.dart'
    as _i843;
import '../../features/prescriptions/presentation/bloc/medication_bloc.dart'
    as _i92;
import '../../features/referrals/data/datasources/local/referral_local_data_source.dart'
    as _i33;
import '../../features/referrals/data/datasources/remote/referral_remote_data_source.dart'
    as _i1015;
import '../../features/referrals/data/repositories/referral_repository_impl.dart'
    as _i1054;
import '../../features/referrals/domain/repositories/referral_repository.dart'
    as _i710;
import '../../features/referrals/domain/usecases/accept_referral.dart' as _i407;
import '../../features/referrals/domain/usecases/create_referral.dart' as _i888;
import '../../features/referrals/domain/usecases/decline_referral.dart'
    as _i315;
import '../../features/referrals/domain/usecases/delete_referral.dart' as _i173;
import '../../features/referrals/domain/usecases/get_referral_board.dart'
    as _i572;
import '../../features/referrals/presentation/bloc/referral_board_bloc.dart'
    as _i460;
import '../../features/referrals/presentation/bloc/referral_form_bloc.dart'
    as _i668;
import '../analytics/analytics_service.dart' as _i726;
import '../connectivity/connectivity_cubit.dart' as _i690;
import '../database/app_database.dart' as _i982;
import '../helpers/id_generator.dart' as _i580;
import '../localization/locale_cubit.dart' as _i960;
import '../logging/app_logger.dart' as _i354;
import '../network/network_info.dart' as _i932;
import '../permissions/permission_service.dart' as _i271;
import '../routing/app_router.dart' as _i282;
import '../routing/auth_session.dart' as _i565;
import '../security/secure_storage_service.dart' as _i812;
import '../services/connectivity_service.dart' as _i47;
import '../services/firebase_messaging_service.dart' as _i910;
import '../services/sync_service.dart' as _i979;
import '../storage/local_storage_service.dart' as _i744;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.sharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i982.AppDatabase>(() => _i982.AppDatabase());
  gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
  gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
  gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
  gh.lazySingleton<_i457.FirebaseStorage>(() => registerModule.firebaseStorage);
  gh.lazySingleton<_i892.FirebaseMessaging>(
    () => registerModule.firebaseMessaging,
  );
  gh.lazySingleton<_i558.FlutterSecureStorage>(
    () => registerModule.secureStorage,
  );
  gh.lazySingleton<_i974.Logger>(() => registerModule.logger);
  gh.lazySingleton<_i812.SecureStorageService>(
    () => _i812.SecureStorageServiceImpl(gh<_i558.FlutterSecureStorage>()),
  );
  gh.lazySingleton<_i979.SyncService>(() => _i979.NoOpSyncService());
  gh.lazySingleton<_i271.PermissionService>(
    () => _i271.PermissionServiceImpl(),
  );
  gh.lazySingleton<_i33.ReferralLocalDataSource>(
    () => _i33.ReferralLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i744.LocalStorageService>(
    () => _i744.LocalStorageServiceImpl(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i554.HealthRecordLocalDataSource>(
    () => _i554.HealthRecordLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i325.MedicationLocalDataSource>(
    () => _i325.MedicationLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i231.TimelineLocalDataSource>(
    () => _i231.TimelineLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i565.AuthSessionProvider>(
    () => _i565.NoOpAuthSessionProvider(),
  );
  gh.lazySingleton<_i580.IdGenerator>(() => _i580.UuidIdGenerator());
  gh.lazySingleton<_i645.OnboardingLocalDataSource>(
    () => _i645.OnboardingLocalDataSourceImpl(gh<_i744.LocalStorageService>()),
  );
  gh.lazySingleton<_i354.AppLogger>(() => _i354.AppLogger(gh<_i974.Logger>()));
  gh.lazySingleton<_i838.RoleSelectionLocalDataSource>(
    () =>
        _i838.RoleSelectionLocalDataSourceImpl(gh<_i744.LocalStorageService>()),
  );
  gh.lazySingleton<_i910.FirebaseMessagingService>(
    () => _i910.FirebaseMessagingService(
      gh<_i892.FirebaseMessaging>(),
      gh<_i354.AppLogger>(),
    ),
  );
  gh.lazySingleton<_i726.AnalyticsService>(
    () => _i726.NoOpAnalyticsService(gh<_i354.AppLogger>()),
  );
  gh.lazySingleton<_i932.NetworkInfo>(
    () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
  );
  gh.lazySingleton<_i282.AppRouter>(
    () => _i282.AppRouter(gh<_i565.AuthSessionProvider>()),
  );
  gh.lazySingleton<_i451.RoleSelectionRepository>(
    () => _i1028.RoleSelectionRepositoryImpl(
      gh<_i838.RoleSelectionLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i47.ConnectivityService>(
    () => _i47.ConnectivityService(gh<_i932.NetworkInfo>()),
  );
  gh.lazySingleton<_i1015.ReferralRemoteDataSource>(
    () => _i1015.ReferralRemoteDataSourceImpl(
      gh<_i974.FirebaseFirestore>(),
      gh<_i33.ReferralLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i552.HealthRecordRemoteDataSource>(
    () => _i552.HealthRecordRemoteDataSourceImpl(
      gh<_i974.FirebaseFirestore>(),
      gh<_i554.HealthRecordLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i694.MedicationRemoteDataSource>(
    () => _i694.MedicationRemoteDataSourceImpl(
      gh<_i974.FirebaseFirestore>(),
      gh<_i325.MedicationLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i960.LocaleCubit>(
    () => _i960.LocaleCubit(gh<_i744.LocalStorageService>()),
  );
  gh.lazySingleton<_i690.ConnectivityCubit>(
    () => _i690.ConnectivityCubit(gh<_i47.ConnectivityService>()),
  );
  gh.lazySingleton<_i710.ReferralRepository>(
    () => _i1054.ReferralRepositoryImpl(gh<_i1015.ReferralRemoteDataSource>()),
  );
  gh.lazySingleton<_i596.TimelineRemoteDataSource>(
    () => _i596.TimelineRemoteDataSourceImpl(
      gh<_i974.FirebaseFirestore>(),
      gh<_i231.TimelineLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i430.OnboardingRepository>(
    () => _i452.OnboardingRepositoryImpl(gh<_i645.OnboardingLocalDataSource>()),
  );
  gh.factory<_i561.CompleteOnboarding>(
    () => _i561.CompleteOnboarding(gh<_i430.OnboardingRepository>()),
  );
  gh.factory<_i826.GetOnboardingComplete>(
    () => _i826.GetOnboardingComplete(gh<_i430.OnboardingRepository>()),
  );
  gh.factory<_i153.OnboardingCubit>(
    () => _i153.OnboardingCubit(gh<_i561.CompleteOnboarding>()),
  );
  gh.lazySingleton<_i552.MedicationRepository>(
    () =>
        _i521.MedicationRepositoryImpl(gh<_i694.MedicationRemoteDataSource>()),
  );
  gh.lazySingleton<_i245.HealthRecordRepository>(
    () => _i74.HealthRecordRepositoryImpl(
      gh<_i552.HealthRecordRemoteDataSource>(),
    ),
  );
  gh.factory<_i999.GetSelectedRole>(
    () => _i999.GetSelectedRole(gh<_i451.RoleSelectionRepository>()),
  );
  gh.factory<_i945.SaveSelectedRole>(
    () => _i945.SaveSelectedRole(gh<_i451.RoleSelectionRepository>()),
  );
  gh.factory<_i407.AcceptReferral>(
    () => _i407.AcceptReferral(gh<_i710.ReferralRepository>()),
  );
  gh.factory<_i888.CreateReferral>(
    () => _i888.CreateReferral(gh<_i710.ReferralRepository>()),
  );
  gh.factory<_i315.DeclineReferral>(
    () => _i315.DeclineReferral(gh<_i710.ReferralRepository>()),
  );
  gh.factory<_i173.DeleteReferral>(
    () => _i173.DeleteReferral(gh<_i710.ReferralRepository>()),
  );
  gh.factory<_i572.GetReferralBoard>(
    () => _i572.GetReferralBoard(gh<_i710.ReferralRepository>()),
  );
  gh.factory<_i665.CompleteNextStep>(
    () => _i665.CompleteNextStep(gh<_i245.HealthRecordRepository>()),
  );
  gh.factory<_i509.GetHealthRecord>(
    () => _i509.GetHealthRecord(gh<_i245.HealthRecordRepository>()),
  );
  gh.factory<_i460.ReferralBoardBloc>(
    () => _i460.ReferralBoardBloc(
      gh<_i572.GetReferralBoard>(),
      gh<_i407.AcceptReferral>(),
      gh<_i315.DeclineReferral>(),
      gh<_i173.DeleteReferral>(),
    ),
  );
  gh.factory<_i566.GetTodaySchedule>(
    () => _i566.GetTodaySchedule(gh<_i552.MedicationRepository>()),
  );
  gh.factory<_i340.MarkDoseTaken>(
    () => _i340.MarkDoseTaken(gh<_i552.MedicationRepository>()),
  );
  gh.factory<_i843.RequestRefill>(
    () => _i843.RequestRefill(gh<_i552.MedicationRepository>()),
  );
  gh.lazySingleton<_i984.TimelineRepository>(
    () => _i659.TimelineRepositoryImpl(gh<_i596.TimelineRemoteDataSource>()),
  );
  gh.factory<_i41.RoleSelectionBloc>(
    () => _i41.RoleSelectionBloc(
      gh<_i999.GetSelectedRole>(),
      gh<_i945.SaveSelectedRole>(),
    ),
  );
  gh.factory<_i209.GetPatientTimeline>(
    () => _i209.GetPatientTimeline(gh<_i984.TimelineRepository>()),
  );
  gh.factory<_i1071.HealthRecordBloc>(
    () => _i1071.HealthRecordBloc(
      gh<_i509.GetHealthRecord>(),
      gh<_i665.CompleteNextStep>(),
    ),
  );
  gh.factory<_i92.MedicationBloc>(
    () => _i92.MedicationBloc(
      gh<_i566.GetTodaySchedule>(),
      gh<_i340.MarkDoseTaken>(),
      gh<_i843.RequestRefill>(),
    ),
  );
  gh.factory<_i668.ReferralFormBloc>(
    () => _i668.ReferralFormBloc(gh<_i888.CreateReferral>()),
  );
  gh.factory<_i855.TimelineBloc>(
    () => _i855.TimelineBloc(gh<_i209.GetPatientTimeline>()),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
