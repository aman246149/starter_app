import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/base/domain_event.dart';
import 'package:starter_app/core/domain/base/event_dispatcher.dart';
import 'package:starter_app/core/presentation/models/error_model.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/profile/application/usecases/get_profile.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._getProfile,
    this._eventDispatcher,
  ) : super(const ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      await event.when(
        getMyProfile: () => _onStarted(emit),
        reset: () {
          emit(const ProfileState.initial());
          return Future<void>.value();
        },
      );
    });

    _setupEventListeners();
  }

  final GetProfile _getProfile;
  final IEventDispatcher _eventDispatcher;
  StreamSubscription<DomainEvent>? _eventSubscription;

  /// Listen to cross-feature domain events.
  /// Auto-triggers profile fetch on login/registration/session restore.
  void _setupEventListeners() {
    _eventSubscription = _eventDispatcher.events.listen((event) {
      if (event is! AuthDomainEvent) return;

      switch (event) {
        case UserRegistered():
        case UserLoggedIn():
        case UserSessionRestored():
          add(const ProfileEvent.getMyProfile());
        case UserLoggedOut():
          add(const ProfileEvent.reset());
        case UserEmailVerified():
        case UserEmailChanged():
          // No action needed for profile
          break;
      }
    });
  }

  Future<void> _onStarted(Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await _getProfile();
    result.fold(
      (failure) => emit(ProfileState.error(ErrorModel.fromFailure(failure))),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }

  @override
  Future<void> close() async {
    await _eventSubscription?.cancel();
    return super.close();
  }
}
