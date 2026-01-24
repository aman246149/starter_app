import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/domain/value_objects/name.dart';
import 'package:starter_app/core/domain/value_objects/password.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/presentation/models/error_model.dart';
import 'package:starter_app/features/auth/application/usecases/check_user_exists.dart';
import 'package:starter_app/features/auth/application/usecases/get_current_user.dart';
import 'package:starter_app/features/auth/application/usecases/login.dart';
import 'package:starter_app/features/auth/application/usecases/logout.dart';
import 'package:starter_app/features/auth/application/usecases/register.dart';
import 'package:starter_app/features/auth/application/usecases/watch_auth_changes.dart';
import 'package:starter_app/features/auth/application/usecases/watch_session_expired.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:starter_app/features/auth/presentation/bloc/field_validation_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._checkUserExists,
    this._login,
    this._register,
    this._logout,
    this._getCurrentUser,
    this._watchAuthChanges,
    this._watchSessionExpired,
    this._logger,
  ) : super(AuthState.empty()) {
    on<AuthGetCurrentUser>(_onGetCurrentUser);
    on<AuthWatchStarted>(_onAuthWatchStarted, transformer: restartable());
    on<AuthSessionWatchStarted>(
      _onSessionWatchStarted,
      transformer: restartable(),
    );
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthNameChanged>(_onNameChanged);
    on<AuthEmailUnfocused>(_onEmailUnfocused);
    on<AuthPasswordUnfocused>(_onPasswordUnfocused);
    on<AuthNameUnfocused>(_onNameUnfocused);
    on<AuthEmailSubmitted>(_onEmailSubmitted);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthRegisterSubmitted>(_onRegisterSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthSessionExpired>(_onSessionExpired);
    on<AuthTogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  final CheckUserExists _checkUserExists;
  final Login _login;
  final Register _register;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;
  final WatchAuthChanges _watchAuthChanges;
  final WatchSessionExpired _watchSessionExpired;
  final IAppLogger _logger;

  Future<void> _onAuthWatchStarted(
    AuthWatchStarted event,
    Emitter<AuthState> emit,
  ) async {
    await emit.onEach<Either<Failure, User?>>(
      _watchAuthChanges(),
      onData: (result) => result.fold(
        (failure) {
          _logger.error(failure.toString());
          add(const AuthEvent.authUserChanged(null));
        },
        (user) {
          add(AuthEvent.authUserChanged(user));
        },
      ),
    );
  }

  Future<void> _onSessionWatchStarted(
    AuthSessionWatchStarted event,
    Emitter<AuthState> emit,
  ) async {
    await emit.onEach<void>(
      _watchSessionExpired(),
      onData: (_) => add(const AuthEvent.sessionExpired()),
    );
  }

  Future<void> _onGetCurrentUser(
    AuthGetCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    add(const AuthEvent.sessionWatchStarted());

    final result = await _getCurrentUser.call();
    result.fold(
      (failure) {
        _logger.warning('Failed to get current user: $failure');
        emit(AuthState.empty());
      },
      (user) {
        if (user != null) {
          emit(AuthState.authenticated(user));
          add(const AuthWatchStarted());
        } else {
          emit(AuthState.empty());
        }
      },
    );
  }

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    state.mapOrNull(
      initial: (s) => emit(
        s.copyWith(
          email: EmailAddress(event.email),
          error: null,
          validation: s.validation.copyWith(emailTouched: false),
        ),
      ),
      loginRequired: (_) => _resetToInitialIfEmpty(event.email, emit),
      registrationRequired: (_) => _resetToInitialIfEmpty(event.email, emit),
    );
  }

  void _resetToInitialIfEmpty(String email, Emitter<AuthState> emit) {
    if (email.isEmpty) {
      emit(AuthState.empty());
    }
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    _updatePasswordField(Password(event.password), emit);
  }

  void _updatePasswordField(Password password, Emitter<AuthState> emit) {
    state.mapOrNull(
      loginRequired: (s) => emit(
        s.copyWith(
          password: password,
          error: null,
          validation: s.validation.copyWith(passwordTouched: false),
        ),
      ),
      registrationRequired: (s) => emit(
        s.copyWith(
          password: password,
          error: null,
          validation: s.validation.copyWith(passwordTouched: false),
        ),
      ),
    );
  }

  void _onNameChanged(AuthNameChanged event, Emitter<AuthState> emit) {
    state.mapOrNull(
      registrationRequired: (s) => emit(
        s.copyWith(
          name: Name(event.name),
          error: null,
          validation: s.validation.copyWith(nameTouched: false),
        ),
      ),
    );
  }

  void _onTogglePasswordVisibility(
    AuthTogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    state.mapOrNull(
      loginRequired: (s) => emit(
        s.copyWith(passwordVisible: !s.passwordVisible),
      ),
      registrationRequired: (s) => emit(
        s.copyWith(passwordVisible: !s.passwordVisible),
      ),
    );
  }

  void _onEmailUnfocused(AuthEmailUnfocused event, Emitter<AuthState> emit) {
    _markFieldTouched(emit, emailTouched: true);
  }

  void _onPasswordUnfocused(
    AuthPasswordUnfocused event,
    Emitter<AuthState> emit,
  ) {
    _markFieldTouched(emit, passwordTouched: true);
  }

  void _onNameUnfocused(AuthNameUnfocused event, Emitter<AuthState> emit) {
    _markFieldTouched(emit, nameTouched: true);
  }

  void _markFieldTouched(
    Emitter<AuthState> emit, {
    bool emailTouched = false,
    bool passwordTouched = false,
    bool nameTouched = false,
  }) {
    state.mapOrNull(
      initial: (s) {
        if (emailTouched) {
          emit(
            s.copyWith(
              validation: s.validation.copyWith(emailTouched: true),
            ),
          );
        }
      },
      loginRequired: (s) => emit(
        s.copyWith(
          validation: s.validation.copyWith(
            emailTouched: emailTouched || s.validation.emailTouched,
            passwordTouched: passwordTouched || s.validation.passwordTouched,
          ),
        ),
      ),
      registrationRequired: (s) => emit(
        s.copyWith(
          validation: s.validation.copyWith(
            emailTouched: emailTouched || s.validation.emailTouched,
            passwordTouched: passwordTouched || s.validation.passwordTouched,
            nameTouched: nameTouched || s.validation.nameTouched,
          ),
        ),
      ),
    );
  }

  Future<void> _onEmailSubmitted(
    AuthEmailSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    await state.mapOrNull(
      initial: (s) async {
        if (!s.email.isValid) {
          emit(
            s.copyWith(validation: s.validation.copyWith(emailTouched: true)),
          );
          return;
        }

        emit(s.copyWith(isSubmitting: true, error: null));

        final result = await _checkUserExists(s.email);

        result.fold(
          (failure) => emit(
            s.copyWith(
              isSubmitting: false,
              error: ErrorModel.fromFailure(failure),
            ),
          ),
          (exists) {
            if (exists) {
              emit(
                AuthState.loginRequired(
                  email: s.email,
                  password: Password(''),
                  isSubmitting: false,
                  validation: FieldValidationState.initial(),
                ),
              );
            } else {
              emit(
                AuthState.registrationRequired(
                  email: s.email,
                  password: Password(''),
                  name: Name(''),
                  isSubmitting: false,
                  validation: FieldValidationState.initial(),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    await state.mapOrNull(
      loginRequired: (s) async {
        final credentials = AuthCredentials(
          email: s.email,
          password: s.password,
        );
        if (!credentials.isValidForLogin) {
          emit(
            s.copyWith(
              validation: FieldValidationState.allTouched(),
            ),
          );
          return;
        }

        emit(s.copyWith(isSubmitting: true, error: null));

        final result = await _login(credentials);

        result.fold(
          (failure) => emit(
            s.copyWith(
              isSubmitting: false,
              error: ErrorModel.fromFailure(failure),
              validation: FieldValidationState.allTouched(),
            ),
          ),
          (user) => _handleAuthSuccess(user, emit),
        );
      },
    );
  }

  Future<void> _onRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    await state.mapOrNull(
      registrationRequired: (s) async {
        final credentials = AuthCredentials(
          email: s.email,
          password: s.password,
          name: s.name,
        );
        if (!credentials.isValidForRegistration) {
          emit(
            s.copyWith(
              validation: FieldValidationState.allTouched(),
            ),
          );
          return;
        }

        emit(s.copyWith(isSubmitting: true, error: null));

        final result = await _register(credentials);

        result.fold(
          (failure) => emit(
            s.copyWith(
              isSubmitting: false,
              error: ErrorModel.fromFailure(failure),
              validation: FieldValidationState.allTouched(),
            ),
          ),
          (user) => _handleAuthSuccess(user, emit),
        );
      },
    );
  }

  void _handleAuthSuccess(User user, Emitter<AuthState> emit) {
    emit(AuthState.authenticated(user));
    add(const AuthWatchStarted());
    add(const AuthEvent.sessionWatchStarted());
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _logout();

    result.fold(
      (failure) => _logger.warning('$failure'),
      (_) => _logger.debug('Logout successful'),
    );

    emit(AuthState.empty());
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      await state.mapOrNull(
        authenticated: (_) async {
          _logger.debug(
            'Session expired from server, logging out and clearing tokens',
          );
          // Clear tokens and dispose WebSocket connection
          await _logout();
          // Emit unauthenticated first (triggers route redirect)
          emit(const AuthState.unauthenticated());
          // Then emit initial state (shows email form on auth page)
          emit(AuthState.empty());
        },
      );
    }
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    _logger.warning('Session expired - token refresh failed');
    await _logout();
    emit(const AuthState.unauthenticated());
  }
}
