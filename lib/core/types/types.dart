/// Common type definitions used throughout the application.
///
/// These typedefs improve code readability and provide semantic meaning
/// to commonly used types, especially for functional programming patterns
/// with Either types.
library;

import 'package:fpdart/fpdart.dart';

import 'package:starter_app/core/error/failures/failure.dart';

// JSON Types

/// Represents a JSON object as a Map with String keys and dynamic values.
///
/// Commonly used for API responses, serialization, and data transfer objects.
///
/// Usage:
/// ```dart
/// Json user = {'name': 'John', 'age': 30};
/// final name = user['name'] as String;
/// ```
typedef Json = Map<String, dynamic>;

/// Represents a list of JSON objects.
///
/// Commonly used for API responses returning collections.
///
/// Usage:
/// ```dart
/// JsonList users = [
///   {'name': 'John', 'age': 30},
///   {'name': 'Jane', 'age': 25},
/// ];
/// ```
typedef JsonList = List<Json>;

// Either Type Aliases for Functional Error Handling

/// Represents the result of an operation that can fail.
///
/// - Left: Contains a [Failure] when the operation fails
/// - Right: Contains the success value of type [T]
///
/// This is the base type for all operations that can fail in the application.
///
/// Usage:
/// ```dart
/// FutureResult<User> getUser(String id) async {
///   try {
///     final user = await api.fetchUser(id);
///     return Right(user);
///   } catch (e) {
///     return Left(Failure.server(message: e.toString()));
///   }
/// }
/// ```
typedef Result<T> = Either<Failure, T>;

/// Represents an asynchronous operation that can fail.
///
/// Combines Future with Either for async operations.
///
/// Usage:
/// ```dart
/// FutureResult<List<Product>> fetchProducts() async {
///   final response = await api.getProducts();
///   return response.fold(
///     (failure) => Left(failure),
///     (products) => Right(products),
///   );
/// }
/// ```
typedef FutureResult<T> = Future<Result<T>>;

/// Represents a stream of results that can fail.
///
/// Useful for real-time data or reactive programming.
///
/// Usage:
/// ```dart
/// StreamResult<Message> watchMessages() {
///   return messageStream.map((message) => Right(message))
///     .handleError((error) =>
/// Left(Failure.unexpected(message: error.toString())));
/// }
/// ```
typedef StreamResult<T> = Stream<Result<T>>;

/// Represents a result that returns no value on success ([Unit]).
///
/// Useful for operations like delete, update,
/// or any action that doesn't return data.
///
/// Usage:
/// ```dart
/// FutureVoidResult deleteUser(String id) async {
///   try {
///     await api.deleteUser(id);
///     return const Right(unit);
///   } catch (e) {
///     return Left(Failure.server(message: e.toString()));
///   }
/// }
/// ```
typedef VoidResult = Result<Unit>;

/// Represents an asynchronous operation that returns no value on success.
///
/// Usage:
/// ```dart
/// FutureVoidResult logout() async {
///   await authService.logout();
///   return const Right(unit);
/// }
/// ```
typedef FutureVoidResult = Future<VoidResult>;

/// Represents a result with a specific failure type.
///
/// Useful when you want to be explicit about the failure type.
///
/// Usage:
/// ```dart
/// TypedResult<ValidationFailure, String> validateEmail(String email) {
///   if (email.isEmpty) {
///     return Left(ValidationFailure.empty());
///   }
///   return Right(email);
/// }
/// ```
typedef TypedResult<F, T> = Either<F, T>;

/// Represents an asynchronous operation with a specific failure type.
///
/// Usage:
/// ```dart
/// FutureTypedResult<NetworkFailure, Data> fetchData() async {
///   try {
///     final data = await api.getData();
///     return Right(data);
///   } catch (e) {
///     return Left(NetworkFailure(message: e.toString()));
///   }
/// }
/// ```
typedef FutureTypedResult<F, T> = Future<TypedResult<F, T>>;

// Dependency Injection Types

/// Function signature for resolving dependencies.
///
/// Used to abstract the dependency injection mechanism (e.g. GetIt) from
/// the application code, particularly in bootstrap logic.
typedef DependencyResolver = T Function<T extends Object>();
