// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_ws_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthWsEventModel {

/// Event type (
/// e.g., 'user_authenticated', 'user_updated', 'user_logged_out')
 String get event;/// Event data (user object or null)
 UserModel? get data;/// Optional timestamp of the event
 DateTime? get timestamp;
/// Create a copy of AuthWsEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthWsEventModelCopyWith<AuthWsEventModel> get copyWith => _$AuthWsEventModelCopyWithImpl<AuthWsEventModel>(this as AuthWsEventModel, _$identity);

  /// Serializes this AuthWsEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthWsEventModel&&(identical(other.event, event) || other.event == event)&&(identical(other.data, data) || other.data == data)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,data,timestamp);

@override
String toString() {
  return 'AuthWsEventModel(event: $event, data: $data, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AuthWsEventModelCopyWith<$Res>  {
  factory $AuthWsEventModelCopyWith(AuthWsEventModel value, $Res Function(AuthWsEventModel) _then) = _$AuthWsEventModelCopyWithImpl;
@useResult
$Res call({
 String event, UserModel? data, DateTime? timestamp
});


$UserModelCopyWith<$Res>? get data;

}
/// @nodoc
class _$AuthWsEventModelCopyWithImpl<$Res>
    implements $AuthWsEventModelCopyWith<$Res> {
  _$AuthWsEventModelCopyWithImpl(this._self, this._then);

  final AuthWsEventModel _self;
  final $Res Function(AuthWsEventModel) _then;

/// Create a copy of AuthWsEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? data = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserModel?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AuthWsEventModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthWsEventModel].
extension AuthWsEventModelPatterns on AuthWsEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthWsEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthWsEventModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthWsEventModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthWsEventModel():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthWsEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthWsEventModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String event,  UserModel? data,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthWsEventModel() when $default != null:
return $default(_that.event,_that.data,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String event,  UserModel? data,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _AuthWsEventModel():
return $default(_that.event,_that.data,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String event,  UserModel? data,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AuthWsEventModel() when $default != null:
return $default(_that.event,_that.data,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthWsEventModel implements AuthWsEventModel {
  const _AuthWsEventModel({required this.event, this.data, this.timestamp});
  factory _AuthWsEventModel.fromJson(Map<String, dynamic> json) => _$AuthWsEventModelFromJson(json);

/// Event type (
/// e.g., 'user_authenticated', 'user_updated', 'user_logged_out')
@override final  String event;
/// Event data (user object or null)
@override final  UserModel? data;
/// Optional timestamp of the event
@override final  DateTime? timestamp;

/// Create a copy of AuthWsEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthWsEventModelCopyWith<_AuthWsEventModel> get copyWith => __$AuthWsEventModelCopyWithImpl<_AuthWsEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthWsEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthWsEventModel&&(identical(other.event, event) || other.event == event)&&(identical(other.data, data) || other.data == data)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,data,timestamp);

@override
String toString() {
  return 'AuthWsEventModel(event: $event, data: $data, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AuthWsEventModelCopyWith<$Res> implements $AuthWsEventModelCopyWith<$Res> {
  factory _$AuthWsEventModelCopyWith(_AuthWsEventModel value, $Res Function(_AuthWsEventModel) _then) = __$AuthWsEventModelCopyWithImpl;
@override @useResult
$Res call({
 String event, UserModel? data, DateTime? timestamp
});


@override $UserModelCopyWith<$Res>? get data;

}
/// @nodoc
class __$AuthWsEventModelCopyWithImpl<$Res>
    implements _$AuthWsEventModelCopyWith<$Res> {
  __$AuthWsEventModelCopyWithImpl(this._self, this._then);

  final _AuthWsEventModel _self;
  final $Res Function(_AuthWsEventModel) _then;

/// Create a copy of AuthWsEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? data = freezed,Object? timestamp = freezed,}) {
  return _then(_AuthWsEventModel(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserModel?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AuthWsEventModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
