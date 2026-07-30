// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent()';
}


}

/// @nodoc
class $LoginEventCopyWith<$Res>  {
$LoginEventCopyWith(LoginEvent _, $Res Function(LoginEvent) __);
}


/// Adds pattern-matching-related methods to [LoginEvent].
extension LoginEventPatterns on LoginEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginMethodChanged value)?  loginMethodChanged,TResult Function( PhoneChanged value)?  phoneChanged,TResult Function( EmailChanged value)?  emailChanged,TResult Function( PasswordChanged value)?  passwordChanged,TResult Function( PasswordVisibilityToggled value)?  passwordVisibilityToggled,TResult Function( RememberMeToggled value)?  rememberMeToggled,TResult Function( Submitted value)?  submitted,TResult Function( GoogleSignInRequested value)?  googleSignInRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginMethodChanged() when loginMethodChanged != null:
return loginMethodChanged(_that);case PhoneChanged() when phoneChanged != null:
return phoneChanged(_that);case EmailChanged() when emailChanged != null:
return emailChanged(_that);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case PasswordVisibilityToggled() when passwordVisibilityToggled != null:
return passwordVisibilityToggled(_that);case RememberMeToggled() when rememberMeToggled != null:
return rememberMeToggled(_that);case Submitted() when submitted != null:
return submitted(_that);case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginMethodChanged value)  loginMethodChanged,required TResult Function( PhoneChanged value)  phoneChanged,required TResult Function( EmailChanged value)  emailChanged,required TResult Function( PasswordChanged value)  passwordChanged,required TResult Function( PasswordVisibilityToggled value)  passwordVisibilityToggled,required TResult Function( RememberMeToggled value)  rememberMeToggled,required TResult Function( Submitted value)  submitted,required TResult Function( GoogleSignInRequested value)  googleSignInRequested,}){
final _that = this;
switch (_that) {
case LoginMethodChanged():
return loginMethodChanged(_that);case PhoneChanged():
return phoneChanged(_that);case EmailChanged():
return emailChanged(_that);case PasswordChanged():
return passwordChanged(_that);case PasswordVisibilityToggled():
return passwordVisibilityToggled(_that);case RememberMeToggled():
return rememberMeToggled(_that);case Submitted():
return submitted(_that);case GoogleSignInRequested():
return googleSignInRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginMethodChanged value)?  loginMethodChanged,TResult? Function( PhoneChanged value)?  phoneChanged,TResult? Function( EmailChanged value)?  emailChanged,TResult? Function( PasswordChanged value)?  passwordChanged,TResult? Function( PasswordVisibilityToggled value)?  passwordVisibilityToggled,TResult? Function( RememberMeToggled value)?  rememberMeToggled,TResult? Function( Submitted value)?  submitted,TResult? Function( GoogleSignInRequested value)?  googleSignInRequested,}){
final _that = this;
switch (_that) {
case LoginMethodChanged() when loginMethodChanged != null:
return loginMethodChanged(_that);case PhoneChanged() when phoneChanged != null:
return phoneChanged(_that);case EmailChanged() when emailChanged != null:
return emailChanged(_that);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case PasswordVisibilityToggled() when passwordVisibilityToggled != null:
return passwordVisibilityToggled(_that);case RememberMeToggled() when rememberMeToggled != null:
return rememberMeToggled(_that);case Submitted() when submitted != null:
return submitted(_that);case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LoginMethod method)?  loginMethodChanged,TResult Function( String value)?  phoneChanged,TResult Function( String value)?  emailChanged,TResult Function( String value)?  passwordChanged,TResult Function()?  passwordVisibilityToggled,TResult Function( bool value)?  rememberMeToggled,TResult Function()?  submitted,TResult Function()?  googleSignInRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoginMethodChanged() when loginMethodChanged != null:
return loginMethodChanged(_that.method);case PhoneChanged() when phoneChanged != null:
return phoneChanged(_that.value);case EmailChanged() when emailChanged != null:
return emailChanged(_that.value);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case PasswordVisibilityToggled() when passwordVisibilityToggled != null:
return passwordVisibilityToggled();case RememberMeToggled() when rememberMeToggled != null:
return rememberMeToggled(_that.value);case Submitted() when submitted != null:
return submitted();case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LoginMethod method)  loginMethodChanged,required TResult Function( String value)  phoneChanged,required TResult Function( String value)  emailChanged,required TResult Function( String value)  passwordChanged,required TResult Function()  passwordVisibilityToggled,required TResult Function( bool value)  rememberMeToggled,required TResult Function()  submitted,required TResult Function()  googleSignInRequested,}) {final _that = this;
switch (_that) {
case LoginMethodChanged():
return loginMethodChanged(_that.method);case PhoneChanged():
return phoneChanged(_that.value);case EmailChanged():
return emailChanged(_that.value);case PasswordChanged():
return passwordChanged(_that.value);case PasswordVisibilityToggled():
return passwordVisibilityToggled();case RememberMeToggled():
return rememberMeToggled(_that.value);case Submitted():
return submitted();case GoogleSignInRequested():
return googleSignInRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LoginMethod method)?  loginMethodChanged,TResult? Function( String value)?  phoneChanged,TResult? Function( String value)?  emailChanged,TResult? Function( String value)?  passwordChanged,TResult? Function()?  passwordVisibilityToggled,TResult? Function( bool value)?  rememberMeToggled,TResult? Function()?  submitted,TResult? Function()?  googleSignInRequested,}) {final _that = this;
switch (_that) {
case LoginMethodChanged() when loginMethodChanged != null:
return loginMethodChanged(_that.method);case PhoneChanged() when phoneChanged != null:
return phoneChanged(_that.value);case EmailChanged() when emailChanged != null:
return emailChanged(_that.value);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case PasswordVisibilityToggled() when passwordVisibilityToggled != null:
return passwordVisibilityToggled();case RememberMeToggled() when rememberMeToggled != null:
return rememberMeToggled(_that.value);case Submitted() when submitted != null:
return submitted();case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case _:
  return null;

}
}

}

/// @nodoc


class LoginMethodChanged implements LoginEvent {
  const LoginMethodChanged(this.method);
  

 final  LoginMethod method;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginMethodChangedCopyWith<LoginMethodChanged> get copyWith => _$LoginMethodChangedCopyWithImpl<LoginMethodChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginMethodChanged&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,method);

@override
String toString() {
  return 'LoginEvent.loginMethodChanged(method: $method)';
}


}

/// @nodoc
abstract mixin class $LoginMethodChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $LoginMethodChangedCopyWith(LoginMethodChanged value, $Res Function(LoginMethodChanged) _then) = _$LoginMethodChangedCopyWithImpl;
@useResult
$Res call({
 LoginMethod method
});




}
/// @nodoc
class _$LoginMethodChangedCopyWithImpl<$Res>
    implements $LoginMethodChangedCopyWith<$Res> {
  _$LoginMethodChangedCopyWithImpl(this._self, this._then);

  final LoginMethodChanged _self;
  final $Res Function(LoginMethodChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? method = null,}) {
  return _then(LoginMethodChanged(
null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as LoginMethod,
  ));
}


}

/// @nodoc


class PhoneChanged implements LoginEvent {
  const PhoneChanged(this.value);
  

 final  String value;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneChangedCopyWith<PhoneChanged> get copyWith => _$PhoneChangedCopyWithImpl<PhoneChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'LoginEvent.phoneChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $PhoneChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $PhoneChangedCopyWith(PhoneChanged value, $Res Function(PhoneChanged) _then) = _$PhoneChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$PhoneChangedCopyWithImpl<$Res>
    implements $PhoneChangedCopyWith<$Res> {
  _$PhoneChangedCopyWithImpl(this._self, this._then);

  final PhoneChanged _self;
  final $Res Function(PhoneChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(PhoneChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EmailChanged implements LoginEvent {
  const EmailChanged(this.value);
  

 final  String value;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailChangedCopyWith<EmailChanged> get copyWith => _$EmailChangedCopyWithImpl<EmailChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'LoginEvent.emailChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $EmailChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $EmailChangedCopyWith(EmailChanged value, $Res Function(EmailChanged) _then) = _$EmailChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$EmailChangedCopyWithImpl<$Res>
    implements $EmailChangedCopyWith<$Res> {
  _$EmailChangedCopyWithImpl(this._self, this._then);

  final EmailChanged _self;
  final $Res Function(EmailChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(EmailChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordChanged implements LoginEvent {
  const PasswordChanged(this.value);
  

 final  String value;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordChangedCopyWith<PasswordChanged> get copyWith => _$PasswordChangedCopyWithImpl<PasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'LoginEvent.passwordChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $PasswordChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $PasswordChangedCopyWith(PasswordChanged value, $Res Function(PasswordChanged) _then) = _$PasswordChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$PasswordChangedCopyWithImpl<$Res>
    implements $PasswordChangedCopyWith<$Res> {
  _$PasswordChangedCopyWithImpl(this._self, this._then);

  final PasswordChanged _self;
  final $Res Function(PasswordChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(PasswordChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordVisibilityToggled implements LoginEvent {
  const PasswordVisibilityToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordVisibilityToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent.passwordVisibilityToggled()';
}


}




/// @nodoc


class RememberMeToggled implements LoginEvent {
  const RememberMeToggled(this.value);
  

 final  bool value;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RememberMeToggledCopyWith<RememberMeToggled> get copyWith => _$RememberMeToggledCopyWithImpl<RememberMeToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RememberMeToggled&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'LoginEvent.rememberMeToggled(value: $value)';
}


}

/// @nodoc
abstract mixin class $RememberMeToggledCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $RememberMeToggledCopyWith(RememberMeToggled value, $Res Function(RememberMeToggled) _then) = _$RememberMeToggledCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$RememberMeToggledCopyWithImpl<$Res>
    implements $RememberMeToggledCopyWith<$Res> {
  _$RememberMeToggledCopyWithImpl(this._self, this._then);

  final RememberMeToggled _self;
  final $Res Function(RememberMeToggled) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(RememberMeToggled(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class Submitted implements LoginEvent {
  const Submitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent.submitted()';
}


}




/// @nodoc


class GoogleSignInRequested implements LoginEvent {
  const GoogleSignInRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleSignInRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent.googleSignInRequested()';
}


}




/// @nodoc
mixin _$LoginState {

 LoginStatus get status; LoginMethod get loginMethod; String get email; String get phone; String get password; bool get obscurePassword; bool get rememberMe; String? get errorMessage;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.status, status) || other.status == status)&&(identical(other.loginMethod, loginMethod) || other.loginMethod == loginMethod)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,loginMethod,email,phone,password,obscurePassword,rememberMe,errorMessage);

@override
String toString() {
  return 'LoginState(status: $status, loginMethod: $loginMethod, email: $email, phone: $phone, password: $password, obscurePassword: $obscurePassword, rememberMe: $rememberMe, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 LoginStatus status, LoginMethod loginMethod, String email, String phone, String password, bool obscurePassword, bool rememberMe, String? errorMessage
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? loginMethod = null,Object? email = null,Object? phone = null,Object? password = null,Object? obscurePassword = null,Object? rememberMe = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoginStatus,loginMethod: null == loginMethod ? _self.loginMethod : loginMethod // ignore: cast_nullable_to_non_nullable
as LoginMethod,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoginStatus status,  LoginMethod loginMethod,  String email,  String phone,  String password,  bool obscurePassword,  bool rememberMe,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.status,_that.loginMethod,_that.email,_that.phone,_that.password,_that.obscurePassword,_that.rememberMe,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoginStatus status,  LoginMethod loginMethod,  String email,  String phone,  String password,  bool obscurePassword,  bool rememberMe,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.status,_that.loginMethod,_that.email,_that.phone,_that.password,_that.obscurePassword,_that.rememberMe,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoginStatus status,  LoginMethod loginMethod,  String email,  String phone,  String password,  bool obscurePassword,  bool rememberMe,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.status,_that.loginMethod,_that.email,_that.phone,_that.password,_that.obscurePassword,_that.rememberMe,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState extends LoginState {
  const _LoginState({this.status = LoginStatus.editing, this.loginMethod = LoginMethod.phone, this.email = '', this.phone = '', this.password = '', this.obscurePassword = true, this.rememberMe = false, this.errorMessage}): super._();
  

@override@JsonKey() final  LoginStatus status;
@override@JsonKey() final  LoginMethod loginMethod;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String password;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool rememberMe;
@override final  String? errorMessage;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.status, status) || other.status == status)&&(identical(other.loginMethod, loginMethod) || other.loginMethod == loginMethod)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,loginMethod,email,phone,password,obscurePassword,rememberMe,errorMessage);

@override
String toString() {
  return 'LoginState(status: $status, loginMethod: $loginMethod, email: $email, phone: $phone, password: $password, obscurePassword: $obscurePassword, rememberMe: $rememberMe, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 LoginStatus status, LoginMethod loginMethod, String email, String phone, String password, bool obscurePassword, bool rememberMe, String? errorMessage
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? loginMethod = null,Object? email = null,Object? phone = null,Object? password = null,Object? obscurePassword = null,Object? rememberMe = null,Object? errorMessage = freezed,}) {
  return _then(_LoginState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoginStatus,loginMethod: null == loginMethod ? _self.loginMethod : loginMethod // ignore: cast_nullable_to_non_nullable
as LoginMethod,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
