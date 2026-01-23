import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';

void main() {
  group('UserId', () {
    test('generate creates a valid UserId with unique value', () {
      final id1 = UserId.generate();
      final id2 = UserId.generate();

      expect(id1, isNotNull);
      expect(id2, isNotNull);
      expect(id1, isNot(id2));
      expect(id1.value.value, isNotEmpty);
    });

    test('fromString creates UserId with provided value', () {
      const idStr = 'user-123';
      final id = UserId.fromString(idStr);

      expect(id.value.value, idStr);
    });

    test('equality works correctly', () {
      const idStr = 'user-123';
      final id1 = UserId.fromString(idStr);
      final id2 = UserId.fromString(idStr);
      final id3 = UserId.fromString('user-456');

      expect(id1, id2);
      expect(id1.hashCode, id2.hashCode);
      expect(id1, isNot(id3));
    });
  });
}
