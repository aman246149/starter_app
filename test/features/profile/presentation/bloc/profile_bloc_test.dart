import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/base/domain_event.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/presentation/models/error_model.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/profile/application/usecases/get_profile.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_state.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late ProfileBloc bloc;
  late MockUserProfileRepository mockRepository;
  late GetProfile getProfile;
  late MockEventDispatcher eventDispatcher;
  late StreamController<DomainEvent> eventController;

  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(TestData.userProfile());
  });

  setUp(() {
    mockRepository = MockUserProfileRepository();
    eventDispatcher = MockEventDispatcher();
    eventController = StreamController<DomainEvent>.broadcast();
    when(
      () => eventDispatcher.events,
    ).thenAnswer((_) => eventController.stream);
    getProfile = GetProfile(mockRepository);
    bloc = ProfileBloc(getProfile, eventDispatcher);
  });

  tearDown(() async {
    await bloc.close();
    await eventController.close();
  });

  group('ProfileBloc', () {
    test('initial state is ProfileState.initial', () {
      expect(bloc.state, equals(const ProfileState.initial()));
    });

    group('getMyProfile event', () {
      blocTest<ProfileBloc, ProfileState>(
        'emits [loading, loaded] when GetProfile succeeds',
        build: () {
          when(
            () => mockRepository.getCurrentProfile(),
          ).thenAnswer((_) async => Right(TestData.userProfile()));
          return ProfileBloc(getProfile, eventDispatcher);
        },
        act: (bloc) => bloc.add(const ProfileEvent.getMyProfile()),
        expect: () => [
          const ProfileState.loading(),
          ProfileState.loaded(TestData.userProfile()),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [loading, error] when GetProfile fails',
        build: () {
          when(() => mockRepository.getCurrentProfile()).thenAnswer(
            (_) async => const Left(NetworkFailure()),
          );
          return ProfileBloc(getProfile, eventDispatcher);
        },
        act: (bloc) => bloc.add(const ProfileEvent.getMyProfile()),
        expect: () => [
          const ProfileState.loading(),
          isA<ProfileState>().having(
            (state) => state.maybeWhen(
              error: (error) => error,
              orElse: () => null,
            ),
            'error state',
            isA<ErrorModel>(),
          ),
        ],
      );
    });

    group('reset event', () {
      blocTest<ProfileBloc, ProfileState>(
        'emits [initial] when reset is called',
        build: () => ProfileBloc(getProfile, eventDispatcher),
        seed: () => ProfileState.loaded(TestData.userProfile()),
        act: (bloc) => bloc.add(const ProfileEvent.reset()),
        expect: () => [const ProfileState.initial()],
      );
    });

    group('domain event listeners', () {
      blocTest<ProfileBloc, ProfileState>(
        'triggers getMyProfile when UserRegistered event is dispatched',
        build: () {
          when(
            () => mockRepository.getCurrentProfile(),
          ).thenAnswer((_) async => Right(TestData.userProfile()));
          return ProfileBloc(getProfile, eventDispatcher);
        },
        act: (bloc) => eventController.add(UserRegistered(TestData.user())),
        expect: () => [
          const ProfileState.loading(),
          ProfileState.loaded(TestData.userProfile()),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'triggers getMyProfile when UserLoggedIn event is dispatched',
        build: () {
          when(
            () => mockRepository.getCurrentProfile(),
          ).thenAnswer((_) async => Right(TestData.userProfile()));
          return ProfileBloc(getProfile, eventDispatcher);
        },
        act: (bloc) => eventController.add(UserLoggedIn(TestData.user())),
        expect: () => [
          const ProfileState.loading(),
          ProfileState.loaded(TestData.userProfile()),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'triggers getMyProfile when UserSessionRestored event is dispatched',
        build: () {
          when(
            () => mockRepository.getCurrentProfile(),
          ).thenAnswer((_) async => Right(TestData.userProfile()));
          return ProfileBloc(getProfile, eventDispatcher);
        },
        act: (bloc) =>
            eventController.add(UserSessionRestored(TestData.user())),
        expect: () => [
          const ProfileState.loading(),
          ProfileState.loaded(TestData.userProfile()),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'triggers reset when UserLoggedOut event is dispatched',
        build: () => ProfileBloc(getProfile, eventDispatcher),
        seed: () => ProfileState.loaded(TestData.userProfile()),
        act: (bloc) => eventController.add(UserLoggedOut(TestData.user().id)),
        expect: () => [const ProfileState.initial()],
      );

      blocTest<ProfileBloc, ProfileState>(
        'does nothing when UserEmailVerified event is dispatched',
        build: () => ProfileBloc(getProfile, eventDispatcher),
        seed: () => ProfileState.loaded(TestData.userProfile()),
        act: (bloc) => eventController.add(UserEmailVerified(TestData.user())),
        expect: () => <ProfileState>[],
      );

      blocTest<ProfileBloc, ProfileState>(
        'does nothing when UserEmailChanged event is dispatched',
        build: () => ProfileBloc(getProfile, eventDispatcher),
        seed: () => ProfileState.loaded(TestData.userProfile()),
        act: (bloc) => eventController.add(
          UserEmailChanged(TestData.user(), 'old@example.com'),
        ),
        expect: () => <ProfileState>[],
      );

      test('ignores non-AuthDomainEvent events', () async {
        // Create a custom non-auth event for testing
        final nonAuthEvent = _TestDomainEvent();

        when(
          () => mockRepository.getCurrentProfile(),
        ).thenAnswer((_) async => Right(TestData.userProfile()));

        // Emit a non-auth event
        eventController.add(nonAuthEvent);

        // Wait a bit for any potential processing
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // State should remain initial (no profile fetch triggered)
        expect(bloc.state, const ProfileState.initial());
        verifyNever(() => mockRepository.getCurrentProfile());
      });
    });

    group('cleanup', () {
      test('cancels event subscription on close', () async {
        final localController = StreamController<DomainEvent>.broadcast();
        when(
          () => eventDispatcher.events,
        ).thenAnswer((_) => localController.stream);

        final localBloc = ProfileBloc(getProfile, eventDispatcher);

        expect(localController.hasListener, isTrue);

        await localBloc.close();

        // After close, the subscription should be cancelled
        // Adding events should not trigger any bloc actions
        expect(localController.hasListener, isFalse);

        await localController.close();
      });
    });
  });
}

/// Test domain event that is not an AuthDomainEvent.
class _TestDomainEvent extends DomainEvent {}
