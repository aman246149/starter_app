import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_token_storage.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/infrastructure/base_repository.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:starter_app/features/auth/domain/value_objects/auth_token.dart';
import 'package:starter_app/features/auth/domain/value_objects/refresh_token.dart';
import 'package:starter_app/features/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'package:starter_app/features/auth/infrastructure/datasources/auth_websocket_data_source.dart';
import 'package:starter_app/features/auth/infrastructure/mappers/auth_exception_mapper.dart';
import 'package:starter_app/features/auth/infrastructure/models/check_user_exists_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/login_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/register_request_model.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl extends BaseRepository implements IAuthRepository {
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._webSocketDataSource,
    this._tokenStorage,
    ExceptionHandler exceptionHandler,
    AuthExceptionMapper failureMapper,
  ) : super(exceptionHandler, failureMapper);

  final IAuthRemoteDataSource _remoteDataSource;
  final IAuthWebSocketDataSource _webSocketDataSource;
  final ITokenStorage _tokenStorage;

  @override
  FutureResult<bool> checkUserExists(EmailAddress email) => execute(
    () async {
      final result = await _remoteDataSource.checkUserExists(
        CheckUserExistsRequestModel(email: email.getOrCrash()),
      );
      return result;
    },
  );

  @override
  FutureResult<User> login(AuthCredentials credentials) => execute(
    () async {
      final result = await _remoteDataSource.login(
        LoginRequestModel(
          email: credentials.email.getOrCrash(),
          password: credentials.password.getOrCrash(),
        ),
      );
      await _tokenStorage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );

      final user = result.user.toDomain();
      // Event dispatching moved to UseCase

      return user;
    },
  );

  @override
  FutureResult<User> register(AuthCredentials credentials) => execute(
    () async {
      final name = credentials.name;
      if (name == null) {
        throw const ServerException(
          message: 'Name is required for registration',
          statusCode: 400,
        );
      }
      final result = await _remoteDataSource.register(
        RegisterRequestModel(
          email: credentials.email.getOrCrash(),
          password: credentials.password.getOrCrash(),
          name: name.getOrCrash(),
        ),
      );
      await _tokenStorage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );

      final user = result.user.toDomain();
      // Event dispatching moved to UseCase

      return user;
    },
  );

  @override
  FutureResult<Unit> logout() => execute(
    () async {
      await _remoteDataSource.logout();
      await _tokenStorage.clearTokens();
      // Dispose WebSocket to reset _isWatching flag,
      // allowing fresh connection on next login
      await _webSocketDataSource.dispose();
      return unit;
    },
  );

  @override
  FutureResult<AuthToken> refreshToken(RefreshToken token) => execute(
    () async {
      final result = await _remoteDataSource.refreshToken(
        token.getOrCrash(),
      );
      await _tokenStorage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      // Use fromTrustedSource since token comes from authenticated backend
      return AuthToken.fromTrustedSource(result.accessToken);
    },
  );

  @override
  FutureResult<User?> getCurrentUser() => execute(
    () async {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) {
        return null;
      }
      final userModel = await _remoteDataSource.getCurrentUser();
      return userModel.toDomain();
    },
  );

  @override
  StreamResult<User?> watchAuthChanges() {
    // Use WebSocket data source for real-time auth state changes
    // Transform stream to emit
    // Either<Failure, User?> for both success and error
    return _webSocketDataSource.watchAuthChanges().transform(
      StreamTransformer.fromHandlers(
        handleData: (userModel, sink) => sink.add(right(userModel?.toDomain())),
        handleError: (error, stackTrace, sink) {
          final failure = switch (error) {
            final ServerException e => InfrastructureFailure.server(
              message: e.message,
              statusCode: e.statusCode,
            ),
            final NetworkException e => InfrastructureFailure.network(
              message: e.message,
            ),
            final CacheException e => InfrastructureFailure.cache(
              message: e.message,
            ),
            final FormatException e => InfrastructureFailure.parse(
              message: e.message,
            ),
            _ => InfrastructureFailure.parse(
              message: 'An unexpected error occurred: $error',
            ),
          };
          sink.add(left(failure));
        },
      ),
    );
  }
}
