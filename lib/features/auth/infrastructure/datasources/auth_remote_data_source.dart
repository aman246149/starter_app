import 'package:injectable/injectable.dart';
import 'package:starter_app/core/api/extensions/response_extensions.dart';
import 'package:starter_app/core/infrastructure/base_remote_data_source.dart';
import 'package:starter_app/features/auth/infrastructure/datasources/auth_api_service.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_response_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_tokens_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/check_user_exists_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/check_user_exists_response_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/login_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/register_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/user_model.dart';

/// Defines the contract for remote authentication data operations.
abstract class IAuthRemoteDataSource {
  /// Checks if a user exists for the given email.
  Future<bool> checkUserExists(CheckUserExistsRequestModel request);

  /// Logs in a user with credentials.
  Future<AuthResponseModel> login(LoginRequestModel request);

  /// Registers a new user.
  Future<AuthResponseModel> register(RegisterRequestModel request);

  /// Logs out the current user.
  Future<void> logout();

  /// Refreshes the authentication tokens.
  Future<AuthTokensModel> refreshToken(String refreshToken);

  /// Fetches the current authenticated user's profile.
  Future<UserModel> getCurrentUser();
}

/// Implementation of [IAuthRemoteDataSource] that uses [AuthApiService].
///
/// This implementation relies on a Chopper `ErrorInterceptor` to handle
/// non-successful responses by throwing a `ServerException`. Therefore,
/// the methods here do not need to check `response.isSuccessful` and can
/// assume a successful response if no exception is thrown.
@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements IAuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiService);
  final AuthApiService _apiService;

  @override
  Future<bool> checkUserExists(CheckUserExistsRequestModel request) => execute(
    () async {
      final response = await _apiService.checkUserExists(request.toJson());
      return CheckUserExistsResponseModel.fromJson(response.requireBody).exists;
    },
  );

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) =>
      execute(() async {
        final response = await _apiService.login(request.toJson());
        return AuthResponseModel.fromJson(response.requireBody);
      });

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) =>
      execute(() async {
        final response = await _apiService.register(request.toJson());
        return AuthResponseModel.fromJson(response.requireBody);
      });

  @override
  Future<void> logout() => execute(() async {
    // The logout endpoint returns a 204 No Content on success.
    // The interceptor will throw if it's not a successful status code.
    await _apiService.logout();
  });

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) => execute(
    () async {
      final response = await _apiService.refreshToken({'token': refreshToken});
      return AuthTokensModel.fromJson(response.requireBody);
    },
  );

  @override
  Future<UserModel> getCurrentUser() => execute(() async {
    final response = await _apiService.getCurrentUser();
    return UserModel.fromJson(response.requireBody);
  });
}
