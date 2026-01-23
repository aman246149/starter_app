// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_user_exists_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckUserExistsResponseModel {

 bool get exists;
/// Create a copy of CheckUserExistsResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckUserExistsResponseModelCopyWith<CheckUserExistsResponseModel> get copyWith => _$CheckUserExistsResponseModelCopyWithImpl<CheckUserExistsResponseModel>(this as CheckUserExistsResponseModel, _$identity);

  /// Serializes this CheckUserExistsResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckUserExistsResponseModel&&(identical(other.exists, exists) || other.exists == exists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exists);

@override
String toString() {
  return 'CheckUserExistsResponseModel(exists: $exists)';
}


}

/// @nodoc
abstract mixin class $CheckUserExistsResponseModelCopyWith<$Res>  {
  factory $CheckUserExistsResponseModelCopyWith(CheckUserExistsResponseModel value, $Res Function(CheckUserExistsResponseModel) _then) = _$CheckUserExistsResponseModelCopyWithImpl;
@useResult
$Res call({
 bool exists
});




}
/// @nodoc
class _$CheckUserExistsResponseModelCopyWithImpl<$Res>
    implements $CheckUserExistsResponseModelCopyWith<$Res> {
  _$CheckUserExistsResponseModelCopyWithImpl(this._self, this._then);

  final CheckUserExistsResponseModel _self;
  final $Res Function(CheckUserExistsResponseModel) _then;

/// Create a copy of CheckUserExistsResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exists = null,}) {
  return _then(_self.copyWith(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckUserExistsResponseModel].
extension CheckUserExistsResponseModelPatterns on CheckUserExistsResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckUserExistsResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckUserExistsResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckUserExistsResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _CheckUserExistsResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckUserExistsResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CheckUserExistsResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool exists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckUserExistsResponseModel() when $default != null:
return $default(_that.exists);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool exists)  $default,) {final _that = this;
switch (_that) {
case _CheckUserExistsResponseModel():
return $default(_that.exists);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool exists)?  $default,) {final _that = this;
switch (_that) {
case _CheckUserExistsResponseModel() when $default != null:
return $default(_that.exists);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckUserExistsResponseModel implements CheckUserExistsResponseModel {
  const _CheckUserExistsResponseModel({required this.exists});
  factory _CheckUserExistsResponseModel.fromJson(Map<String, dynamic> json) => _$CheckUserExistsResponseModelFromJson(json);

@override final  bool exists;

/// Create a copy of CheckUserExistsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckUserExistsResponseModelCopyWith<_CheckUserExistsResponseModel> get copyWith => __$CheckUserExistsResponseModelCopyWithImpl<_CheckUserExistsResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckUserExistsResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckUserExistsResponseModel&&(identical(other.exists, exists) || other.exists == exists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exists);

@override
String toString() {
  return 'CheckUserExistsResponseModel(exists: $exists)';
}


}

/// @nodoc
abstract mixin class _$CheckUserExistsResponseModelCopyWith<$Res> implements $CheckUserExistsResponseModelCopyWith<$Res> {
  factory _$CheckUserExistsResponseModelCopyWith(_CheckUserExistsResponseModel value, $Res Function(_CheckUserExistsResponseModel) _then) = __$CheckUserExistsResponseModelCopyWithImpl;
@override @useResult
$Res call({
 bool exists
});




}
/// @nodoc
class __$CheckUserExistsResponseModelCopyWithImpl<$Res>
    implements _$CheckUserExistsResponseModelCopyWith<$Res> {
  __$CheckUserExistsResponseModelCopyWithImpl(this._self, this._then);

  final _CheckUserExistsResponseModel _self;
  final $Res Function(_CheckUserExistsResponseModel) _then;

/// Create a copy of CheckUserExistsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exists = null,}) {
  return _then(_CheckUserExistsResponseModel(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
