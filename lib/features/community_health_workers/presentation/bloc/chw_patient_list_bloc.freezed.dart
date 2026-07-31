// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chw_patient_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChwPatientListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChwPatientListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChwPatientListEvent()';
}


}

/// @nodoc
class $ChwPatientListEventCopyWith<$Res>  {
$ChwPatientListEventCopyWith(ChwPatientListEvent _, $Res Function(ChwPatientListEvent) __);
}


/// Adds pattern-matching-related methods to [ChwPatientListEvent].
extension ChwPatientListEventPatterns on ChwPatientListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChwPatientListStarted value)?  started,TResult Function( ChwPatientListRefreshed value)?  refreshed,TResult Function( ChwPatientListQueryChanged value)?  queryChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChwPatientListStarted() when started != null:
return started(_that);case ChwPatientListRefreshed() when refreshed != null:
return refreshed(_that);case ChwPatientListQueryChanged() when queryChanged != null:
return queryChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChwPatientListStarted value)  started,required TResult Function( ChwPatientListRefreshed value)  refreshed,required TResult Function( ChwPatientListQueryChanged value)  queryChanged,}){
final _that = this;
switch (_that) {
case ChwPatientListStarted():
return started(_that);case ChwPatientListRefreshed():
return refreshed(_that);case ChwPatientListQueryChanged():
return queryChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChwPatientListStarted value)?  started,TResult? Function( ChwPatientListRefreshed value)?  refreshed,TResult? Function( ChwPatientListQueryChanged value)?  queryChanged,}){
final _that = this;
switch (_that) {
case ChwPatientListStarted() when started != null:
return started(_that);case ChwPatientListRefreshed() when refreshed != null:
return refreshed(_that);case ChwPatientListQueryChanged() when queryChanged != null:
return queryChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshed,TResult Function( String query)?  queryChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChwPatientListStarted() when started != null:
return started();case ChwPatientListRefreshed() when refreshed != null:
return refreshed();case ChwPatientListQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshed,required TResult Function( String query)  queryChanged,}) {final _that = this;
switch (_that) {
case ChwPatientListStarted():
return started();case ChwPatientListRefreshed():
return refreshed();case ChwPatientListQueryChanged():
return queryChanged(_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshed,TResult? Function( String query)?  queryChanged,}) {final _that = this;
switch (_that) {
case ChwPatientListStarted() when started != null:
return started();case ChwPatientListRefreshed() when refreshed != null:
return refreshed();case ChwPatientListQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _:
  return null;

}
}

}

/// @nodoc


class ChwPatientListStarted implements ChwPatientListEvent {
  const ChwPatientListStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChwPatientListStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChwPatientListEvent.started()';
}


}




/// @nodoc


class ChwPatientListRefreshed implements ChwPatientListEvent {
  const ChwPatientListRefreshed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChwPatientListRefreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChwPatientListEvent.refreshed()';
}


}




/// @nodoc


class ChwPatientListQueryChanged implements ChwPatientListEvent {
  const ChwPatientListQueryChanged(this.query);
  

 final  String query;

/// Create a copy of ChwPatientListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChwPatientListQueryChangedCopyWith<ChwPatientListQueryChanged> get copyWith => _$ChwPatientListQueryChangedCopyWithImpl<ChwPatientListQueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChwPatientListQueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'ChwPatientListEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $ChwPatientListQueryChangedCopyWith<$Res> implements $ChwPatientListEventCopyWith<$Res> {
  factory $ChwPatientListQueryChangedCopyWith(ChwPatientListQueryChanged value, $Res Function(ChwPatientListQueryChanged) _then) = _$ChwPatientListQueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$ChwPatientListQueryChangedCopyWithImpl<$Res>
    implements $ChwPatientListQueryChangedCopyWith<$Res> {
  _$ChwPatientListQueryChangedCopyWithImpl(this._self, this._then);

  final ChwPatientListQueryChanged _self;
  final $Res Function(ChwPatientListQueryChanged) _then;

/// Create a copy of ChwPatientListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(ChwPatientListQueryChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChwPatientListState {

 ChwPatientListStatus get status; List<RegisteredPatient> get patients; String get query; String? get errorMessage;
/// Create a copy of ChwPatientListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChwPatientListStateCopyWith<ChwPatientListState> get copyWith => _$ChwPatientListStateCopyWithImpl<ChwPatientListState>(this as ChwPatientListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChwPatientListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.patients, patients)&&(identical(other.query, query) || other.query == query)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(patients),query,errorMessage);

@override
String toString() {
  return 'ChwPatientListState(status: $status, patients: $patients, query: $query, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ChwPatientListStateCopyWith<$Res>  {
  factory $ChwPatientListStateCopyWith(ChwPatientListState value, $Res Function(ChwPatientListState) _then) = _$ChwPatientListStateCopyWithImpl;
@useResult
$Res call({
 ChwPatientListStatus status, List<RegisteredPatient> patients, String query, String? errorMessage
});




}
/// @nodoc
class _$ChwPatientListStateCopyWithImpl<$Res>
    implements $ChwPatientListStateCopyWith<$Res> {
  _$ChwPatientListStateCopyWithImpl(this._self, this._then);

  final ChwPatientListState _self;
  final $Res Function(ChwPatientListState) _then;

/// Create a copy of ChwPatientListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? patients = null,Object? query = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChwPatientListStatus,patients: null == patients ? _self.patients : patients // ignore: cast_nullable_to_non_nullable
as List<RegisteredPatient>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChwPatientListState].
extension ChwPatientListStatePatterns on ChwPatientListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChwPatientListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChwPatientListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChwPatientListState value)  $default,){
final _that = this;
switch (_that) {
case _ChwPatientListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChwPatientListState value)?  $default,){
final _that = this;
switch (_that) {
case _ChwPatientListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChwPatientListStatus status,  List<RegisteredPatient> patients,  String query,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChwPatientListState() when $default != null:
return $default(_that.status,_that.patients,_that.query,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChwPatientListStatus status,  List<RegisteredPatient> patients,  String query,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ChwPatientListState():
return $default(_that.status,_that.patients,_that.query,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChwPatientListStatus status,  List<RegisteredPatient> patients,  String query,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ChwPatientListState() when $default != null:
return $default(_that.status,_that.patients,_that.query,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ChwPatientListState extends ChwPatientListState {
  const _ChwPatientListState({this.status = ChwPatientListStatus.initial, final  List<RegisteredPatient> patients = const <RegisteredPatient>[], this.query = '', this.errorMessage}): _patients = patients,super._();
  

@override@JsonKey() final  ChwPatientListStatus status;
 final  List<RegisteredPatient> _patients;
@override@JsonKey() List<RegisteredPatient> get patients {
  if (_patients is EqualUnmodifiableListView) return _patients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_patients);
}

@override@JsonKey() final  String query;
@override final  String? errorMessage;

/// Create a copy of ChwPatientListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChwPatientListStateCopyWith<_ChwPatientListState> get copyWith => __$ChwPatientListStateCopyWithImpl<_ChwPatientListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChwPatientListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._patients, _patients)&&(identical(other.query, query) || other.query == query)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_patients),query,errorMessage);

@override
String toString() {
  return 'ChwPatientListState(status: $status, patients: $patients, query: $query, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ChwPatientListStateCopyWith<$Res> implements $ChwPatientListStateCopyWith<$Res> {
  factory _$ChwPatientListStateCopyWith(_ChwPatientListState value, $Res Function(_ChwPatientListState) _then) = __$ChwPatientListStateCopyWithImpl;
@override @useResult
$Res call({
 ChwPatientListStatus status, List<RegisteredPatient> patients, String query, String? errorMessage
});




}
/// @nodoc
class __$ChwPatientListStateCopyWithImpl<$Res>
    implements _$ChwPatientListStateCopyWith<$Res> {
  __$ChwPatientListStateCopyWithImpl(this._self, this._then);

  final _ChwPatientListState _self;
  final $Res Function(_ChwPatientListState) _then;

/// Create a copy of ChwPatientListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? patients = null,Object? query = null,Object? errorMessage = freezed,}) {
  return _then(_ChwPatientListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChwPatientListStatus,patients: null == patients ? _self._patients : patients // ignore: cast_nullable_to_non_nullable
as List<RegisteredPatient>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
