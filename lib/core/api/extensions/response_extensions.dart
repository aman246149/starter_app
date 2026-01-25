import 'package:chopper/chopper.dart';

/// Extensions for Chopper Response.
extension ResponseX<T> on Response<T> {
  /// Returns body or throws FormatException for endpoints that expect a body.
  ///
  /// Use for GET/POST endpoints that return data.
  /// Don't use for DELETE/logout endpoints that return 204 No Content.
  ///
  /// Example:
  /// ```dart
  /// // Profile API (expects body)
  /// return UserProfileModel.fromJson(response.requireBody);
  ///
  /// // Logout API (no body expected) - use response directly
  /// await _apiService.logout(); // returns Response<void>
  /// ```
  T get requireBody {
    final body = this.body;
    if (body == null) {
      throw const FormatException('Expected response body but got null');
    }
    return body;
  }
}
