/// Infrastructure layer exceptions.
///
/// These exceptions are thrown in the infrastructure layer (data sources)
/// and should be caught and converted to domain Failure types in repositories.
///
/// **Important**: Exceptions should NEVER escape the infrastructure layer.
/// Always catch them in repositories and convert to `Either<Failure, T>`.
///
/// Usage:
/// ```dart
/// // In Repository
/// import 'package:starter_app/core/error/exceptions/exceptions.dart';
/// import 'package:starter_app/core/error/failures/failures.dart';
///
/// try {
///   final data = await _dataSource.getData();
///   return Right(data);
/// } on ServerException catch (e) {
///   return Left(InfrastructureFailure.server(message: e.message));
/// } on NetworkException catch (e) {
///   return Left(InfrastructureFailure.network(message: e.message));
/// } on CacheException catch (e) {
///   return Left(InfrastructureFailure.cache(message: e.message));
/// } on FormatException catch (e) {
///   return Left(InfrastructureFailure.parse(message: e.message));
/// }
/// ```
library;

export 'cache_exception.dart';
export 'circuit_breaker_exception.dart';
export 'network_exception.dart';
export 'server_exception.dart';
