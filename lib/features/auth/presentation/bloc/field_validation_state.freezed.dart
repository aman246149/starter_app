// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_validation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FieldValidationState {

 bool get emailTouched; bool get passwordTouched; bool get nameTouched;
/// Create a copy of FieldValidationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldValidationStateCopyWith<FieldValidationState> get copyWith => _$FieldValidationStateCopyWithImpl<FieldValidationState>(this as FieldValidationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldValidationState&&(identical(other.emailTouched, emailTouched) || other.emailTouched == emailTouched)&&(identical(other.passwordTouched, passwordTouched) || other.passwordTouched == passwordTouched)&&(identical(other.nameTouched, nameTouched) || other.nameTouched == nameTouched));
}


@override
int get hashCode => Object.hash(runtimeType,emailTouched,passwordTouched,nameTouched);

@override
String toString() {
  return 'FieldValidationState(emailTouched: $emailTouched, passwordTouched: $passwordTouched, nameTouched: $nameTouched)';
}


}

/// @nodoc
abstract mixin class $FieldValidationStateCopyWith<$Res>  {
  factory $FieldValidationStateCopyWith(FieldValidationState value, $Res Function(FieldValidationState) _then) = _$FieldValidationStateCopyWithImpl;
@useResult
$Res call({
 bool emailTouched, bool passwordTouched, bool nameTouched
});




}
/// @nodoc
class _$FieldValidationStateCopyWithImpl<$Res>
    implements $FieldValidationStateCopyWith<$Res> {
  _$FieldValidationStateCopyWithImpl(this._self, this._then);

  final FieldValidationState _self;
  final $Res Function(FieldValidationState) _then;

/// Create a copy of FieldValidationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emailTouched = null,Object? passwordTouched = null,Object? nameTouched = null,}) {
  return _then(_self.copyWith(
emailTouched: null == emailTouched ? _self.emailTouched : emailTouched // ignore: cast_nullable_to_non_nullable
as bool,passwordTouched: null == passwordTouched ? _self.passwordTouched : passwordTouched // ignore: cast_nullable_to_non_nullable
as bool,nameTouched: null == nameTouched ? _self.nameTouched : nameTouched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldValidationState].
extension FieldValidationStatePatterns on FieldValidationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldValidationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldValidationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldValidationState value)  $default,){
final _that = this;
switch (_that) {
case _FieldValidationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldValidationState value)?  $default,){
final _that = this;
switch (_that) {
case _FieldValidationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool emailTouched,  bool passwordTouched,  bool nameTouched)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldValidationState() when $default != null:
return $default(_that.emailTouched,_that.passwordTouched,_that.nameTouched);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool emailTouched,  bool passwordTouched,  bool nameTouched)  $default,) {final _that = this;
switch (_that) {
case _FieldValidationState():
return $default(_that.emailTouched,_that.passwordTouched,_that.nameTouched);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool emailTouched,  bool passwordTouched,  bool nameTouched)?  $default,) {final _that = this;
switch (_that) {
case _FieldValidationState() when $default != null:
return $default(_that.emailTouched,_that.passwordTouched,_that.nameTouched);case _:
  return null;

}
}

}

/// @nodoc


class _FieldValidationState implements FieldValidationState {
  const _FieldValidationState({this.emailTouched = false, this.passwordTouched = false, this.nameTouched = false});
  

@override@JsonKey() final  bool emailTouched;
@override@JsonKey() final  bool passwordTouched;
@override@JsonKey() final  bool nameTouched;

/// Create a copy of FieldValidationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldValidationStateCopyWith<_FieldValidationState> get copyWith => __$FieldValidationStateCopyWithImpl<_FieldValidationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldValidationState&&(identical(other.emailTouched, emailTouched) || other.emailTouched == emailTouched)&&(identical(other.passwordTouched, passwordTouched) || other.passwordTouched == passwordTouched)&&(identical(other.nameTouched, nameTouched) || other.nameTouched == nameTouched));
}


@override
int get hashCode => Object.hash(runtimeType,emailTouched,passwordTouched,nameTouched);

@override
String toString() {
  return 'FieldValidationState(emailTouched: $emailTouched, passwordTouched: $passwordTouched, nameTouched: $nameTouched)';
}


}

/// @nodoc
abstract mixin class _$FieldValidationStateCopyWith<$Res> implements $FieldValidationStateCopyWith<$Res> {
  factory _$FieldValidationStateCopyWith(_FieldValidationState value, $Res Function(_FieldValidationState) _then) = __$FieldValidationStateCopyWithImpl;
@override @useResult
$Res call({
 bool emailTouched, bool passwordTouched, bool nameTouched
});




}
/// @nodoc
class __$FieldValidationStateCopyWithImpl<$Res>
    implements _$FieldValidationStateCopyWith<$Res> {
  __$FieldValidationStateCopyWithImpl(this._self, this._then);

  final _FieldValidationState _self;
  final $Res Function(_FieldValidationState) _then;

/// Create a copy of FieldValidationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emailTouched = null,Object? passwordTouched = null,Object? nameTouched = null,}) {
  return _then(_FieldValidationState(
emailTouched: null == emailTouched ? _self.emailTouched : emailTouched // ignore: cast_nullable_to_non_nullable
as bool,passwordTouched: null == passwordTouched ? _self.passwordTouched : passwordTouched // ignore: cast_nullable_to_non_nullable
as bool,nameTouched: null == nameTouched ? _self.nameTouched : nameTouched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
