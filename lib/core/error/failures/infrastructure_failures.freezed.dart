// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'infrastructure_failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InfrastructureFailure {

 String get message; StackTrace? get stackTrace;
/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfrastructureFailureCopyWith<InfrastructureFailure> get copyWith => _$InfrastructureFailureCopyWithImpl<InfrastructureFailure>(this as InfrastructureFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfrastructureFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'InfrastructureFailure(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $InfrastructureFailureCopyWith<$Res>  {
  factory $InfrastructureFailureCopyWith(InfrastructureFailure value, $Res Function(InfrastructureFailure) _then) = _$InfrastructureFailureCopyWithImpl;
@useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class _$InfrastructureFailureCopyWithImpl<$Res>
    implements $InfrastructureFailureCopyWith<$Res> {
  _$InfrastructureFailureCopyWithImpl(this._self, this._then);

  final InfrastructureFailure _self;
  final $Res Function(InfrastructureFailure) _then;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [InfrastructureFailure].
extension InfrastructureFailurePatterns on InfrastructureFailure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerFailure value)?  server,TResult Function( NetworkFailure value)?  network,TResult Function( CacheFailure value)?  cache,TResult Function( ParseFailure value)?  parse,TResult Function( CircuitBreakerFailure value)?  circuitBreaker,TResult Function( UnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that);case NetworkFailure() when network != null:
return network(_that);case CacheFailure() when cache != null:
return cache(_that);case ParseFailure() when parse != null:
return parse(_that);case CircuitBreakerFailure() when circuitBreaker != null:
return circuitBreaker(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerFailure value)  server,required TResult Function( NetworkFailure value)  network,required TResult Function( CacheFailure value)  cache,required TResult Function( ParseFailure value)  parse,required TResult Function( CircuitBreakerFailure value)  circuitBreaker,required TResult Function( UnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case ServerFailure():
return server(_that);case NetworkFailure():
return network(_that);case CacheFailure():
return cache(_that);case ParseFailure():
return parse(_that);case CircuitBreakerFailure():
return circuitBreaker(_that);case UnexpectedFailure():
return unexpected(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerFailure value)?  server,TResult? Function( NetworkFailure value)?  network,TResult? Function( CacheFailure value)?  cache,TResult? Function( ParseFailure value)?  parse,TResult? Function( CircuitBreakerFailure value)?  circuitBreaker,TResult? Function( UnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that);case NetworkFailure() when network != null:
return network(_that);case CacheFailure() when cache != null:
return cache(_that);case ParseFailure() when parse != null:
return parse(_that);case CircuitBreakerFailure() when circuitBreaker != null:
return circuitBreaker(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  int? statusCode,  StackTrace? stackTrace)?  server,TResult Function( String message,  StackTrace? stackTrace)?  network,TResult Function( String message,  StackTrace? stackTrace)?  cache,TResult Function( String message,  StackTrace? stackTrace)?  parse,TResult Function( String message,  StackTrace? stackTrace)?  circuitBreaker,TResult Function( String message,  StackTrace? stackTrace)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that.message,_that.statusCode,_that.stackTrace);case NetworkFailure() when network != null:
return network(_that.message,_that.stackTrace);case CacheFailure() when cache != null:
return cache(_that.message,_that.stackTrace);case ParseFailure() when parse != null:
return parse(_that.message,_that.stackTrace);case CircuitBreakerFailure() when circuitBreaker != null:
return circuitBreaker(_that.message,_that.stackTrace);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.message,_that.stackTrace);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  int? statusCode,  StackTrace? stackTrace)  server,required TResult Function( String message,  StackTrace? stackTrace)  network,required TResult Function( String message,  StackTrace? stackTrace)  cache,required TResult Function( String message,  StackTrace? stackTrace)  parse,required TResult Function( String message,  StackTrace? stackTrace)  circuitBreaker,required TResult Function( String message,  StackTrace? stackTrace)  unexpected,}) {final _that = this;
switch (_that) {
case ServerFailure():
return server(_that.message,_that.statusCode,_that.stackTrace);case NetworkFailure():
return network(_that.message,_that.stackTrace);case CacheFailure():
return cache(_that.message,_that.stackTrace);case ParseFailure():
return parse(_that.message,_that.stackTrace);case CircuitBreakerFailure():
return circuitBreaker(_that.message,_that.stackTrace);case UnexpectedFailure():
return unexpected(_that.message,_that.stackTrace);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  int? statusCode,  StackTrace? stackTrace)?  server,TResult? Function( String message,  StackTrace? stackTrace)?  network,TResult? Function( String message,  StackTrace? stackTrace)?  cache,TResult? Function( String message,  StackTrace? stackTrace)?  parse,TResult? Function( String message,  StackTrace? stackTrace)?  circuitBreaker,TResult? Function( String message,  StackTrace? stackTrace)?  unexpected,}) {final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that.message,_that.statusCode,_that.stackTrace);case NetworkFailure() when network != null:
return network(_that.message,_that.stackTrace);case CacheFailure() when cache != null:
return cache(_that.message,_that.stackTrace);case ParseFailure() when parse != null:
return parse(_that.message,_that.stackTrace);case CircuitBreakerFailure() when circuitBreaker != null:
return circuitBreaker(_that.message,_that.stackTrace);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.message,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class ServerFailure extends InfrastructureFailure {
  const ServerFailure({required this.message, this.statusCode, this.stackTrace}): super._();
  

@override final  String message;
 final  int? statusCode;
@override final  StackTrace? stackTrace;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,statusCode,stackTrace);

@override
String toString() {
  return 'InfrastructureFailure.server(message: $message, statusCode: $statusCode, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $InfrastructureFailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, int? statusCode, StackTrace? stackTrace
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? statusCode = freezed,Object? stackTrace = freezed,}) {
  return _then(ServerFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class NetworkFailure extends InfrastructureFailure {
  const NetworkFailure({this.message = 'Network error', this.stackTrace}): super._();
  

@override@JsonKey() final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'InfrastructureFailure.network(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $InfrastructureFailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class CacheFailure extends InfrastructureFailure {
  const CacheFailure({this.message = 'Cache error', this.stackTrace}): super._();
  

@override@JsonKey() final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheFailureCopyWith<CacheFailure> get copyWith => _$CacheFailureCopyWithImpl<CacheFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'InfrastructureFailure.cache(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $CacheFailureCopyWith<$Res> implements $InfrastructureFailureCopyWith<$Res> {
  factory $CacheFailureCopyWith(CacheFailure value, $Res Function(CacheFailure) _then) = _$CacheFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class _$CacheFailureCopyWithImpl<$Res>
    implements $CacheFailureCopyWith<$Res> {
  _$CacheFailureCopyWithImpl(this._self, this._then);

  final CacheFailure _self;
  final $Res Function(CacheFailure) _then;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(CacheFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class ParseFailure extends InfrastructureFailure {
  const ParseFailure({this.message = 'Parse error', this.stackTrace}): super._();
  

@override@JsonKey() final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseFailureCopyWith<ParseFailure> get copyWith => _$ParseFailureCopyWithImpl<ParseFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'InfrastructureFailure.parse(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $ParseFailureCopyWith<$Res> implements $InfrastructureFailureCopyWith<$Res> {
  factory $ParseFailureCopyWith(ParseFailure value, $Res Function(ParseFailure) _then) = _$ParseFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class _$ParseFailureCopyWithImpl<$Res>
    implements $ParseFailureCopyWith<$Res> {
  _$ParseFailureCopyWithImpl(this._self, this._then);

  final ParseFailure _self;
  final $Res Function(ParseFailure) _then;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(ParseFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class CircuitBreakerFailure extends InfrastructureFailure {
  const CircuitBreakerFailure({this.message = 'Service temporarily unavailable', this.stackTrace}): super._();
  

@override@JsonKey() final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircuitBreakerFailureCopyWith<CircuitBreakerFailure> get copyWith => _$CircuitBreakerFailureCopyWithImpl<CircuitBreakerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircuitBreakerFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'InfrastructureFailure.circuitBreaker(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $CircuitBreakerFailureCopyWith<$Res> implements $InfrastructureFailureCopyWith<$Res> {
  factory $CircuitBreakerFailureCopyWith(CircuitBreakerFailure value, $Res Function(CircuitBreakerFailure) _then) = _$CircuitBreakerFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class _$CircuitBreakerFailureCopyWithImpl<$Res>
    implements $CircuitBreakerFailureCopyWith<$Res> {
  _$CircuitBreakerFailureCopyWithImpl(this._self, this._then);

  final CircuitBreakerFailure _self;
  final $Res Function(CircuitBreakerFailure) _then;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(CircuitBreakerFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class UnexpectedFailure extends InfrastructureFailure {
  const UnexpectedFailure({this.message = 'An unexpected error occurred', this.stackTrace}): super._();
  

@override@JsonKey() final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedFailureCopyWith<UnexpectedFailure> get copyWith => _$UnexpectedFailureCopyWithImpl<UnexpectedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'InfrastructureFailure.unexpected(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $UnexpectedFailureCopyWith<$Res> implements $InfrastructureFailureCopyWith<$Res> {
  factory $UnexpectedFailureCopyWith(UnexpectedFailure value, $Res Function(UnexpectedFailure) _then) = _$UnexpectedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class _$UnexpectedFailureCopyWithImpl<$Res>
    implements $UnexpectedFailureCopyWith<$Res> {
  _$UnexpectedFailureCopyWithImpl(this._self, this._then);

  final UnexpectedFailure _self;
  final $Res Function(UnexpectedFailure) _then;

/// Create a copy of InfrastructureFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(UnexpectedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
