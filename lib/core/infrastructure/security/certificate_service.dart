import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_certificate_service.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';

/// Service responsible for loading and managing SSL certificates.
///
/// This service loads certificates from assets during bootstrap so they are
/// available synchronously when creating the HTTP client.
@Singleton(as: ICertificateService)
class CertificateService implements ICertificateService {
  CertificateService(this._logger);

  final IAppLogger _logger;

  /// content of the trusted certificate in bytes.
  List<int>? _trustedCertificateBytes;

  /// Returns the trusted certificate bytes.
  ///
  /// Returns null if:
  /// - Service hasn't been initialized
  /// - Certificate file wasn't found
  /// - SSL pinning is disabled/not configured
  @override
  List<int>? get trustedCertificateBytes => _trustedCertificateBytes;

  /// Initializes the service by loading the certificate from assets.
  ///
  /// Should be called during app bootstrap.
  @override
  Future<void> initialize() async {
    try {
      // In a real scenario, you might load this path from config
      // or try multiple common names.
      const certPath = 'assets/certificates/server.pem';

      try {
        final byteData = await rootBundle.load(certPath);
        _trustedCertificateBytes = byteData.buffer.asUint8List();
        _logger.info(
          'SSL certificate loaded successfully',
          tag: 'CertificateService',
        );
      } catch (e) {
        // It's okay if the file is missing in Dev, but we log it.
        if (e.toString().contains('Unable to load asset') ||
            e.toString().contains('not found')) {
          _logger.info(
            '''No SSL certificate found at $certPath. Pinning will be disabled if requested.''',
            tag: 'CertificateService',
          );
        } else {
          rethrow;
        }
      }
    } on Exception catch (e, stack) {
      _logger.error(
        'Failed to load SSL certificate',
        error: e,
        stackTrace: stack,
        tag: 'CertificateService',
      );
    }
  }
}
