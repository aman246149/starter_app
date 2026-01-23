import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/features/auth/infrastructure/datasources/auth_endpoints.dart';

part 'auth_api_service.chopper.dart';

/// Authentication API service.
///
/// All endpoint paths are defined in [AuthEndpoints] to ensure consistency
/// within the auth feature. This service uses those constants directly.
///
/// **Endpoint Management:**
/// - All paths come from [AuthEndpoints] constants
/// - Version is managed centrally via --dart-define
/// - No hardcoded paths in service methods
///
/// **Base URL Configuration:**
/// The ChopperClient baseUrl is set to just the domain
/// (e.g., 'https://api.example.com'), so all paths in this service
/// must include the full API path with version.

@lazySingleton
@ChopperApi(baseUrl: AuthEndpoints.authBasePath)
abstract class AuthApiService extends ChopperService {
  /// Create an instance of the service
  @factoryMethod
  static AuthApiService create(ChopperClient client) =>
      _$AuthApiService(client);

  /// Login with email and password.
  ///
  /// Returns authentication token and user data.
  @POST(path: AuthEndpoints.login)
  Future<Response<Map<String, dynamic>>> login(
    @Body() Map<String, dynamic> credentials,
  );

  /// Logout current user.
  ///
  /// Invalidates the authentication token on the server.
  @POST(path: AuthEndpoints.logout)
  Future<Response<void>> logout();

  /// Register a new user account.
  ///
  /// Returns authentication token and user data.
  @POST(path: AuthEndpoints.register)
  Future<Response<Map<String, dynamic>>> register(
    @Body() Map<String, dynamic> userData,
  );

  /// Refresh authentication token.
  ///
  /// Uses refresh token to get a new access token.
  @POST(path: AuthEndpoints.refreshToken)
  Future<Response<Map<String, dynamic>>> refreshToken(
    @Body() Map<String, dynamic> refreshData,
  );

  /// Get current user profile.
  ///
  /// Requires authentication token.
  @GET(path: AuthEndpoints.currentUser)
  Future<Response<Map<String, dynamic>>> getCurrentUser();

  /// Update current user profile.
  ///
  /// Requires authentication token.
  @PUT(path: AuthEndpoints.currentUser)
  Future<Response<Map<String, dynamic>>> updateProfile(
    @Body() Map<String, dynamic> profileData,
  );

  /// Check if user exists.
  @POST(path: AuthEndpoints.checkUserExists)
  Future<Response<Map<String, dynamic>>> checkUserExists(
    @Body() Map<String, dynamic> userData,
  );
}
