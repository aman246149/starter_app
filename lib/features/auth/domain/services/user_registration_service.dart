import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/base/domain_service.dart';
import 'package:starter_app/core/domain/base/event_dispatcher.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';

/// Domain Service for User Registration.
///
/// Orchestrates user registration and dispatches domain events.
/// Profile creation is now handled by the backend in the same transaction.
///
/// **Strict DDD:** This logic involves
///  cross-cutting concerns (registration + events),
/// so it belongs in a Domain Service, not an Entity or Use Case.
@injectable
class UserRegistrationService extends DomainService {
  UserRegistrationService(
    this._authRepository,
    this._eventDispatcher,
  );

  final IAuthRepository _authRepository;
  final IEventDispatcher _eventDispatcher;

  /// Registers a new user.
  ///
  /// Credentials must include name for registration.
  /// Backend handles profile creation automatically.
  FutureResult<User> register({
    required AuthCredentials credentials,
  }) async {
    // Create Auth User (backend auto-creates profile)
    final userResult = await _authRepository.register(credentials);

    return userResult.fold(
      Left.new,
      (user) {
        // Dispatch Event for cross-feature communication
        _eventDispatcher.dispatch(UserRegistered(user));
        return Right(user);
      },
    );
  }
}
