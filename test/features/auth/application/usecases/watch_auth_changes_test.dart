import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/features/auth/application/usecases/watch_auth_changes.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthRepository mockRepository;
  late WatchAuthChanges useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = WatchAuthChanges(mockRepository);
  });

  group('WatchAuthChanges', () {
    final tUser = TestData.user();

    test('should call repository.watchAuthChanges', () {
      // Given
      when(
        () => mockRepository.watchAuthChanges(),
      ).thenAnswer((_) => Stream.value(Right(tUser)));

      // When
      useCase();

      // Then
      verify(() => mockRepository.watchAuthChanges()).called(1);
    });

    test('should return stream of Either<Failure, User?>', () {
      // Given
      when(
        () => mockRepository.watchAuthChanges(),
      ).thenAnswer((_) => Stream.value(Right(tUser)));

      // When
      final stream = useCase();

      // Then
      expect(stream, isA<Stream<Either<Failure, User?>>>());
    });

    test('should emit Right(User) when user is authenticated', () async {
      // Given
      when(
        () => mockRepository.watchAuthChanges(),
      ).thenAnswer((_) => Stream.value(Right(tUser)));

      // When
      final stream = useCase();

      // Then
      await expectLater(
        stream,
        emits(
          predicate<Either<Failure, User?>>((either) {
            return either.isRight() && either.getOrElse((l) => null) == tUser;
          }),
        ),
      );
    });

    test('should emit Right(null) when user logs out', () async {
      // Given
      when(
        () => mockRepository.watchAuthChanges(),
      ).thenAnswer((_) => Stream.value(const Right(null)));

      // When
      final stream = useCase();

      // Then
      await expectLater(
        stream,
        emits(
          predicate<Either<Failure, User?>>((either) {
            return either.isRight() && either.getOrElse((l) => tUser) == null;
          }),
        ),
      );
    });

    test('should emit Left(Failure) on error', () async {
      // Given
      const tFailure = AuthFailure.unauthorized(message: 'Session expired');
      when(
        () => mockRepository.watchAuthChanges(),
      ).thenAnswer((_) => Stream.value(const Left(tFailure)));

      // When
      final stream = useCase();

      // Then
      await expectLater(
        stream,
        emits(
          predicate<Either<Failure, User?>>((either) {
            return either.isLeft();
          }),
        ),
      );
    });

    test('should emit multiple auth state changes', () async {
      // Given - sequence of auth state changes
      when(() => mockRepository.watchAuthChanges()).thenAnswer(
        (_) => Stream.fromIterable([
          const Right<AuthFailure, User?>(null), // Initial: logged out
          Right<AuthFailure, User?>(tUser), // User logs in
          const Right<AuthFailure, User?>(null), // User logs out
        ]),
      );

      // When
      final stream = useCase();

      // Then
      await expectLater(
        stream,
        emitsInOrder([
          predicate<Either<Failure, User?>>((e) => e.isRight()), // null
          predicate<Either<Failure, User?>>((e) => e.isRight()), // user
          predicate<Either<Failure, User?>>((e) => e.isRight()), // null
        ]),
      );
    });

    test('should handle stream errors', () async {
      // Given
      when(
        () => mockRepository.watchAuthChanges(),
      ).thenAnswer((_) => Stream.error(Exception('Stream error')));

      // When
      final stream = useCase();

      // Then
      await expectLater(
        stream,
        emitsError(isA<Exception>()),
      );
    });

    group('integration scenarios', () {
      test('listen to auth changes in BLoC', () async {
        // Given - app is listening to auth changes
        when(() => mockRepository.watchAuthChanges()).thenAnswer(
          (_) => Stream.fromIterable([
            Right<AuthFailure, User?>(tUser),
          ]),
        );

        // When - subscribe to changes
        final stream = useCase();
        final results = <Either<Failure, User?>>[];
        await for (final result in stream) {
          results.add(result);
          break; // Take first emission
        }

        // Then - receives auth state updates
        expect(results.length, 1);
        expect(results.first.isRight(), true);
      });

      test('user login triggers stream update', () async {
        // Given - watching auth state
        when(() => mockRepository.watchAuthChanges()).thenAnswer(
          (_) => Stream.fromIterable([
            const Right<AuthFailure, User?>(null),
            Right<AuthFailure, User?>(tUser),
          ]),
        );

        // When - user logs in
        final stream = useCase();

        // Then - stream emits login event
        await expectLater(
          stream,
          emitsInOrder([
            predicate<Either<Failure, User?>>(
              (e) => e.getOrElse((l) => tUser) == null,
            ),
            predicate<Either<Failure, User?>>(
              (e) => e.getOrElse((l) => null) == tUser,
            ),
          ]),
        );
      });

      test('user logout triggers stream update', () async {
        // Given - user is authenticated
        when(() => mockRepository.watchAuthChanges()).thenAnswer(
          (_) => Stream.fromIterable([
            Right<AuthFailure, User?>(tUser),
            const Right<AuthFailure, User?>(null),
          ]),
        );

        // When - user logs out
        final stream = useCase();

        // Then - stream emits logout event
        await expectLater(
          stream,
          emitsInOrder([
            predicate<Either<Failure, User?>>(
              (e) => e.getOrElse((l) => null) == tUser,
            ),
            predicate<Either<Failure, User?>>(
              (e) => e.getOrElse((l) => tUser) == null,
            ),
          ]),
        );
      });

      test('session expiry triggers stream error', () async {
        // Given - session expires during watch
        const failure = AuthFailure.unauthorized(
          message: 'Session expired',
        );
        when(() => mockRepository.watchAuthChanges()).thenAnswer(
          (_) => Stream.fromIterable([
            Right<AuthFailure, User?>(tUser),
            const Left<AuthFailure, User?>(failure),
          ]),
        );

        // When - watching auth changes
        final stream = useCase();

        // Then - receives error event
        await expectLater(
          stream,
          emitsInOrder([
            predicate<Either<Failure, User?>>((e) => e.isRight()),
            predicate<Either<Failure, User?>>((e) => e.isLeft()),
          ]),
        );
      });

      test('multiple listeners can subscribe', () async {
        // Given - stream can have multiple subscribers
        when(() => mockRepository.watchAuthChanges()).thenAnswer(
          (_) => Stream.fromIterable([Right<AuthFailure, User?>(tUser)]),
        );

        // When - multiple parts of app subscribe
        final stream1 = useCase();
        final stream2 = useCase();

        // Then - both receive updates (repository call is made for each)
        await expectLater(
          stream1,
          emits(predicate<Either<Failure, User?>>((e) => e.isRight())),
        );
        await expectLater(
          stream2,
          emits(predicate<Either<Failure, User?>>((e) => e.isRight())),
        );
        verify(() => mockRepository.watchAuthChanges()).called(2);
      });
    });
  });
}
