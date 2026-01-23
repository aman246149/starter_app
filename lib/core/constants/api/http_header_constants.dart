/// HTTP header constants for API requests.
abstract final class HttpHeaderConstants {
  // Standard HTTP Headers
  /// Content-Type header key
  static const String contentType = 'Content-Type';

  /// Accept header key
  static const String accept = 'Accept';

  /// Authorization header key
  static const String authorization = 'Authorization';

  /// User-Agent header key
  static const String userAgent = 'User-Agent';

  // Custom Headers
  /// API Key header key
  static const String apiKey = 'X-Api-Key';

  /// Device ID header key
  static const String deviceId = 'X-Device-Id';

  /// Platform header key
  static const String platform = 'X-Platform';

  /// App Version header key
  static const String appVersion = 'X-App-Version';

  // Content Types
  /// JSON content type
  static const String json = 'application/json';

  /// Form URL encoded content type
  static const String formUrlEncoded = 'application/x-www-form-urlencoded';

  /// Multipart form data content type
  static const String multipartFormData = 'multipart/form-data';

  /// Plain text content type
  static const String plainText = 'text/plain';
}
