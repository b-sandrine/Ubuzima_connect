// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_intake_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PatientIntakeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientIntakeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PatientIntakeEvent()';
}


}

/// @nodoc
class $PatientIntakeEventCopyWith<$Res>  {
$PatientIntakeEventCopyWith(PatientIntakeEvent _, $Res Function(PatientIntakeEvent) __);
}


/// Adds pattern-matching-related methods to [PatientIntakeEvent].
extension PatientIntakeEventPatterns on PatientIntakeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PatientIntakeDraftUpdated value)?  draftUpdated,TResult Function( PatientIntakeStepChanged value)?  stepChanged,TResult Function( PatientIntakeSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PatientIntakeDraftUpdated() when draftUpdated != null:
return draftUpdated(_that);case PatientIntakeStepChanged() when stepChanged != null:
return stepChanged(_that);case PatientIntakeSubmitted() when submitted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PatientIntakeDraftUpdated value)  draftUpdated,required TResult Function( PatientIntakeStepChanged value)  stepChanged,required TResult Function( PatientIntakeSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case PatientIntakeDraftUpdated():
return draftUpdated(_that);case PatientIntakeStepChanged():
return stepChanged(_that);case PatientIntakeSubmitted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PatientIntakeDraftUpdated value)?  draftUpdated,TResult? Function( PatientIntakeStepChanged value)?  stepChanged,TResult? Function( PatientIntakeSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case PatientIntakeDraftUpdated() when draftUpdated != null:
return draftUpdated(_that);case PatientIntakeStepChanged() when stepChanged != null:
return stepChanged(_that);case PatientIntakeSubmitted() when submitted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PatientIntakeDraft draft)?  draftUpdated,TResult Function( int step)?  stepChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PatientIntakeDraftUpdated() when draftUpdated != null:
return draftUpdated(_that.draft);case PatientIntakeStepChanged() when stepChanged != null:
return stepChanged(_that.step);case PatientIntakeSubmitted() when submitted != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PatientIntakeDraft draft)  draftUpdated,required TResult Function( int step)  stepChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case PatientIntakeDraftUpdated():
return draftUpdated(_that.draft);case PatientIntakeStepChanged():
return stepChanged(_that.step);case PatientIntakeSubmitted():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PatientIntakeDraft draft)?  draftUpdated,TResult? Function( int step)?  stepChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case PatientIntakeDraftUpdated() when draftUpdated != null:
return draftUpdated(_that.draft);case PatientIntakeStepChanged() when stepChanged != null:
return stepChanged(_that.step);case PatientIntakeSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class PatientIntakeDraftUpdated implements PatientIntakeEvent {
  const PatientIntakeDraftUpdated(this.draft);
  

 final  PatientIntakeDraft draft;

/// Create a copy of PatientIntakeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientIntakeDraftUpdatedCopyWith<PatientIntakeDraftUpdated> get copyWith => _$PatientIntakeDraftUpdatedCopyWithImpl<PatientIntakeDraftUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientIntakeDraftUpdated&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,draft);

@override
String toString() {
  return 'PatientIntakeEvent.draftUpdated(draft: $draft)';
}


}

/// @nodoc
abstract mixin class $PatientIntakeDraftUpdatedCopyWith<$Res> implements $PatientIntakeEventCopyWith<$Res> {
  factory $PatientIntakeDraftUpdatedCopyWith(PatientIntakeDraftUpdated value, $Res Function(PatientIntakeDraftUpdated) _then) = _$PatientIntakeDraftUpdatedCopyWithImpl;
@useResult
$Res call({
 PatientIntakeDraft draft
});




}
/// @nodoc
class _$PatientIntakeDraftUpdatedCopyWithImpl<$Res>
    implements $PatientIntakeDraftUpdatedCopyWith<$Res> {
  _$PatientIntakeDraftUpdatedCopyWithImpl(this._self, this._then);

  final PatientIntakeDraftUpdated _self;
  final $Res Function(PatientIntakeDraftUpdated) _then;

/// Create a copy of PatientIntakeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,}) {
  return _then(PatientIntakeDraftUpdated(
null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as PatientIntakeDraft,
  ));
}


}

/// @nodoc


class PatientIntakeStepChanged implements PatientIntakeEvent {
  const PatientIntakeStepChanged(this.step);
  

 final  int step;

/// Create a copy of PatientIntakeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientIntakeStepChangedCopyWith<PatientIntakeStepChanged> get copyWith => _$PatientIntakeStepChangedCopyWithImpl<PatientIntakeStepChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientIntakeStepChanged&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,step);

@override
String toString() {
  return 'PatientIntakeEvent.stepChanged(step: $step)';
}


}

/// @nodoc
abstract mixin class $PatientIntakeStepChangedCopyWith<$Res> implements $PatientIntakeEventCopyWith<$Res> {
  factory $PatientIntakeStepChangedCopyWith(PatientIntakeStepChanged value, $Res Function(PatientIntakeStepChanged) _then) = _$PatientIntakeStepChangedCopyWithImpl;
@useResult
$Res call({
 int step
});




}
/// @nodoc
class _$PatientIntakeStepChangedCopyWithImpl<$Res>
    implements $PatientIntakeStepChangedCopyWith<$Res> {
  _$PatientIntakeStepChangedCopyWithImpl(this._self, this._then);

  final PatientIntakeStepChanged _self;
  final $Res Function(PatientIntakeStepChanged) _then;

/// Create a copy of PatientIntakeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? step = null,}) {
  return _then(PatientIntakeStepChanged(
null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PatientIntakeSubmitted implements PatientIntakeEvent {
  const PatientIntakeSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientIntakeSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PatientIntakeEvent.submitted()';
}


}




/// @nodoc
mixin _$PatientIntakeState {

 int get step; PatientIntakeDraft get draft; PatientIntakeStatus get status; String? get errorMessage; String? get createdPatientId;
/// Create a copy of PatientIntakeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientIntakeStateCopyWith<PatientIntakeState> get copyWith => _$PatientIntakeStateCopyWithImpl<PatientIntakeState>(this as PatientIntakeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientIntakeState&&(identical(other.step, step) || other.step == step)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdPatientId, createdPatientId) || other.createdPatientId == createdPatientId));
}


@override
int get hashCode => Object.hash(runtimeType,step,draft,status,errorMessage,createdPatientId);

@override
String toString() {
  return 'PatientIntakeState(step: $step, draft: $draft, status: $status, errorMessage: $errorMessage, createdPatientId: $createdPatientId)';
}


}

/// @nodoc
abstract mixin class $PatientIntakeStateCopyWith<$Res>  {
  factory $PatientIntakeStateCopyWith(PatientIntakeState value, $Res Function(PatientIntakeState) _then) = _$PatientIntakeStateCopyWithImpl;
@useResult
$Res call({
 int step, PatientIntakeDraft draft, PatientIntakeStatus status, String? errorMessage, String? createdPatientId
});




}
/// @nodoc
class _$PatientIntakeStateCopyWithImpl<$Res>
    implements $PatientIntakeStateCopyWith<$Res> {
  _$PatientIntakeStateCopyWithImpl(this._self, this._then);

  final PatientIntakeState _self;
  final $Res Function(PatientIntakeState) _then;

/// Create a copy of PatientIntakeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? draft = null,Object? status = null,Object? errorMessage = freezed,Object? createdPatientId = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as PatientIntakeDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PatientIntakeStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdPatientId: freezed == createdPatientId ? _self.createdPatientId : createdPatientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientIntakeState].
extension PatientIntakeStatePatterns on PatientIntakeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientIntakeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientIntakeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientIntakeState value)  $default,){
final _that = this;
switch (_that) {
case _PatientIntakeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientIntakeState value)?  $default,){
final _that = this;
switch (_that) {
case _PatientIntakeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int step,  PatientIntakeDraft draft,  PatientIntakeStatus status,  String? errorMessage,  String? createdPatientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientIntakeState() when $default != null:
return $default(_that.step,_that.draft,_that.status,_that.errorMessage,_that.createdPatientId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int step,  PatientIntakeDraft draft,  PatientIntakeStatus status,  String? errorMessage,  String? createdPatientId)  $default,) {final _that = this;
switch (_that) {
case _PatientIntakeState():
return $default(_that.step,_that.draft,_that.status,_that.errorMessage,_that.createdPatientId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int step,  PatientIntakeDraft draft,  PatientIntakeStatus status,  String? errorMessage,  String? createdPatientId)?  $default,) {final _that = this;
switch (_that) {
case _PatientIntakeState() when $default != null:
return $default(_that.step,_that.draft,_that.status,_that.errorMessage,_that.createdPatientId);case _:
  return null;

}
}

}

/// @nodoc


class _PatientIntakeState extends PatientIntakeState {
  const _PatientIntakeState({this.step = 0, this.draft = const PatientIntakeDraft(), this.status = PatientIntakeStatus.editing, this.errorMessage, this.createdPatientId}): super._();
  

@override@JsonKey() final  int step;
@override@JsonKey() final  PatientIntakeDraft draft;
@override@JsonKey() final  PatientIntakeStatus status;
@override final  String? errorMessage;
@override final  String? createdPatientId;

/// Create a copy of PatientIntakeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientIntakeStateCopyWith<_PatientIntakeState> get copyWith => __$PatientIntakeStateCopyWithImpl<_PatientIntakeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientIntakeState&&(identical(other.step, step) || other.step == step)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdPatientId, createdPatientId) || other.createdPatientId == createdPatientId));
}


@override
int get hashCode => Object.hash(runtimeType,step,draft,status,errorMessage,createdPatientId);

@override
String toString() {
  return 'PatientIntakeState(step: $step, draft: $draft, status: $status, errorMessage: $errorMessage, createdPatientId: $createdPatientId)';
}


}

/// @nodoc
abstract mixin class _$PatientIntakeStateCopyWith<$Res> implements $PatientIntakeStateCopyWith<$Res> {
  factory _$PatientIntakeStateCopyWith(_PatientIntakeState value, $Res Function(_PatientIntakeState) _then) = __$PatientIntakeStateCopyWithImpl;
@override @useResult
$Res call({
 int step, PatientIntakeDraft draft, PatientIntakeStatus status, String? errorMessage, String? createdPatientId
});




}
/// @nodoc
class __$PatientIntakeStateCopyWithImpl<$Res>
    implements _$PatientIntakeStateCopyWith<$Res> {
  __$PatientIntakeStateCopyWithImpl(this._self, this._then);

  final _PatientIntakeState _self;
  final $Res Function(_PatientIntakeState) _then;

/// Create a copy of PatientIntakeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? draft = null,Object? status = null,Object? errorMessage = freezed,Object? createdPatientId = freezed,}) {
  return _then(_PatientIntakeState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as PatientIntakeDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PatientIntakeStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdPatientId: freezed == createdPatientId ? _self.createdPatientId : createdPatientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
