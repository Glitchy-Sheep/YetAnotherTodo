import 'package:uuid/uuid.dart';

class UuidGenerator {
  static const Uuid _generator = Uuid();
  static String v4() => _generator.v4();
}
