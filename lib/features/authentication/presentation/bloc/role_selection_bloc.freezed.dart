// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_selection_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoleSelectionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleSelectionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoleSelectionEvent()';
}


}

/// @nodoc
class $RoleSelectionEventCopyWith<$Res>  {
$RoleSelectionEventCopyWith(RoleSelectionEvent _, $Res Function(RoleSelectionEvent) __);
}


/// Adds pattern-matching-related methods to [RoleSelectionEvent].
extension RoleSelectionEventPatterns on RoleSelectionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RoleSelectionStarted value)?  started,TResult Function( RoleHighlighted value)?  roleHighlighted,TResult Function( RoleSelectionConfirmed value)?  confirmed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RoleSelectionStarted() when started != null:
return started(_that);case RoleHighlighted() when roleHighlighted != null:
return roleHighlighted(_that);case RoleSelectionConfirmed() when confirmed != null:
return confirmed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RoleSelectionStarted value)  started,required TResult Function( RoleHighlighted value)  roleHighlighted,required TResult Function( RoleSelectionConfirmed value)  confirmed,}){
final _that = this;
switch (_that) {
case RoleSelectionStarted():
return started(_that);case RoleHighlighted():
return roleHighlighted(_that);case RoleSelectionConfirmed():
return confirmed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RoleSelectionStarted value)?  started,TResult? Function( RoleHighlighted value)?  roleHighlighted,TResult? Function( RoleSelectionConfirmed value)?  confirmed,}){
final _that = this;
switch (_that) {
case RoleSelectionStarted() when started != null:
return started(_that);case RoleHighlighted() when roleHighlighted != null:
return roleHighlighted(_that);case RoleSelectionConfirmed() when confirmed != null:
return confirmed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( UserRole role)?  roleHighlighted,TResult Function()?  confirmed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RoleSelectionStarted() when started != null:
return started();case RoleHighlighted() when roleHighlighted != null:
return roleHighlighted(_that.role);case RoleSelectionConfirmed() when confirmed != null:
return confirmed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( UserRole role)  roleHighlighted,required TResult Function()  confirmed,}) {final _that = this;
switch (_that) {
case RoleSelectionStarted():
return started();case RoleHighlighted():
return roleHighlighted(_that.role);case RoleSelectionConfirmed():
return confirmed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( UserRole role)?  roleHighlighted,TResult? Function()?  confirmed,}) {final _that = this;
switch (_that) {
case RoleSelectionStarted() when started != null:
return started();case RoleHighlighted() when roleHighlighted != null:
return roleHighlighted(_that.role);case RoleSelectionConfirmed() when confirmed != null:
return confirmed();case _:
  return null;

}
}

}

/// @nodoc


class RoleSelectionStarted implements RoleSelectionEvent {
  const RoleSelectionStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleSelectionStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoleSelectionEvent.started()';
}


}




/// @nodoc


class RoleHighlighted implements RoleSelectionEvent {
  const RoleHighlighted(this.role);
  

 final  UserRole role;

/// Create a copy of RoleSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleHighlightedCopyWith<RoleHighlighted> get copyWith => _$RoleHighlightedCopyWithImpl<RoleHighlighted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleHighlighted&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'RoleSelectionEvent.roleHighlighted(role: $role)';
}


}

/// @nodoc
abstract mixin class $RoleHighlightedCopyWith<$Res> implements $RoleSelectionEventCopyWith<$Res> {
  factory $RoleHighlightedCopyWith(RoleHighlighted value, $Res Function(RoleHighlighted) _then) = _$RoleHighlightedCopyWithImpl;
@useResult
$Res call({
 UserRole role
});




}
/// @nodoc
class _$RoleHighlightedCopyWithImpl<$Res>
    implements $RoleHighlightedCopyWith<$Res> {
  _$RoleHighlightedCopyWithImpl(this._self, this._then);

  final RoleHighlighted _self;
  final $Res Function(RoleHighlighted) _then;

/// Create a copy of RoleSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(RoleHighlighted(
null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

/// @nodoc


class RoleSelectionConfirmed implements RoleSelectionEvent {
  const RoleSelectionConfirmed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleSelectionConfirmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoleSelectionEvent.confirmed()';
}


}




/// @nodoc
mixin _$RoleSelectionState {

 RoleSelectionStatus get status; UserRole? get highlightedRole; String? get errorMessage;
/// Create a copy of RoleSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleSelectionStateCopyWith<RoleSelectionState> get copyWith => _$RoleSelectionStateCopyWithImpl<RoleSelectionState>(this as RoleSelectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleSelectionState&&(identical(other.status, status) || other.status == status)&&(identical(other.highlightedRole, highlightedRole) || other.highlightedRole == highlightedRole)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,highlightedRole,errorMessage);

@override
String toString() {
  return 'RoleSelectionState(status: $status, highlightedRole: $highlightedRole, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $RoleSelectionStateCopyWith<$Res>  {
  factory $RoleSelectionStateCopyWith(RoleSelectionState value, $Res Function(RoleSelectionState) _then) = _$RoleSelectionStateCopyWithImpl;
@useResult
$Res call({
 RoleSelectionStatus status, UserRole? highlightedRole, String? errorMessage
});




}
/// @nodoc
class _$RoleSelectionStateCopyWithImpl<$Res>
    implements $RoleSelectionStateCopyWith<$Res> {
  _$RoleSelectionStateCopyWithImpl(this._self, this._then);

  final RoleSelectionState _self;
  final $Res Function(RoleSelectionState) _then;

/// Create a copy of RoleSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? highlightedRole = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoleSelectionStatus,highlightedRole: freezed == highlightedRole ? _self.highlightedRole : highlightedRole // ignore: cast_nullable_to_non_nullable
as UserRole?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleSelectionState].
extension RoleSelectionStatePatterns on RoleSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _RoleSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _RoleSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoleSelectionStatus status,  UserRole? highlightedRole,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleSelectionState() when $default != null:
return $default(_that.status,_that.highlightedRole,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoleSelectionStatus status,  UserRole? highlightedRole,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _RoleSelectionState():
return $default(_that.status,_that.highlightedRole,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoleSelectionStatus status,  UserRole? highlightedRole,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _RoleSelectionState() when $default != null:
return $default(_that.status,_that.highlightedRole,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RoleSelectionState extends RoleSelectionState {
  const _RoleSelectionState({this.status = RoleSelectionStatus.editing, this.highlightedRole, this.errorMessage}): super._();
  

@override@JsonKey() final  RoleSelectionStatus status;
@override final  UserRole? highlightedRole;
@override final  String? errorMessage;

/// Create a copy of RoleSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleSelectionStateCopyWith<_RoleSelectionState> get copyWith => __$RoleSelectionStateCopyWithImpl<_RoleSelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleSelectionState&&(identical(other.status, status) || other.status == status)&&(identical(other.highlightedRole, highlightedRole) || other.highlightedRole == highlightedRole)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,highlightedRole,errorMessage);

@override
String toString() {
  return 'RoleSelectionState(status: $status, highlightedRole: $highlightedRole, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$RoleSelectionStateCopyWith<$Res> implements $RoleSelectionStateCopyWith<$Res> {
  factory _$RoleSelectionStateCopyWith(_RoleSelectionState value, $Res Function(_RoleSelectionState) _then) = __$RoleSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 RoleSelectionStatus status, UserRole? highlightedRole, String? errorMessage
});




}
/// @nodoc
class __$RoleSelectionStateCopyWithImpl<$Res>
    implements _$RoleSelectionStateCopyWith<$Res> {
  __$RoleSelectionStateCopyWithImpl(this._self, this._then);

  final _RoleSelectionState _self;
  final $Res Function(_RoleSelectionState) _then;

/// Create a copy of RoleSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? highlightedRole = freezed,Object? errorMessage = freezed,}) {
  return _then(_RoleSelectionState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoleSelectionStatus,highlightedRole: freezed == highlightedRole ? _self.highlightedRole : highlightedRole // ignore: cast_nullable_to_non_nullable
as UserRole?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
