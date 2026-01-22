import 'dart:async' show FutureOr;

import 'package:chopper/chopper.dart';

/// API Key interceptor for services that use API keys.
///
/// Adds an API key to requests via header or query parameter.
final class ApiKeyInterceptor implements Interceptor {
  const ApiKeyInterceptor({
    required this.apiKey,
    this.headerName = 'X-API-Key',
    this.useHeader = true,
  });

  /// The API key to use
  final String apiKey;

  /// Header name for the API key (default: 'X-API-Key')
  final String headerName;

  /// Whether to add as header (true) or query parameter (false)
  final bool useHeader;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;

    if (useHeader) {
      // Add API key as header
      final authenticatedRequest = applyHeader(
        request,
        headerName,
        apiKey,
      );
      return chain.proceed(authenticatedRequest);
    } else {
      // Add API key as query parameter using Chopper's parameters
      // Merge existing parameters with the new api_key
      final existingParams = Map<String, dynamic>.from(request.parameters)
        ..remove('api_key')
        ..['api_key'] = apiKey;

      final authenticatedRequest = request.copyWith(parameters: existingParams);
      return chain.proceed(authenticatedRequest);
    }
  }
}
