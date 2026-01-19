import 'package:flutter/foundation.dart';

/// Base class for all remote data source implementations.
///
/// Provides common error handling functionality to convert Dart [Error] types
/// (like TypeError from JSON parsing) into [Exception] types that can be
/// properly handled by the exception handler.
///
/// This is necessary because JSON parsing errors often throw [Error] types
/// (e.g., TypeError, CheckedFromJsonException) which should not be caught
/// according to Dart best practices.
///  This class converts them to [FormatException]
/// at the data source boundary.
///
/// Usage:
/// ```dart
/// @LazySingleton(as: IAuthRemoteDataSource)
/// class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
///     implements IAuthRemoteDataSource {
///   AuthRemoteDataSourceImpl(this._apiService);
///   final AuthApiService _apiService;
///
///   @override
///   Future<bool> checkUserExists(CheckUserExistsRequestModel request) =>
///     execute(() async {
///       final response = await _apiService.checkUserExists(request.toJson());
///       return CheckUserExistsResponseModel.fromJson(response.body!).exists;
///     });
/// }
/// ```
abstract class BaseRemoteDataSource {
  const BaseRemoteDataSource();

  /// Executes a data source operation with
  /// automatic error-to-exception conversion.
  ///
  /// This method wraps the given [operation] with error handling logic,
  /// converting any [Error] types (e.g., JSON parsing errors) into
  /// [FormatException] so they can be properly handled upstream.
  ///
  /// Parameters:
  /// - [operation]: The async operation to execute
  /// (typically an API call + parsing)
  ///
  /// Returns:
  /// - The result of the operation if successful
  ///
  /// Throws:
  /// - [FormatException] if an [Error] occurs during the operation
  /// - Any [Exception] thrown by the operation (passes through unchanged)
  @protected
  Future<T> execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on Exception {
      // Exceptions should pass through unchanged
      rethrow;
    } catch (e, stackTrace) {
      // Convert any Error types to FormatException
      throw FormatException(
        'Data parsing failed: ${e.runtimeType}: $e\n'
        'Stack trace:\n$stackTrace',
      );
    }
  }
}
