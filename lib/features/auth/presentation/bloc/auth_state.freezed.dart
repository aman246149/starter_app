// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Unauthenticated value)?  unauthenticated,TResult Function( RegistrationRequired value)?  registrationRequired,TResult Function( LoginRequired value)?  loginRequired,TResult Function( Authenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case RegistrationRequired() when registrationRequired != null:
return registrationRequired(_that);case LoginRequired() when loginRequired != null:
return loginRequired(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Unauthenticated value)  unauthenticated,required TResult Function( RegistrationRequired value)  registrationRequired,required TResult Function( LoginRequired value)  loginRequired,required TResult Function( Authenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Unauthenticated():
return unauthenticated(_that);case RegistrationRequired():
return registrationRequired(_that);case LoginRequired():
return loginRequired(_that);case Authenticated():
return authenticated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Unauthenticated value)?  unauthenticated,TResult? Function( RegistrationRequired value)?  registrationRequired,TResult? Function( LoginRequired value)?  loginRequired,TResult? Function( Authenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case RegistrationRequired() when registrationRequired != null:
return registrationRequired(_that);case LoginRequired() when loginRequired != null:
return loginRequired(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( EmailAddress email,  bool isSubmitting,  FieldValidationState validation,  ErrorModel? error)?  initial,TResult Function()?  unauthenticated,TResult Function( EmailAddress email,  Password password,  Name name,  bool isSubmitting,  FieldValidationState validation,  bool passwordVisible,  ErrorModel? error)?  registrationRequired,TResult Function( EmailAddress email,  Password password,  bool isSubmitting,  FieldValidationState validation,  bool passwordVisible,  ErrorModel? error)?  loginRequired,TResult Function( User user)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that.email,_that.isSubmitting,_that.validation,_that.error);case Unauthenticated() when unauthenticated != null:
return unauthenticated();case RegistrationRequired() when registrationRequired != null:
return registrationRequired(_that.email,_that.password,_that.name,_that.isSubmitting,_that.validation,_that.passwordVisible,_that.error);case LoginRequired() when loginRequired != null:
return loginRequired(_that.email,_that.password,_that.isSubmitting,_that.validation,_that.passwordVisible,_that.error);case Authenticated() when authenticated != null:
return authenticated(_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( EmailAddress email,  bool isSubmitting,  FieldValidationState validation,  ErrorModel? error)  initial,required TResult Function()  unauthenticated,required TResult Function( EmailAddress email,  Password password,  Name name,  bool isSubmitting,  FieldValidationState validation,  bool passwordVisible,  ErrorModel? error)  registrationRequired,required TResult Function( EmailAddress email,  Password password,  bool isSubmitting,  FieldValidationState validation,  bool passwordVisible,  ErrorModel? error)  loginRequired,required TResult Function( User user)  authenticated,}) {final _that = this;
switch (_that) {
case Initial():
return initial(_that.email,_that.isSubmitting,_that.validation,_that.error);case Unauthenticated():
return unauthenticated();case RegistrationRequired():
return registrationRequired(_that.email,_that.password,_that.name,_that.isSubmitting,_that.validation,_that.passwordVisible,_that.error);case LoginRequired():
return loginRequired(_that.email,_that.password,_that.isSubmitting,_that.validation,_that.passwordVisible,_that.error);case Authenticated():
return authenticated(_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( EmailAddress email,  bool isSubmitting,  FieldValidationState validation,  ErrorModel? error)?  initial,TResult? Function()?  unauthenticated,TResult? Function( EmailAddress email,  Password password,  Name name,  bool isSubmitting,  FieldValidationState validation,  bool passwordVisible,  ErrorModel? error)?  registrationRequired,TResult? Function( EmailAddress email,  Password password,  bool isSubmitting,  FieldValidationState validation,  bool passwordVisible,  ErrorModel? error)?  loginRequired,TResult? Function( User user)?  authenticated,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that.email,_that.isSubmitting,_that.validation,_that.error);case Unauthenticated() when unauthenticated != null:
return unauthenticated();case RegistrationRequired() when registrationRequired != null:
return registrationRequired(_that.email,_that.password,_that.name,_that.isSubmitting,_that.validation,_that.passwordVisible,_that.error);case LoginRequired() when loginRequired != null:
return loginRequired(_that.email,_that.password,_that.isSubmitting,_that.validation,_that.passwordVisible,_that.error);case Authenticated() when authenticated != null:
return authenticated(_that.user);case _:
  return null;

}
}

}

/// @nodoc


class Initial implements AuthState {
  const Initial({required this.email, required this.isSubmitting, required this.validation, this.error});
  

 final  EmailAddress email;
 final  bool isSubmitting;
 final  FieldValidationState validation;
 final  ErrorModel? error;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialCopyWith<Initial> get copyWith => _$InitialCopyWithImpl<Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial&&(identical(other.email, email) || other.email == email)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.validation, validation) || other.validation == validation)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,email,isSubmitting,validation,error);

@override
String toString() {
  return 'AuthState.initial(email: $email, isSubmitting: $isSubmitting, validation: $validation, error: $error)';
}


}

/// @nodoc
abstract mixin class $InitialCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) _then) = _$InitialCopyWithImpl;
@useResult
$Res call({
 EmailAddress email, bool isSubmitting, FieldValidationState validation, ErrorModel? error
});


$FieldValidationStateCopyWith<$Res> get validation;$ErrorModelCopyWith<$Res>? get error;

}
/// @nodoc
class _$InitialCopyWithImpl<$Res>
    implements $InitialCopyWith<$Res> {
  _$InitialCopyWithImpl(this._self, this._then);

  final Initial _self;
  final $Res Function(Initial) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? isSubmitting = null,Object? validation = null,Object? error = freezed,}) {
  return _then(Initial(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailAddress,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,validation: null == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as FieldValidationState,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorModel?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldValidationStateCopyWith<$Res> get validation {
  
  return $FieldValidationStateCopyWith<$Res>(_self.validation, (value) {
    return _then(_self.copyWith(validation: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorModelCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorModelCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

/// @nodoc


class Unauthenticated implements AuthState {
  const Unauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class RegistrationRequired implements AuthState {
  const RegistrationRequired({required this.email, required this.password, required this.name, required this.isSubmitting, required this.validation, this.passwordVisible = false, this.error});
  

 final  EmailAddress email;
 final  Password password;
 final  Name name;
 final  bool isSubmitting;
 final  FieldValidationState validation;
@JsonKey() final  bool passwordVisible;
 final  ErrorModel? error;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationRequiredCopyWith<RegistrationRequired> get copyWith => _$RegistrationRequiredCopyWithImpl<RegistrationRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationRequired&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.validation, validation) || other.validation == validation)&&(identical(other.passwordVisible, passwordVisible) || other.passwordVisible == passwordVisible)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,name,isSubmitting,validation,passwordVisible,error);

@override
String toString() {
  return 'AuthState.registrationRequired(email: $email, password: $password, name: $name, isSubmitting: $isSubmitting, validation: $validation, passwordVisible: $passwordVisible, error: $error)';
}


}

/// @nodoc
abstract mixin class $RegistrationRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $RegistrationRequiredCopyWith(RegistrationRequired value, $Res Function(RegistrationRequired) _then) = _$RegistrationRequiredCopyWithImpl;
@useResult
$Res call({
 EmailAddress email, Password password, Name name, bool isSubmitting, FieldValidationState validation, bool passwordVisible, ErrorModel? error
});


$FieldValidationStateCopyWith<$Res> get validation;$ErrorModelCopyWith<$Res>? get error;

}
/// @nodoc
class _$RegistrationRequiredCopyWithImpl<$Res>
    implements $RegistrationRequiredCopyWith<$Res> {
  _$RegistrationRequiredCopyWithImpl(this._self, this._then);

  final RegistrationRequired _self;
  final $Res Function(RegistrationRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? name = null,Object? isSubmitting = null,Object? validation = null,Object? passwordVisible = null,Object? error = freezed,}) {
  return _then(RegistrationRequired(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailAddress,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Password,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Name,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,validation: null == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as FieldValidationState,passwordVisible: null == passwordVisible ? _self.passwordVisible : passwordVisible // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorModel?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldValidationStateCopyWith<$Res> get validation {
  
  return $FieldValidationStateCopyWith<$Res>(_self.validation, (value) {
    return _then(_self.copyWith(validation: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorModelCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorModelCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

/// @nodoc


class LoginRequired implements AuthState {
  const LoginRequired({required this.email, required this.password, required this.isSubmitting, required this.validation, this.passwordVisible = false, this.error});
  

 final  EmailAddress email;
 final  Password password;
 final  bool isSubmitting;
 final  FieldValidationState validation;
@JsonKey() final  bool passwordVisible;
 final  ErrorModel? error;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequiredCopyWith<LoginRequired> get copyWith => _$LoginRequiredCopyWithImpl<LoginRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequired&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.validation, validation) || other.validation == validation)&&(identical(other.passwordVisible, passwordVisible) || other.passwordVisible == passwordVisible)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,isSubmitting,validation,passwordVisible,error);

@override
String toString() {
  return 'AuthState.loginRequired(email: $email, password: $password, isSubmitting: $isSubmitting, validation: $validation, passwordVisible: $passwordVisible, error: $error)';
}


}

/// @nodoc
abstract mixin class $LoginRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $LoginRequiredCopyWith(LoginRequired value, $Res Function(LoginRequired) _then) = _$LoginRequiredCopyWithImpl;
@useResult
$Res call({
 EmailAddress email, Password password, bool isSubmitting, FieldValidationState validation, bool passwordVisible, ErrorModel? error
});


$FieldValidationStateCopyWith<$Res> get validation;$ErrorModelCopyWith<$Res>? get error;

}
/// @nodoc
class _$LoginRequiredCopyWithImpl<$Res>
    implements $LoginRequiredCopyWith<$Res> {
  _$LoginRequiredCopyWithImpl(this._self, this._then);

  final LoginRequired _self;
  final $Res Function(LoginRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? isSubmitting = null,Object? validation = null,Object? passwordVisible = null,Object? error = freezed,}) {
  return _then(LoginRequired(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailAddress,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Password,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,validation: null == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as FieldValidationState,passwordVisible: null == passwordVisible ? _self.passwordVisible : passwordVisible // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorModel?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldValidationStateCopyWith<$Res> get validation {
  
  return $FieldValidationStateCopyWith<$Res>(_self.validation, (value) {
    return _then(_self.copyWith(validation: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorModelCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorModelCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

/// @nodoc


class Authenticated implements AuthState {
  const Authenticated(this.user);
  

 final  User user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedCopyWith<Authenticated> get copyWith => _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedCopyWith(Authenticated value, $Res Function(Authenticated) _then) = _$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 User user
});




}
/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(this._self, this._then);

  final Authenticated _self;
  final $Res Function(Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(Authenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}


}

// dart format on
