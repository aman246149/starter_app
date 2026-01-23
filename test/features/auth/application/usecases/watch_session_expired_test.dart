import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/auth/application/usecases/watch_session_expired.dart';

import '../../../../helpers/mock_helpers.dart';

void main() {
  late MockSessionManager mockSessionManager;
  late WatchSessionExpired useCase;

  setUp(() {
    mockSessionManager = MockSessionManager();
    useCase = WatchSessionExpired(mockSessionManager);
  });

  group('WatchSessionExpired', () {
    test('emits Right(null) when session expires', () async {
      // Given
      when(
        () => mockSessionManager.onSessionExpired,
      ).thenAnswer((_) => Stream.value(null));

      // When
      final stream = useCase();

      // Then
      expect(
        stream,
        emitsInOrder([
          isA<Right<dynamic, void>>(),
        ]),
      );
    });

    test('emits multiple events properly', () async {
      // Given
      when(
        () => mockSessionManager.onSessionExpired,
      ).thenAnswer((_) => Stream.fromIterable([null, null]));

      // When
      final stream = useCase();

      // Then
      expect(
        stream,
        emitsInOrder([
          isA<Right<dynamic, void>>(),
          isA<Right<dynamic, void>>(),
        ]),
      );
    });
  });
}
