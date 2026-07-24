// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MedicationEvent()';
}


}

/// @nodoc
class $MedicationEventCopyWith<$Res>  {
$MedicationEventCopyWith(MedicationEvent _, $Res Function(MedicationEvent) __);
}


/// Adds pattern-matching-related methods to [MedicationEvent].
extension MedicationEventPatterns on MedicationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MedicationStarted value)?  started,TResult Function( MedicationTabChanged value)?  tabChanged,TResult Function( DoseMarkedTaken value)?  doseMarkedTaken,TResult Function( RefillRequested value)?  refillRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MedicationStarted() when started != null:
return started(_that);case MedicationTabChanged() when tabChanged != null:
return tabChanged(_that);case DoseMarkedTaken() when doseMarkedTaken != null:
return doseMarkedTaken(_that);case RefillRequested() when refillRequested != null:
return refillRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MedicationStarted value)  started,required TResult Function( MedicationTabChanged value)  tabChanged,required TResult Function( DoseMarkedTaken value)  doseMarkedTaken,required TResult Function( RefillRequested value)  refillRequested,}){
final _that = this;
switch (_that) {
case MedicationStarted():
return started(_that);case MedicationTabChanged():
return tabChanged(_that);case DoseMarkedTaken():
return doseMarkedTaken(_that);case RefillRequested():
return refillRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MedicationStarted value)?  started,TResult? Function( MedicationTabChanged value)?  tabChanged,TResult? Function( DoseMarkedTaken value)?  doseMarkedTaken,TResult? Function( RefillRequested value)?  refillRequested,}){
final _that = this;
switch (_that) {
case MedicationStarted() when started != null:
return started(_that);case MedicationTabChanged() when tabChanged != null:
return tabChanged(_that);case DoseMarkedTaken() when doseMarkedTaken != null:
return doseMarkedTaken(_that);case RefillRequested() when refillRequested != null:
return refillRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( int index)?  tabChanged,TResult Function( String doseId)?  doseMarkedTaken,TResult Function()?  refillRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MedicationStarted() when started != null:
return started();case MedicationTabChanged() when tabChanged != null:
return tabChanged(_that.index);case DoseMarkedTaken() when doseMarkedTaken != null:
return doseMarkedTaken(_that.doseId);case RefillRequested() when refillRequested != null:
return refillRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( int index)  tabChanged,required TResult Function( String doseId)  doseMarkedTaken,required TResult Function()  refillRequested,}) {final _that = this;
switch (_that) {
case MedicationStarted():
return started();case MedicationTabChanged():
return tabChanged(_that.index);case DoseMarkedTaken():
return doseMarkedTaken(_that.doseId);case RefillRequested():
return refillRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( int index)?  tabChanged,TResult? Function( String doseId)?  doseMarkedTaken,TResult? Function()?  refillRequested,}) {final _that = this;
switch (_that) {
case MedicationStarted() when started != null:
return started();case MedicationTabChanged() when tabChanged != null:
return tabChanged(_that.index);case DoseMarkedTaken() when doseMarkedTaken != null:
return doseMarkedTaken(_that.doseId);case RefillRequested() when refillRequested != null:
return refillRequested();case _:
  return null;

}
}

}

/// @nodoc


class MedicationStarted implements MedicationEvent {
  const MedicationStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MedicationEvent.started()';
}


}




/// @nodoc


class MedicationTabChanged implements MedicationEvent {
  const MedicationTabChanged(this.index);
  

 final  int index;

/// Create a copy of MedicationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationTabChangedCopyWith<MedicationTabChanged> get copyWith => _$MedicationTabChangedCopyWithImpl<MedicationTabChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationTabChanged&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'MedicationEvent.tabChanged(index: $index)';
}


}

/// @nodoc
abstract mixin class $MedicationTabChangedCopyWith<$Res> implements $MedicationEventCopyWith<$Res> {
  factory $MedicationTabChangedCopyWith(MedicationTabChanged value, $Res Function(MedicationTabChanged) _then) = _$MedicationTabChangedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$MedicationTabChangedCopyWithImpl<$Res>
    implements $MedicationTabChangedCopyWith<$Res> {
  _$MedicationTabChangedCopyWithImpl(this._self, this._then);

  final MedicationTabChanged _self;
  final $Res Function(MedicationTabChanged) _then;

/// Create a copy of MedicationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(MedicationTabChanged(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DoseMarkedTaken implements MedicationEvent {
  const DoseMarkedTaken(this.doseId);
  

 final  String doseId;

/// Create a copy of MedicationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseMarkedTakenCopyWith<DoseMarkedTaken> get copyWith => _$DoseMarkedTakenCopyWithImpl<DoseMarkedTaken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseMarkedTaken&&(identical(other.doseId, doseId) || other.doseId == doseId));
}


@override
int get hashCode => Object.hash(runtimeType,doseId);

@override
String toString() {
  return 'MedicationEvent.doseMarkedTaken(doseId: $doseId)';
}


}

/// @nodoc
abstract mixin class $DoseMarkedTakenCopyWith<$Res> implements $MedicationEventCopyWith<$Res> {
  factory $DoseMarkedTakenCopyWith(DoseMarkedTaken value, $Res Function(DoseMarkedTaken) _then) = _$DoseMarkedTakenCopyWithImpl;
@useResult
$Res call({
 String doseId
});




}
/// @nodoc
class _$DoseMarkedTakenCopyWithImpl<$Res>
    implements $DoseMarkedTakenCopyWith<$Res> {
  _$DoseMarkedTakenCopyWithImpl(this._self, this._then);

  final DoseMarkedTaken _self;
  final $Res Function(DoseMarkedTaken) _then;

/// Create a copy of MedicationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? doseId = null,}) {
  return _then(DoseMarkedTaken(
null == doseId ? _self.doseId : doseId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RefillRequested implements MedicationEvent {
  const RefillRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefillRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MedicationEvent.refillRequested()';
}


}




/// @nodoc
mixin _$MedicationState {

 MedicationStatus get status; MedicationSchedule? get schedule; int get selectedTab; String? get errorMessage;
/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationStateCopyWith<MedicationState> get copyWith => _$MedicationStateCopyWithImpl<MedicationState>(this as MedicationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationState&&(identical(other.status, status) || other.status == status)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,schedule,selectedTab,errorMessage);

@override
String toString() {
  return 'MedicationState(status: $status, schedule: $schedule, selectedTab: $selectedTab, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $MedicationStateCopyWith<$Res>  {
  factory $MedicationStateCopyWith(MedicationState value, $Res Function(MedicationState) _then) = _$MedicationStateCopyWithImpl;
@useResult
$Res call({
 MedicationStatus status, MedicationSchedule? schedule, int selectedTab, String? errorMessage
});




}
/// @nodoc
class _$MedicationStateCopyWithImpl<$Res>
    implements $MedicationStateCopyWith<$Res> {
  _$MedicationStateCopyWithImpl(this._self, this._then);

  final MedicationState _self;
  final $Res Function(MedicationState) _then;

/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? schedule = freezed,Object? selectedTab = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationStatus,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as MedicationSchedule?,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationState].
extension MedicationStatePatterns on MedicationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationState value)  $default,){
final _that = this;
switch (_that) {
case _MedicationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationState value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MedicationStatus status,  MedicationSchedule? schedule,  int selectedTab,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationState() when $default != null:
return $default(_that.status,_that.schedule,_that.selectedTab,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MedicationStatus status,  MedicationSchedule? schedule,  int selectedTab,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _MedicationState():
return $default(_that.status,_that.schedule,_that.selectedTab,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MedicationStatus status,  MedicationSchedule? schedule,  int selectedTab,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _MedicationState() when $default != null:
return $default(_that.status,_that.schedule,_that.selectedTab,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationState extends MedicationState {
  const _MedicationState({this.status = MedicationStatus.initial, this.schedule, this.selectedTab = 0, this.errorMessage}): super._();
  

@override@JsonKey() final  MedicationStatus status;
@override final  MedicationSchedule? schedule;
@override@JsonKey() final  int selectedTab;
@override final  String? errorMessage;

/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationStateCopyWith<_MedicationState> get copyWith => __$MedicationStateCopyWithImpl<_MedicationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationState&&(identical(other.status, status) || other.status == status)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,schedule,selectedTab,errorMessage);

@override
String toString() {
  return 'MedicationState(status: $status, schedule: $schedule, selectedTab: $selectedTab, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$MedicationStateCopyWith<$Res> implements $MedicationStateCopyWith<$Res> {
  factory _$MedicationStateCopyWith(_MedicationState value, $Res Function(_MedicationState) _then) = __$MedicationStateCopyWithImpl;
@override @useResult
$Res call({
 MedicationStatus status, MedicationSchedule? schedule, int selectedTab, String? errorMessage
});




}
/// @nodoc
class __$MedicationStateCopyWithImpl<$Res>
    implements _$MedicationStateCopyWith<$Res> {
  __$MedicationStateCopyWithImpl(this._self, this._then);

  final _MedicationState _self;
  final $Res Function(_MedicationState) _then;

/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? schedule = freezed,Object? selectedTab = null,Object? errorMessage = freezed,}) {
  return _then(_MedicationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationStatus,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as MedicationSchedule?,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
