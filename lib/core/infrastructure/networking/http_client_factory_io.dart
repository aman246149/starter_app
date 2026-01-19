import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:starter_app/core/infrastructure/networking/i_http_client_factory_interface.dart';

/// IO implementation of [IHttpClientFactory].
///
/// Supports SSL pinning via [SecurityContext].
class HttpClientFactoryIo implements IHttpClientFactory {
  const HttpClientFactoryIo();

  @override
  http.Client createClient({List<int>? trustedCertificateBytes}) {
    final context = SecurityContext.defaultContext;

    // Apply SSL Pinning if certificate is provided
    if (trustedCertificateBytes != null && trustedCertificateBytes.isNotEmpty) {
      try {
        context.setTrustedCertificatesBytes(trustedCertificateBytes);
      } on TlsException catch (e) {
        if (e.osError?.message.contains('CERT_ALREADY_IN_HASH_TABLE') != true) {
          rethrow;
        }
      }
    }

    final httpClient = HttpClient(context: context);
    return IOClient(httpClient);
  }
}

IHttpClientFactory createFactory() => const HttpClientFactoryIo();
