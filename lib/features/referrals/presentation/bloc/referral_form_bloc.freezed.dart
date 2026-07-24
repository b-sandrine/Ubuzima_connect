// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_form_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReferralFormEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralFormEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReferralFormEvent()';
}


}

/// @nodoc
class $ReferralFormEventCopyWith<$Res>  {
$ReferralFormEventCopyWith(ReferralFormEvent _, $Res Function(ReferralFormEvent) __);
}


/// Adds pattern-matching-related methods to [ReferralFormEvent].
extension ReferralFormEventPatterns on ReferralFormEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReferralFieldChanged value)?  fieldChanged,TResult Function( ReferralUrgencyChanged value)?  urgencyChanged,TResult Function( ReferralFormSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReferralFieldChanged() when fieldChanged != null:
return fieldChanged(_that);case ReferralUrgencyChanged() when urgencyChanged != null:
return urgencyChanged(_that);case ReferralFormSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReferralFieldChanged value)  fieldChanged,required TResult Function( ReferralUrgencyChanged value)  urgencyChanged,required TResult Function( ReferralFormSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case ReferralFieldChanged():
return fieldChanged(_that);case ReferralUrgencyChanged():
return urgencyChanged(_that);case ReferralFormSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReferralFieldChanged value)?  fieldChanged,TResult? Function( ReferralUrgencyChanged value)?  urgencyChanged,TResult? Function( ReferralFormSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case ReferralFieldChanged() when fieldChanged != null:
return fieldChanged(_that);case ReferralUrgencyChanged() when urgencyChanged != null:
return urgencyChanged(_that);case ReferralFormSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ReferralField field,  String value)?  fieldChanged,TResult Function( ReferralUrgency urgency)?  urgencyChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReferralFieldChanged() when fieldChanged != null:
return fieldChanged(_that.field,_that.value);case ReferralUrgencyChanged() when urgencyChanged != null:
return urgencyChanged(_that.urgency);case ReferralFormSubmitted() when submitted != null:
return submitted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ReferralField field,  String value)  fieldChanged,required TResult Function( ReferralUrgency urgency)  urgencyChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case ReferralFieldChanged():
return fieldChanged(_that.field,_that.value);case ReferralUrgencyChanged():
return urgencyChanged(_that.urgency);case ReferralFormSubmitted():
return submitted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ReferralField field,  String value)?  fieldChanged,TResult? Function( ReferralUrgency urgency)?  urgencyChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case ReferralFieldChanged() when fieldChanged != null:
return fieldChanged(_that.field,_that.value);case ReferralUrgencyChanged() when urgencyChanged != null:
return urgencyChanged(_that.urgency);case ReferralFormSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class ReferralFieldChanged implements ReferralFormEvent {
  const ReferralFieldChanged(this.field, this.value);
  

 final  ReferralField field;
 final  String value;

/// Create a copy of ReferralFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralFieldChangedCopyWith<ReferralFieldChanged> get copyWith => _$ReferralFieldChangedCopyWithImpl<ReferralFieldChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralFieldChanged&&(identical(other.field, field) || other.field == field)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,field,value);

@override
String toString() {
  return 'ReferralFormEvent.fieldChanged(field: $field, value: $value)';
}


}

/// @nodoc
abstract mixin class $ReferralFieldChangedCopyWith<$Res> implements $ReferralFormEventCopyWith<$Res> {
  factory $ReferralFieldChangedCopyWith(ReferralFieldChanged value, $Res Function(ReferralFieldChanged) _then) = _$ReferralFieldChangedCopyWithImpl;
@useResult
$Res call({
 ReferralField field, String value
});




}
/// @nodoc
class _$ReferralFieldChangedCopyWithImpl<$Res>
    implements $ReferralFieldChangedCopyWith<$Res> {
  _$ReferralFieldChangedCopyWithImpl(this._self, this._then);

  final ReferralFieldChanged _self;
  final $Res Function(ReferralFieldChanged) _then;

/// Create a copy of ReferralFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field = null,Object? value = null,}) {
  return _then(ReferralFieldChanged(
null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as ReferralField,null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ReferralUrgencyChanged implements ReferralFormEvent {
  const ReferralUrgencyChanged(this.urgency);
  

 final  ReferralUrgency urgency;

/// Create a copy of ReferralFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralUrgencyChangedCopyWith<ReferralUrgencyChanged> get copyWith => _$ReferralUrgencyChangedCopyWithImpl<ReferralUrgencyChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralUrgencyChanged&&(identical(other.urgency, urgency) || other.urgency == urgency));
}


@override
int get hashCode => Object.hash(runtimeType,urgency);

@override
String toString() {
  return 'ReferralFormEvent.urgencyChanged(urgency: $urgency)';
}


}

/// @nodoc
abstract mixin class $ReferralUrgencyChangedCopyWith<$Res> implements $ReferralFormEventCopyWith<$Res> {
  factory $ReferralUrgencyChangedCopyWith(ReferralUrgencyChanged value, $Res Function(ReferralUrgencyChanged) _then) = _$ReferralUrgencyChangedCopyWithImpl;
@useResult
$Res call({
 ReferralUrgency urgency
});




}
/// @nodoc
class _$ReferralUrgencyChangedCopyWithImpl<$Res>
    implements $ReferralUrgencyChangedCopyWith<$Res> {
  _$ReferralUrgencyChangedCopyWithImpl(this._self, this._then);

  final ReferralUrgencyChanged _self;
  final $Res Function(ReferralUrgencyChanged) _then;

/// Create a copy of ReferralFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? urgency = null,}) {
  return _then(ReferralUrgencyChanged(
null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as ReferralUrgency,
  ));
}


}

/// @nodoc


class ReferralFormSubmitted implements ReferralFormEvent {
  const ReferralFormSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralFormSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReferralFormEvent.submitted()';
}


}




/// @nodoc
mixin _$ReferralFormState {

 ReferralDraft get draft; ReferralFormStatus get status; String? get createdReference; String? get errorMessage;
/// Create a copy of ReferralFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralFormStateCopyWith<ReferralFormState> get copyWith => _$ReferralFormStateCopyWithImpl<ReferralFormState>(this as ReferralFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralFormState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdReference, createdReference) || other.createdReference == createdReference)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,draft,status,createdReference,errorMessage);

@override
String toString() {
  return 'ReferralFormState(draft: $draft, status: $status, createdReference: $createdReference, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ReferralFormStateCopyWith<$Res>  {
  factory $ReferralFormStateCopyWith(ReferralFormState value, $Res Function(ReferralFormState) _then) = _$ReferralFormStateCopyWithImpl;
@useResult
$Res call({
 ReferralDraft draft, ReferralFormStatus status, String? createdReference, String? errorMessage
});




}
/// @nodoc
class _$ReferralFormStateCopyWithImpl<$Res>
    implements $ReferralFormStateCopyWith<$Res> {
  _$ReferralFormStateCopyWithImpl(this._self, this._then);

  final ReferralFormState _self;
  final $Res Function(ReferralFormState) _then;

/// Create a copy of ReferralFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = null,Object? status = null,Object? createdReference = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReferralDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReferralFormStatus,createdReference: freezed == createdReference ? _self.createdReference : createdReference // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralFormState].
extension ReferralFormStatePatterns on ReferralFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralFormState value)  $default,){
final _that = this;
switch (_that) {
case _ReferralFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReferralDraft draft,  ReferralFormStatus status,  String? createdReference,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralFormState() when $default != null:
return $default(_that.draft,_that.status,_that.createdReference,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReferralDraft draft,  ReferralFormStatus status,  String? createdReference,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ReferralFormState():
return $default(_that.draft,_that.status,_that.createdReference,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReferralDraft draft,  ReferralFormStatus status,  String? createdReference,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ReferralFormState() when $default != null:
return $default(_that.draft,_that.status,_that.createdReference,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ReferralFormState extends ReferralFormState {
  const _ReferralFormState({this.draft = const ReferralDraft(), this.status = ReferralFormStatus.editing, this.createdReference, this.errorMessage}): super._();
  

@override@JsonKey() final  ReferralDraft draft;
@override@JsonKey() final  ReferralFormStatus status;
@override final  String? createdReference;
@override final  String? errorMessage;

/// Create a copy of ReferralFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralFormStateCopyWith<_ReferralFormState> get copyWith => __$ReferralFormStateCopyWithImpl<_ReferralFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralFormState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdReference, createdReference) || other.createdReference == createdReference)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,draft,status,createdReference,errorMessage);

@override
String toString() {
  return 'ReferralFormState(draft: $draft, status: $status, createdReference: $createdReference, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ReferralFormStateCopyWith<$Res> implements $ReferralFormStateCopyWith<$Res> {
  factory _$ReferralFormStateCopyWith(_ReferralFormState value, $Res Function(_ReferralFormState) _then) = __$ReferralFormStateCopyWithImpl;
@override @useResult
$Res call({
 ReferralDraft draft, ReferralFormStatus status, String? createdReference, String? errorMessage
});




}
/// @nodoc
class __$ReferralFormStateCopyWithImpl<$Res>
    implements _$ReferralFormStateCopyWith<$Res> {
  __$ReferralFormStateCopyWithImpl(this._self, this._then);

  final _ReferralFormState _self;
  final $Res Function(_ReferralFormState) _then;

/// Create a copy of ReferralFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? status = null,Object? createdReference = freezed,Object? errorMessage = freezed,}) {
  return _then(_ReferralFormState(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReferralDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReferralFormStatus,createdReference: freezed == createdReference ? _self.createdReference : createdReference // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
