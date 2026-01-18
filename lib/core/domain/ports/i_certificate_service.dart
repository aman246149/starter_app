/// Port interface for certificate management.
///
/// Provides SSL/TLS certificate loading for secure connections.
/// Used by bootstrap to initialize certificates before HTTP client creation.
///
/// **Implementation:**
/// - `CertificateService` in `infrastructure/security/` - Loads certificates
///   from assets
abstract class ICertificateService {
  /// Returns the trusted certificate bytes.
  ///
  /// Returns null if:
  /// - Service hasn't been initialized
  /// - Certificate file wasn't found
  /// - SSL pinning is disabled/not configured
  List<int>? get trustedCertificateBytes;

  /// Initializes the service by loading certificates.
  ///
  /// Should be called during app bootstrap before HTTP client creation.
  Future<void> initialize();
}
