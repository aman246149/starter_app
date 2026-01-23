// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {

 String get message; StackTrace? get stackTrace;
/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<AuthFailure> get copyWith => _$AuthFailureCopyWithImpl<AuthFailure>(this as AuthFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'AuthFailure(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $AuthFailureCopyWith<$Res>  {
  factory $AuthFailureCopyWith(AuthFailure value, $Res Function(AuthFailure) _then) = _$AuthFailureCopyWithImpl;
@useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class _$AuthFailureCopyWithImpl<$Res>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._self, this._then);

  final AuthFailure _self;
  final $Res Function(AuthFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NotFoundFailure value)?  notFound,TResult Function( _UnauthorizedFailure value)?  unauthorized,TResult Function( _ForbiddenFailure value)?  forbidden,TResult Function( _EmailAlreadyInUseFailure value)?  emailAlreadyInUse,TResult Function( _InvalidInputFailure value)?  invalidInput,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotFoundFailure() when notFound != null:
return notFound(_that);case _UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case _ForbiddenFailure() when forbidden != null:
return forbidden(_that);case _EmailAlreadyInUseFailure() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case _InvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NotFoundFailure value)  notFound,required TResult Function( _UnauthorizedFailure value)  unauthorized,required TResult Function( _ForbiddenFailure value)  forbidden,required TResult Function( _EmailAlreadyInUseFailure value)  emailAlreadyInUse,required TResult Function( _InvalidInputFailure value)  invalidInput,}){
final _that = this;
switch (_that) {
case _NotFoundFailure():
return notFound(_that);case _UnauthorizedFailure():
return unauthorized(_that);case _ForbiddenFailure():
return forbidden(_that);case _EmailAlreadyInUseFailure():
return emailAlreadyInUse(_that);case _InvalidInputFailure():
return invalidInput(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NotFoundFailure value)?  notFound,TResult? Function( _UnauthorizedFailure value)?  unauthorized,TResult? Function( _ForbiddenFailure value)?  forbidden,TResult? Function( _EmailAlreadyInUseFailure value)?  emailAlreadyInUse,TResult? Function( _InvalidInputFailure value)?  invalidInput,}){
final _that = this;
switch (_that) {
case _NotFoundFailure() when notFound != null:
return notFound(_that);case _UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case _ForbiddenFailure() when forbidden != null:
return forbidden(_that);case _EmailAlreadyInUseFailure() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case _InvalidInputFailure() when invalidInput != null:
return invalidInput(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  StackTrace? stackTrace)?  notFound,TResult Function( String message,  StackTrace? stackTrace)?  unauthorized,TResult Function( String message,  StackTrace? stackTrace)?  forbidden,TResult Function( String message,  StackTrace? stackTrace)?  emailAlreadyInUse,TResult Function( String message,  StackTrace? stackTrace)?  invalidInput,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotFoundFailure() when notFound != null:
return notFound(_that.message,_that.stackTrace);case _UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message,_that.stackTrace);case _ForbiddenFailure() when forbidden != null:
return forbidden(_that.message,_that.stackTrace);case _EmailAlreadyInUseFailure() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that.message,_that.stackTrace);case _InvalidInputFailure() when invalidInput != null:
return invalidInput(_that.message,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  StackTrace? stackTrace)  notFound,required TResult Function( String message,  StackTrace? stackTrace)  unauthorized,required TResult Function( String message,  StackTrace? stackTrace)  forbidden,required TResult Function( String message,  StackTrace? stackTrace)  emailAlreadyInUse,required TResult Function( String message,  StackTrace? stackTrace)  invalidInput,}) {final _that = this;
switch (_that) {
case _NotFoundFailure():
return notFound(_that.message,_that.stackTrace);case _UnauthorizedFailure():
return unauthorized(_that.message,_that.stackTrace);case _ForbiddenFailure():
return forbidden(_that.message,_that.stackTrace);case _EmailAlreadyInUseFailure():
return emailAlreadyInUse(_that.message,_that.stackTrace);case _InvalidInputFailure():
return invalidInput(_that.message,_that.stackTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  StackTrace? stackTrace)?  notFound,TResult? Function( String message,  StackTrace? stackTrace)?  unauthorized,TResult? Function( String message,  StackTrace? stackTrace)?  forbidden,TResult? Function( String message,  StackTrace? stackTrace)?  emailAlreadyInUse,TResult? Function( String message,  StackTrace? stackTrace)?  invalidInput,}) {final _that = this;
switch (_that) {
case _NotFoundFailure() when notFound != null:
return notFound(_that.message,_that.stackTrace);case _UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message,_that.stackTrace);case _ForbiddenFailure() when forbidden != null:
return forbidden(_that.message,_that.stackTrace);case _EmailAlreadyInUseFailure() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that.message,_that.stackTrace);case _InvalidInputFailure() when invalidInput != null:
return invalidInput(_that.message,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _NotFoundFailure extends AuthFailure {
  const _NotFoundFailure({required this.message, this.stackTrace}): super._();
  

@override final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotFoundFailureCopyWith<_NotFoundFailure> get copyWith => __$NotFoundFailureCopyWithImpl<_NotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotFoundFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'AuthFailure.notFound(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$NotFoundFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$NotFoundFailureCopyWith(_NotFoundFailure value, $Res Function(_NotFoundFailure) _then) = __$NotFoundFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class __$NotFoundFailureCopyWithImpl<$Res>
    implements _$NotFoundFailureCopyWith<$Res> {
  __$NotFoundFailureCopyWithImpl(this._self, this._then);

  final _NotFoundFailure _self;
  final $Res Function(_NotFoundFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(_NotFoundFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _UnauthorizedFailure extends AuthFailure {
  const _UnauthorizedFailure({required this.message, this.stackTrace}): super._();
  

@override final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnauthorizedFailureCopyWith<_UnauthorizedFailure> get copyWith => __$UnauthorizedFailureCopyWithImpl<_UnauthorizedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnauthorizedFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'AuthFailure.unauthorized(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$UnauthorizedFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$UnauthorizedFailureCopyWith(_UnauthorizedFailure value, $Res Function(_UnauthorizedFailure) _then) = __$UnauthorizedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class __$UnauthorizedFailureCopyWithImpl<$Res>
    implements _$UnauthorizedFailureCopyWith<$Res> {
  __$UnauthorizedFailureCopyWithImpl(this._self, this._then);

  final _UnauthorizedFailure _self;
  final $Res Function(_UnauthorizedFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(_UnauthorizedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _ForbiddenFailure extends AuthFailure {
  const _ForbiddenFailure({required this.message, this.stackTrace}): super._();
  

@override final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForbiddenFailureCopyWith<_ForbiddenFailure> get copyWith => __$ForbiddenFailureCopyWithImpl<_ForbiddenFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForbiddenFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'AuthFailure.forbidden(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$ForbiddenFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$ForbiddenFailureCopyWith(_ForbiddenFailure value, $Res Function(_ForbiddenFailure) _then) = __$ForbiddenFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class __$ForbiddenFailureCopyWithImpl<$Res>
    implements _$ForbiddenFailureCopyWith<$Res> {
  __$ForbiddenFailureCopyWithImpl(this._self, this._then);

  final _ForbiddenFailure _self;
  final $Res Function(_ForbiddenFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(_ForbiddenFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _EmailAlreadyInUseFailure extends AuthFailure {
  const _EmailAlreadyInUseFailure({this.message = 'Email already in use', this.stackTrace}): super._();
  

@override@JsonKey() final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailAlreadyInUseFailureCopyWith<_EmailAlreadyInUseFailure> get copyWith => __$EmailAlreadyInUseFailureCopyWithImpl<_EmailAlreadyInUseFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailAlreadyInUseFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'AuthFailure.emailAlreadyInUse(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$EmailAlreadyInUseFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$EmailAlreadyInUseFailureCopyWith(_EmailAlreadyInUseFailure value, $Res Function(_EmailAlreadyInUseFailure) _then) = __$EmailAlreadyInUseFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class __$EmailAlreadyInUseFailureCopyWithImpl<$Res>
    implements _$EmailAlreadyInUseFailureCopyWith<$Res> {
  __$EmailAlreadyInUseFailureCopyWithImpl(this._self, this._then);

  final _EmailAlreadyInUseFailure _self;
  final $Res Function(_EmailAlreadyInUseFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(_EmailAlreadyInUseFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class _InvalidInputFailure extends AuthFailure {
  const _InvalidInputFailure({required this.message, this.stackTrace}): super._();
  

@override final  String message;
@override final  StackTrace? stackTrace;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvalidInputFailureCopyWith<_InvalidInputFailure> get copyWith => __$InvalidInputFailureCopyWithImpl<_InvalidInputFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvalidInputFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'AuthFailure.invalidInput(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$InvalidInputFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$InvalidInputFailureCopyWith(_InvalidInputFailure value, $Res Function(_InvalidInputFailure) _then) = __$InvalidInputFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, StackTrace? stackTrace
});




}
/// @nodoc
class __$InvalidInputFailureCopyWithImpl<$Res>
    implements _$InvalidInputFailureCopyWith<$Res> {
  __$InvalidInputFailureCopyWithImpl(this._self, this._then);

  final _InvalidInputFailure _self;
  final $Res Function(_InvalidInputFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(_InvalidInputFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
