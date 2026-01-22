import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';

/// Network error handler that converts connection errors to NetworkException.
///
/// Wraps Chopper client errors (timeouts, no connection, etc.) into
/// our custom `NetworkException` type.
final class NetworkErrorHandler {
  const NetworkErrorHandler();

  /// Handle network-related errors
  Never handleError(Object error, StackTrace stackTrace) {
    if (error is SocketException) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        originalError: error,
      );
    } else if (error is CircuitBreakerException) {
      throw NetworkException(
        message: error.message,
        originalError: error,
      );
    } else if (error is TimeoutException) {
      throw NetworkException(
        message: 'Request timeout. Please try again.',
        originalError: error,
      );
    } else if (error is ChopperHttpException) {
      throw NetworkException(
        message: 'Network error: ${error.response.error}',
        originalError: error,
      );
    } else if (error is ChopperException) {
      throw NetworkException(
        message: 'Network error: ${error.message}',
        originalError: error,
      );
    } else {
      // Unknown error
      throw NetworkException(
        message: 'An unexpected network error occurred',
        originalError: error,
      );
    }
  }
}
