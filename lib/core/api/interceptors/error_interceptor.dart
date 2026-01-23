import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:starter_app/core/api/interceptors/network_error_handler.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';
import 'package:starter_app/core/error/failures/failures.dart' show Failure;

/// Error handling interceptor that converts HTTP errors to domain exceptions.
///
/// Converts Chopper/HTTP errors into our custom exception types:
/// - [ServerException]: 4xx/5xx responses
/// - [NetworkException]: Connection/timeout errors (via [NetworkErrorHandler])
///
/// These exceptions are then converted to [Failure] objects in repositories.
final class ErrorInterceptor implements Interceptor {
  const ErrorInterceptor(this._networkErrorHandler);

  final NetworkErrorHandler _networkErrorHandler;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    try {
      final response = await chain.proceed(chain.request);

      // If response is not successful, handle error
      if (!response.isSuccessful) {
        _handleErrorResponse(response);
      }

      return response;
    } catch (error, stackTrace) {
      // ServerException should be rethrown, not converted to NetworkException
      if (error is ServerException) {
        rethrow;
      }
      // Use NetworkErrorHandler to properly categorize errors
      _networkErrorHandler.handleError(error, stackTrace);
    }
  }

  /// Handle non-successful HTTP responses
  Never _handleErrorResponse(Response<dynamic> response) {
    final statusCode = response.statusCode;
    // Try to extract error message from response error
    String? errorMessage;
    // Chopper puts error response data in response.error
    final errorData = response.error;
    if (errorData is Map<String, dynamic>) {
      errorMessage = errorData['message'] as String?;
    } else if (errorData is String) {
      errorMessage = errorData;
    }

    // Use Chopper's built-in reason phrase as fallback
    final defaultMessage = response.base.reasonPhrase ?? 'HTTP Error';

    throw ServerException(
      message: errorMessage ?? defaultMessage,
      statusCode: statusCode,
    );
  }
}
