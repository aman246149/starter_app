// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'value_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ValueFailure<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValueFailure<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ValueFailure<$T>()';
}


}

/// @nodoc
class $ValueFailureCopyWith<T,$Res>  {
$ValueFailureCopyWith(ValueFailure<T> _, $Res Function(ValueFailure<T>) __);
}


/// Adds pattern-matching-related methods to [ValueFailure].
extension ValueFailurePatterns<T> on ValueFailure<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Empty<T> value)?  empty,TResult Function( TooShort<T> value)?  tooShort,TResult Function( TooLong<T> value)?  tooLong,TResult Function( InvalidFormat<T> value)?  invalidFormat,TResult Function( OutOfRange<T> value)?  outOfRange,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Empty() when empty != null:
return empty(_that);case TooShort() when tooShort != null:
return tooShort(_that);case TooLong() when tooLong != null:
return tooLong(_that);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that);case OutOfRange() when outOfRange != null:
return outOfRange(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Empty<T> value)  empty,required TResult Function( TooShort<T> value)  tooShort,required TResult Function( TooLong<T> value)  tooLong,required TResult Function( InvalidFormat<T> value)  invalidFormat,required TResult Function( OutOfRange<T> value)  outOfRange,}){
final _that = this;
switch (_that) {
case Empty():
return empty(_that);case TooShort():
return tooShort(_that);case TooLong():
return tooLong(_that);case InvalidFormat():
return invalidFormat(_that);case OutOfRange():
return outOfRange(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Empty<T> value)?  empty,TResult? Function( TooShort<T> value)?  tooShort,TResult? Function( TooLong<T> value)?  tooLong,TResult? Function( InvalidFormat<T> value)?  invalidFormat,TResult? Function( OutOfRange<T> value)?  outOfRange,}){
final _that = this;
switch (_that) {
case Empty() when empty != null:
return empty(_that);case TooShort() when tooShort != null:
return tooShort(_that);case TooLong() when tooLong != null:
return tooLong(_that);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that);case OutOfRange() when outOfRange != null:
return outOfRange(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? fieldName)?  empty,TResult Function( int minLength,  int actualLength)?  tooShort,TResult Function( int maxLength,  int actualLength)?  tooLong,TResult Function( String expectedFormat,  String failedValue)?  invalidFormat,TResult Function( num min,  num max,  num actual)?  outOfRange,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Empty() when empty != null:
return empty(_that.fieldName);case TooShort() when tooShort != null:
return tooShort(_that.minLength,_that.actualLength);case TooLong() when tooLong != null:
return tooLong(_that.maxLength,_that.actualLength);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that.expectedFormat,_that.failedValue);case OutOfRange() when outOfRange != null:
return outOfRange(_that.min,_that.max,_that.actual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? fieldName)  empty,required TResult Function( int minLength,  int actualLength)  tooShort,required TResult Function( int maxLength,  int actualLength)  tooLong,required TResult Function( String expectedFormat,  String failedValue)  invalidFormat,required TResult Function( num min,  num max,  num actual)  outOfRange,}) {final _that = this;
switch (_that) {
case Empty():
return empty(_that.fieldName);case TooShort():
return tooShort(_that.minLength,_that.actualLength);case TooLong():
return tooLong(_that.maxLength,_that.actualLength);case InvalidFormat():
return invalidFormat(_that.expectedFormat,_that.failedValue);case OutOfRange():
return outOfRange(_that.min,_that.max,_that.actual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? fieldName)?  empty,TResult? Function( int minLength,  int actualLength)?  tooShort,TResult? Function( int maxLength,  int actualLength)?  tooLong,TResult? Function( String expectedFormat,  String failedValue)?  invalidFormat,TResult? Function( num min,  num max,  num actual)?  outOfRange,}) {final _that = this;
switch (_that) {
case Empty() when empty != null:
return empty(_that.fieldName);case TooShort() when tooShort != null:
return tooShort(_that.minLength,_that.actualLength);case TooLong() when tooLong != null:
return tooLong(_that.maxLength,_that.actualLength);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that.expectedFormat,_that.failedValue);case OutOfRange() when outOfRange != null:
return outOfRange(_that.min,_that.max,_that.actual);case _:
  return null;

}
}

}

/// @nodoc


class Empty<T> implements ValueFailure<T> {
  const Empty({this.fieldName});
  

 final  String? fieldName;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmptyCopyWith<T, Empty<T>> get copyWith => _$EmptyCopyWithImpl<T, Empty<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Empty<T>&&(identical(other.fieldName, fieldName) || other.fieldName == fieldName));
}


@override
int get hashCode => Object.hash(runtimeType,fieldName);

@override
String toString() {
  return 'ValueFailure<$T>.empty(fieldName: $fieldName)';
}


}

/// @nodoc
abstract mixin class $EmptyCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $EmptyCopyWith(Empty<T> value, $Res Function(Empty<T>) _then) = _$EmptyCopyWithImpl;
@useResult
$Res call({
 String? fieldName
});




}
/// @nodoc
class _$EmptyCopyWithImpl<T,$Res>
    implements $EmptyCopyWith<T, $Res> {
  _$EmptyCopyWithImpl(this._self, this._then);

  final Empty<T> _self;
  final $Res Function(Empty<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fieldName = freezed,}) {
  return _then(Empty<T>(
fieldName: freezed == fieldName ? _self.fieldName : fieldName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TooShort<T> implements ValueFailure<T> {
  const TooShort({required this.minLength, required this.actualLength});
  

 final  int minLength;
 final  int actualLength;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooShortCopyWith<T, TooShort<T>> get copyWith => _$TooShortCopyWithImpl<T, TooShort<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooShort<T>&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.actualLength, actualLength) || other.actualLength == actualLength));
}


@override
int get hashCode => Object.hash(runtimeType,minLength,actualLength);

@override
String toString() {
  return 'ValueFailure<$T>.tooShort(minLength: $minLength, actualLength: $actualLength)';
}


}

/// @nodoc
abstract mixin class $TooShortCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $TooShortCopyWith(TooShort<T> value, $Res Function(TooShort<T>) _then) = _$TooShortCopyWithImpl;
@useResult
$Res call({
 int minLength, int actualLength
});




}
/// @nodoc
class _$TooShortCopyWithImpl<T,$Res>
    implements $TooShortCopyWith<T, $Res> {
  _$TooShortCopyWithImpl(this._self, this._then);

  final TooShort<T> _self;
  final $Res Function(TooShort<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? minLength = null,Object? actualLength = null,}) {
  return _then(TooShort<T>(
minLength: null == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int,actualLength: null == actualLength ? _self.actualLength : actualLength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TooLong<T> implements ValueFailure<T> {
  const TooLong({required this.maxLength, required this.actualLength});
  

 final  int maxLength;
 final  int actualLength;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooLongCopyWith<T, TooLong<T>> get copyWith => _$TooLongCopyWithImpl<T, TooLong<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooLong<T>&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.actualLength, actualLength) || other.actualLength == actualLength));
}


@override
int get hashCode => Object.hash(runtimeType,maxLength,actualLength);

@override
String toString() {
  return 'ValueFailure<$T>.tooLong(maxLength: $maxLength, actualLength: $actualLength)';
}


}

/// @nodoc
abstract mixin class $TooLongCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $TooLongCopyWith(TooLong<T> value, $Res Function(TooLong<T>) _then) = _$TooLongCopyWithImpl;
@useResult
$Res call({
 int maxLength, int actualLength
});




}
/// @nodoc
class _$TooLongCopyWithImpl<T,$Res>
    implements $TooLongCopyWith<T, $Res> {
  _$TooLongCopyWithImpl(this._self, this._then);

  final TooLong<T> _self;
  final $Res Function(TooLong<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? maxLength = null,Object? actualLength = null,}) {
  return _then(TooLong<T>(
maxLength: null == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int,actualLength: null == actualLength ? _self.actualLength : actualLength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class InvalidFormat<T> implements ValueFailure<T> {
  const InvalidFormat({required this.expectedFormat, required this.failedValue});
  

 final  String expectedFormat;
 final  String failedValue;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvalidFormatCopyWith<T, InvalidFormat<T>> get copyWith => _$InvalidFormatCopyWithImpl<T, InvalidFormat<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidFormat<T>&&(identical(other.expectedFormat, expectedFormat) || other.expectedFormat == expectedFormat)&&(identical(other.failedValue, failedValue) || other.failedValue == failedValue));
}


@override
int get hashCode => Object.hash(runtimeType,expectedFormat,failedValue);

@override
String toString() {
  return 'ValueFailure<$T>.invalidFormat(expectedFormat: $expectedFormat, failedValue: $failedValue)';
}


}

/// @nodoc
abstract mixin class $InvalidFormatCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $InvalidFormatCopyWith(InvalidFormat<T> value, $Res Function(InvalidFormat<T>) _then) = _$InvalidFormatCopyWithImpl;
@useResult
$Res call({
 String expectedFormat, String failedValue
});




}
/// @nodoc
class _$InvalidFormatCopyWithImpl<T,$Res>
    implements $InvalidFormatCopyWith<T, $Res> {
  _$InvalidFormatCopyWithImpl(this._self, this._then);

  final InvalidFormat<T> _self;
  final $Res Function(InvalidFormat<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? expectedFormat = null,Object? failedValue = null,}) {
  return _then(InvalidFormat<T>(
expectedFormat: null == expectedFormat ? _self.expectedFormat : expectedFormat // ignore: cast_nullable_to_non_nullable
as String,failedValue: null == failedValue ? _self.failedValue : failedValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class OutOfRange<T> implements ValueFailure<T> {
  const OutOfRange({required this.min, required this.max, required this.actual});
  

 final  num min;
 final  num max;
 final  num actual;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutOfRangeCopyWith<T, OutOfRange<T>> get copyWith => _$OutOfRangeCopyWithImpl<T, OutOfRange<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutOfRange<T>&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.actual, actual) || other.actual == actual));
}


@override
int get hashCode => Object.hash(runtimeType,min,max,actual);

@override
String toString() {
  return 'ValueFailure<$T>.outOfRange(min: $min, max: $max, actual: $actual)';
}


}

/// @nodoc
abstract mixin class $OutOfRangeCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $OutOfRangeCopyWith(OutOfRange<T> value, $Res Function(OutOfRange<T>) _then) = _$OutOfRangeCopyWithImpl;
@useResult
$Res call({
 num min, num max, num actual
});




}
/// @nodoc
class _$OutOfRangeCopyWithImpl<T,$Res>
    implements $OutOfRangeCopyWith<T, $Res> {
  _$OutOfRangeCopyWithImpl(this._self, this._then);

  final OutOfRange<T> _self;
  final $Res Function(OutOfRange<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? min = null,Object? max = null,Object? actual = null,}) {
  return _then(OutOfRange<T>(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as num,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as num,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
