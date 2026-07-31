// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_record_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthRecordEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthRecordEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HealthRecordEvent()';
}


}

/// @nodoc
class $HealthRecordEventCopyWith<$Res>  {
$HealthRecordEventCopyWith(HealthRecordEvent _, $Res Function(HealthRecordEvent) __);
}


/// Adds pattern-matching-related methods to [HealthRecordEvent].
extension HealthRecordEventPatterns on HealthRecordEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HealthRecordStarted value)?  started,TResult Function( HealthRecordTabChanged value)?  tabChanged,TResult Function( HealthRecordStepCompleted value)?  stepCompleted,TResult Function( HealthRecordAiAssessmentRequested value)?  aiAssessmentRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HealthRecordStarted() when started != null:
return started(_that);case HealthRecordTabChanged() when tabChanged != null:
return tabChanged(_that);case HealthRecordStepCompleted() when stepCompleted != null:
return stepCompleted(_that);case HealthRecordAiAssessmentRequested() when aiAssessmentRequested != null:
return aiAssessmentRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HealthRecordStarted value)  started,required TResult Function( HealthRecordTabChanged value)  tabChanged,required TResult Function( HealthRecordStepCompleted value)  stepCompleted,required TResult Function( HealthRecordAiAssessmentRequested value)  aiAssessmentRequested,}){
final _that = this;
switch (_that) {
case HealthRecordStarted():
return started(_that);case HealthRecordTabChanged():
return tabChanged(_that);case HealthRecordStepCompleted():
return stepCompleted(_that);case HealthRecordAiAssessmentRequested():
return aiAssessmentRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HealthRecordStarted value)?  started,TResult? Function( HealthRecordTabChanged value)?  tabChanged,TResult? Function( HealthRecordStepCompleted value)?  stepCompleted,TResult? Function( HealthRecordAiAssessmentRequested value)?  aiAssessmentRequested,}){
final _that = this;
switch (_that) {
case HealthRecordStarted() when started != null:
return started(_that);case HealthRecordTabChanged() when tabChanged != null:
return tabChanged(_that);case HealthRecordStepCompleted() when stepCompleted != null:
return stepCompleted(_that);case HealthRecordAiAssessmentRequested() when aiAssessmentRequested != null:
return aiAssessmentRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? patientId)?  started,TResult Function( int index)?  tabChanged,TResult Function( String stepId)?  stepCompleted,TResult Function()?  aiAssessmentRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HealthRecordStarted() when started != null:
return started(_that.patientId);case HealthRecordTabChanged() when tabChanged != null:
return tabChanged(_that.index);case HealthRecordStepCompleted() when stepCompleted != null:
return stepCompleted(_that.stepId);case HealthRecordAiAssessmentRequested() when aiAssessmentRequested != null:
return aiAssessmentRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? patientId)  started,required TResult Function( int index)  tabChanged,required TResult Function( String stepId)  stepCompleted,required TResult Function()  aiAssessmentRequested,}) {final _that = this;
switch (_that) {
case HealthRecordStarted():
return started(_that.patientId);case HealthRecordTabChanged():
return tabChanged(_that.index);case HealthRecordStepCompleted():
return stepCompleted(_that.stepId);case HealthRecordAiAssessmentRequested():
return aiAssessmentRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? patientId)?  started,TResult? Function( int index)?  tabChanged,TResult? Function( String stepId)?  stepCompleted,TResult? Function()?  aiAssessmentRequested,}) {final _that = this;
switch (_that) {
case HealthRecordStarted() when started != null:
return started(_that.patientId);case HealthRecordTabChanged() when tabChanged != null:
return tabChanged(_that.index);case HealthRecordStepCompleted() when stepCompleted != null:
return stepCompleted(_that.stepId);case HealthRecordAiAssessmentRequested() when aiAssessmentRequested != null:
return aiAssessmentRequested();case _:
  return null;

}
}

}

/// @nodoc


class HealthRecordStarted implements HealthRecordEvent {
  const HealthRecordStarted({this.patientId});
  

 final  String? patientId;

/// Create a copy of HealthRecordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthRecordStartedCopyWith<HealthRecordStarted> get copyWith => _$HealthRecordStartedCopyWithImpl<HealthRecordStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthRecordStarted&&(identical(other.patientId, patientId) || other.patientId == patientId));
}


@override
int get hashCode => Object.hash(runtimeType,patientId);

@override
String toString() {
  return 'HealthRecordEvent.started(patientId: $patientId)';
}


}

/// @nodoc
abstract mixin class $HealthRecordStartedCopyWith<$Res> implements $HealthRecordEventCopyWith<$Res> {
  factory $HealthRecordStartedCopyWith(HealthRecordStarted value, $Res Function(HealthRecordStarted) _then) = _$HealthRecordStartedCopyWithImpl;
@useResult
$Res call({
 String? patientId
});




}
/// @nodoc
class _$HealthRecordStartedCopyWithImpl<$Res>
    implements $HealthRecordStartedCopyWith<$Res> {
  _$HealthRecordStartedCopyWithImpl(this._self, this._then);

  final HealthRecordStarted _self;
  final $Res Function(HealthRecordStarted) _then;

/// Create a copy of HealthRecordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? patientId = freezed,}) {
  return _then(HealthRecordStarted(
patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class HealthRecordTabChanged implements HealthRecordEvent {
  const HealthRecordTabChanged(this.index);
  

 final  int index;

/// Create a copy of HealthRecordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthRecordTabChangedCopyWith<HealthRecordTabChanged> get copyWith => _$HealthRecordTabChangedCopyWithImpl<HealthRecordTabChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthRecordTabChanged&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'HealthRecordEvent.tabChanged(index: $index)';
}


}

/// @nodoc
abstract mixin class $HealthRecordTabChangedCopyWith<$Res> implements $HealthRecordEventCopyWith<$Res> {
  factory $HealthRecordTabChangedCopyWith(HealthRecordTabChanged value, $Res Function(HealthRecordTabChanged) _then) = _$HealthRecordTabChangedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$HealthRecordTabChangedCopyWithImpl<$Res>
    implements $HealthRecordTabChangedCopyWith<$Res> {
  _$HealthRecordTabChangedCopyWithImpl(this._self, this._then);

  final HealthRecordTabChanged _self;
  final $Res Function(HealthRecordTabChanged) _then;

/// Create a copy of HealthRecordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(HealthRecordTabChanged(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class HealthRecordStepCompleted implements HealthRecordEvent {
  const HealthRecordStepCompleted(this.stepId);
  

 final  String stepId;

/// Create a copy of HealthRecordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthRecordStepCompletedCopyWith<HealthRecordStepCompleted> get copyWith => _$HealthRecordStepCompletedCopyWithImpl<HealthRecordStepCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthRecordStepCompleted&&(identical(other.stepId, stepId) || other.stepId == stepId));
}


@override
int get hashCode => Object.hash(runtimeType,stepId);

@override
String toString() {
  return 'HealthRecordEvent.stepCompleted(stepId: $stepId)';
}


}

/// @nodoc
abstract mixin class $HealthRecordStepCompletedCopyWith<$Res> implements $HealthRecordEventCopyWith<$Res> {
  factory $HealthRecordStepCompletedCopyWith(HealthRecordStepCompleted value, $Res Function(HealthRecordStepCompleted) _then) = _$HealthRecordStepCompletedCopyWithImpl;
@useResult
$Res call({
 String stepId
});




}
/// @nodoc
class _$HealthRecordStepCompletedCopyWithImpl<$Res>
    implements $HealthRecordStepCompletedCopyWith<$Res> {
  _$HealthRecordStepCompletedCopyWithImpl(this._self, this._then);

  final HealthRecordStepCompleted _self;
  final $Res Function(HealthRecordStepCompleted) _then;

/// Create a copy of HealthRecordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stepId = null,}) {
  return _then(HealthRecordStepCompleted(
null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HealthRecordAiAssessmentRequested implements HealthRecordEvent {
  const HealthRecordAiAssessmentRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthRecordAiAssessmentRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HealthRecordEvent.aiAssessmentRequested()';
}


}




/// @nodoc
mixin _$HealthRecordState {

 HealthRecordStatus get status; HealthRecord? get record; String? get patientId; int get selectedTab; bool get isRefreshingAssessment; String? get errorMessage;
/// Create a copy of HealthRecordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthRecordStateCopyWith<HealthRecordState> get copyWith => _$HealthRecordStateCopyWithImpl<HealthRecordState>(this as HealthRecordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthRecordState&&(identical(other.status, status) || other.status == status)&&(identical(other.record, record) || other.record == record)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.isRefreshingAssessment, isRefreshingAssessment) || other.isRefreshingAssessment == isRefreshingAssessment)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,record,patientId,selectedTab,isRefreshingAssessment,errorMessage);

@override
String toString() {
  return 'HealthRecordState(status: $status, record: $record, patientId: $patientId, selectedTab: $selectedTab, isRefreshingAssessment: $isRefreshingAssessment, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $HealthRecordStateCopyWith<$Res>  {
  factory $HealthRecordStateCopyWith(HealthRecordState value, $Res Function(HealthRecordState) _then) = _$HealthRecordStateCopyWithImpl;
@useResult
$Res call({
 HealthRecordStatus status, HealthRecord? record, String? patientId, int selectedTab, bool isRefreshingAssessment, String? errorMessage
});




}
/// @nodoc
class _$HealthRecordStateCopyWithImpl<$Res>
    implements $HealthRecordStateCopyWith<$Res> {
  _$HealthRecordStateCopyWithImpl(this._self, this._then);

  final HealthRecordState _self;
  final $Res Function(HealthRecordState) _then;

/// Create a copy of HealthRecordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? record = freezed,Object? patientId = freezed,Object? selectedTab = null,Object? isRefreshingAssessment = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthRecordStatus,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as HealthRecord?,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,isRefreshingAssessment: null == isRefreshingAssessment ? _self.isRefreshingAssessment : isRefreshingAssessment // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthRecordState].
extension HealthRecordStatePatterns on HealthRecordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthRecordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthRecordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthRecordState value)  $default,){
final _that = this;
switch (_that) {
case _HealthRecordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthRecordState value)?  $default,){
final _that = this;
switch (_that) {
case _HealthRecordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HealthRecordStatus status,  HealthRecord? record,  String? patientId,  int selectedTab,  bool isRefreshingAssessment,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthRecordState() when $default != null:
return $default(_that.status,_that.record,_that.patientId,_that.selectedTab,_that.isRefreshingAssessment,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HealthRecordStatus status,  HealthRecord? record,  String? patientId,  int selectedTab,  bool isRefreshingAssessment,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _HealthRecordState():
return $default(_that.status,_that.record,_that.patientId,_that.selectedTab,_that.isRefreshingAssessment,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HealthRecordStatus status,  HealthRecord? record,  String? patientId,  int selectedTab,  bool isRefreshingAssessment,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _HealthRecordState() when $default != null:
return $default(_that.status,_that.record,_that.patientId,_that.selectedTab,_that.isRefreshingAssessment,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _HealthRecordState extends HealthRecordState {
  const _HealthRecordState({this.status = HealthRecordStatus.initial, this.record, this.patientId, this.selectedTab = 0, this.isRefreshingAssessment = false, this.errorMessage}): super._();
  

@override@JsonKey() final  HealthRecordStatus status;
@override final  HealthRecord? record;
@override final  String? patientId;
@override@JsonKey() final  int selectedTab;
@override@JsonKey() final  bool isRefreshingAssessment;
@override final  String? errorMessage;

/// Create a copy of HealthRecordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthRecordStateCopyWith<_HealthRecordState> get copyWith => __$HealthRecordStateCopyWithImpl<_HealthRecordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthRecordState&&(identical(other.status, status) || other.status == status)&&(identical(other.record, record) || other.record == record)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.isRefreshingAssessment, isRefreshingAssessment) || other.isRefreshingAssessment == isRefreshingAssessment)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,record,patientId,selectedTab,isRefreshingAssessment,errorMessage);

@override
String toString() {
  return 'HealthRecordState(status: $status, record: $record, patientId: $patientId, selectedTab: $selectedTab, isRefreshingAssessment: $isRefreshingAssessment, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$HealthRecordStateCopyWith<$Res> implements $HealthRecordStateCopyWith<$Res> {
  factory _$HealthRecordStateCopyWith(_HealthRecordState value, $Res Function(_HealthRecordState) _then) = __$HealthRecordStateCopyWithImpl;
@override @useResult
$Res call({
 HealthRecordStatus status, HealthRecord? record, String? patientId, int selectedTab, bool isRefreshingAssessment, String? errorMessage
});




}
/// @nodoc
class __$HealthRecordStateCopyWithImpl<$Res>
    implements _$HealthRecordStateCopyWith<$Res> {
  __$HealthRecordStateCopyWithImpl(this._self, this._then);

  final _HealthRecordState _self;
  final $Res Function(_HealthRecordState) _then;

/// Create a copy of HealthRecordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? record = freezed,Object? patientId = freezed,Object? selectedTab = null,Object? isRefreshingAssessment = null,Object? errorMessage = freezed,}) {
  return _then(_HealthRecordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthRecordStatus,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as HealthRecord?,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,isRefreshingAssessment: null == isRefreshingAssessment ? _self.isRefreshingAssessment : isRefreshingAssessment // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
