import 'package:http/http.dart' as http;
import 'package:starter_app/core/infrastructure/networking/i_http_client_factory_interface.dart';

/// Web implementation of [IHttpClientFactory].
///
/// On Web, we rely on the browser's native networking stack.
/// Browsers do not support SSL pinning in the same way native apps do.
class HttpClientFactoryWeb implements IHttpClientFactory {
  const HttpClientFactoryWeb();

  @override
  http.Client createClient({List<int>? trustedCertificateBytes}) {
    return http.Client();
  }
}

IHttpClientFactory createFactory() => const HttpClientFactoryWeb();
