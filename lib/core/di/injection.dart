import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

/// Aggregates every `@injectable` / `@lazySingleton` / `@module` annotated
/// class across `core/`, `shared/`, and every `features/*` folder into one
/// generated registration (`injection.config.dart`). Registrations stay
/// physically decentralized — each class registers itself where it's
/// defined — even though the generated wiring lives in one file.
///
/// Run after every change to an annotated class:
///   dart run build_runner build --delete-conflicting-outputs
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => init(getIt);
