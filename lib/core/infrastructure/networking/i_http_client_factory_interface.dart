import 'package:http/http.dart' as http;

/// Interface for creating HTTP clients.
///
/// This factory pattern allows us to:
/// 1. Abstract away platform differences (IO vs Web)
/// 2. Inject security configurations (SSL Pinning)
/// 3. Provide mockable clients for testing
abstract class IHttpClientFactory {
  /// Creates a new HTTP client.
  ///
  /// [trustedCertificateBytes] - Optional. Raw bytes of the trusted certificate
  /// for SSL pinning. If provided and supported by the platform, the client
  /// will only trust connections using this certificate.
  http.Client createClient({List<int>? trustedCertificateBytes});
}
