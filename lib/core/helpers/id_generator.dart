import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// Generates local IDs for records created offline, before a server ID is
/// assigned during sync. Wrapped behind an interface so use cases can be
/// tested without depending on the `uuid` package directly.
abstract interface class IdGenerator {
  String generate();
}

@LazySingleton(as: IdGenerator)
class UuidIdGenerator implements IdGenerator {
  static const Uuid _uuid = Uuid();

  @override
  String generate() => _uuid.v4();
}
