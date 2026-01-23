import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/base/command.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:starter_app/features/auth/domain/value_objects/auth_token.dart';
import 'package:starter_app/features/auth/domain/value_objects/refresh_token.dart';

/// Command for refreshing an expired access token.
///
/// This is a **write operation** (Command) that mutates application state
/// by updating the stored authentication tokens.
///
/// Called automatically when access token expires during API requests.
/// Uses refresh token to obtain a new access token without re-login.
///
/// ## Validation Strategy
/// - Primary validation: Presentation layer / Interceptor
/// - Defensive validation: Here (Command) - safety net
///
/// ## Flow
/// 1. Validate refresh token
/// 2. Call repository to exchange for new access token
/// 3. Repository stores new token automatically
/// 4. Return new access token
///
/// Example:
/// ```dart
/// // In HTTP interceptor
/// if (response.statusCode == 401) {
///   final result = await refreshToken(storedRefreshToken);
///   result.fold(
///     (failure) => logout(), // Refresh failed, must re-login
///     (newToken) => retryRequest(newToken),
///   );
/// }
/// ```
@injectable
class RefreshTokenUseCase extends Command<RefreshToken, AuthToken> {
  const RefreshTokenUseCase(this._repository);

  final IAuthRepository _repository;

  /// Refreshes an expired access token.
  ///
  /// Returns:
  /// - [Right(AuthToken)] with new access token
  /// - [Left(Failure)] if validation fails or refresh fails
  @override
  FutureResult<AuthToken> call(RefreshToken token) async {
    // Delegate to repository
    return _repository.refreshToken(token);
  }
}
