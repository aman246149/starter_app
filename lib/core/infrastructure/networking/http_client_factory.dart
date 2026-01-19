import 'package:starter_app/core/infrastructure/networking/http_client_factory_io.dart'
    if (dart.library.html) 'package:starter_app/core/infrastructure/networking/http_client_factory_web.dart';
import 'package:starter_app/core/infrastructure/networking/i_http_client_factory_interface.dart';

export 'package:starter_app/core/infrastructure/networking/i_http_client_factory_interface.dart';

/// Returns the platform-specific implementation of [IHttpClientFactory].
IHttpClientFactory getHttpClientFactory() => createFactory();
