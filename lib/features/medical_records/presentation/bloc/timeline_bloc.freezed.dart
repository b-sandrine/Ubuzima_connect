// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimelineViewEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineViewEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineViewEvent()';
}


}

/// @nodoc
class $TimelineViewEventCopyWith<$Res>  {
$TimelineViewEventCopyWith(TimelineViewEvent _, $Res Function(TimelineViewEvent) __);
}


/// Adds pattern-matching-related methods to [TimelineViewEvent].
extension TimelineViewEventPatterns on TimelineViewEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TimelineStarted value)?  started,TResult Function( TimelineFilterChanged value)?  filterChanged,TResult Function( TimelineSearchChanged value)?  searchChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TimelineStarted() when started != null:
return started(_that);case TimelineFilterChanged() when filterChanged != null:
return filterChanged(_that);case TimelineSearchChanged() when searchChanged != null:
return searchChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TimelineStarted value)  started,required TResult Function( TimelineFilterChanged value)  filterChanged,required TResult Function( TimelineSearchChanged value)  searchChanged,}){
final _that = this;
switch (_that) {
case TimelineStarted():
return started(_that);case TimelineFilterChanged():
return filterChanged(_that);case TimelineSearchChanged():
return searchChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TimelineStarted value)?  started,TResult? Function( TimelineFilterChanged value)?  filterChanged,TResult? Function( TimelineSearchChanged value)?  searchChanged,}){
final _that = this;
switch (_that) {
case TimelineStarted() when started != null:
return started(_that);case TimelineFilterChanged() when filterChanged != null:
return filterChanged(_that);case TimelineSearchChanged() when searchChanged != null:
return searchChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( TimelineFilter filter)?  filterChanged,TResult Function( String query)?  searchChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TimelineStarted() when started != null:
return started();case TimelineFilterChanged() when filterChanged != null:
return filterChanged(_that.filter);case TimelineSearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( TimelineFilter filter)  filterChanged,required TResult Function( String query)  searchChanged,}) {final _that = this;
switch (_that) {
case TimelineStarted():
return started();case TimelineFilterChanged():
return filterChanged(_that.filter);case TimelineSearchChanged():
return searchChanged(_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( TimelineFilter filter)?  filterChanged,TResult? Function( String query)?  searchChanged,}) {final _that = this;
switch (_that) {
case TimelineStarted() when started != null:
return started();case TimelineFilterChanged() when filterChanged != null:
return filterChanged(_that.filter);case TimelineSearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _:
  return null;

}
}

}

/// @nodoc


class TimelineStarted implements TimelineViewEvent {
  const TimelineStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineViewEvent.started()';
}


}




/// @nodoc


class TimelineFilterChanged implements TimelineViewEvent {
  const TimelineFilterChanged(this.filter);
  

 final  TimelineFilter filter;

/// Create a copy of TimelineViewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineFilterChangedCopyWith<TimelineFilterChanged> get copyWith => _$TimelineFilterChangedCopyWithImpl<TimelineFilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineFilterChanged&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,filter);

@override
String toString() {
  return 'TimelineViewEvent.filterChanged(filter: $filter)';
}


}

/// @nodoc
abstract mixin class $TimelineFilterChangedCopyWith<$Res> implements $TimelineViewEventCopyWith<$Res> {
  factory $TimelineFilterChangedCopyWith(TimelineFilterChanged value, $Res Function(TimelineFilterChanged) _then) = _$TimelineFilterChangedCopyWithImpl;
@useResult
$Res call({
 TimelineFilter filter
});




}
/// @nodoc
class _$TimelineFilterChangedCopyWithImpl<$Res>
    implements $TimelineFilterChangedCopyWith<$Res> {
  _$TimelineFilterChangedCopyWithImpl(this._self, this._then);

  final TimelineFilterChanged _self;
  final $Res Function(TimelineFilterChanged) _then;

/// Create a copy of TimelineViewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filter = null,}) {
  return _then(TimelineFilterChanged(
null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TimelineFilter,
  ));
}


}

/// @nodoc


class TimelineSearchChanged implements TimelineViewEvent {
  const TimelineSearchChanged(this.query);
  

 final  String query;

/// Create a copy of TimelineViewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineSearchChangedCopyWith<TimelineSearchChanged> get copyWith => _$TimelineSearchChangedCopyWithImpl<TimelineSearchChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineSearchChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'TimelineViewEvent.searchChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $TimelineSearchChangedCopyWith<$Res> implements $TimelineViewEventCopyWith<$Res> {
  factory $TimelineSearchChangedCopyWith(TimelineSearchChanged value, $Res Function(TimelineSearchChanged) _then) = _$TimelineSearchChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$TimelineSearchChangedCopyWithImpl<$Res>
    implements $TimelineSearchChangedCopyWith<$Res> {
  _$TimelineSearchChangedCopyWithImpl(this._self, this._then);

  final TimelineSearchChanged _self;
  final $Res Function(TimelineSearchChanged) _then;

/// Create a copy of TimelineViewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(TimelineSearchChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TimelineState {

 TimelineStatus get status; PatientTimeline? get timeline; TimelineFilter get filter; String get query; String? get errorMessage;
/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineStateCopyWith<TimelineState> get copyWith => _$TimelineStateCopyWithImpl<TimelineState>(this as TimelineState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineState&&(identical(other.status, status) || other.status == status)&&(identical(other.timeline, timeline) || other.timeline == timeline)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.query, query) || other.query == query)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,timeline,filter,query,errorMessage);

@override
String toString() {
  return 'TimelineState(status: $status, timeline: $timeline, filter: $filter, query: $query, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TimelineStateCopyWith<$Res>  {
  factory $TimelineStateCopyWith(TimelineState value, $Res Function(TimelineState) _then) = _$TimelineStateCopyWithImpl;
@useResult
$Res call({
 TimelineStatus status, PatientTimeline? timeline, TimelineFilter filter, String query, String? errorMessage
});




}
/// @nodoc
class _$TimelineStateCopyWithImpl<$Res>
    implements $TimelineStateCopyWith<$Res> {
  _$TimelineStateCopyWithImpl(this._self, this._then);

  final TimelineState _self;
  final $Res Function(TimelineState) _then;

/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? timeline = freezed,Object? filter = null,Object? query = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimelineStatus,timeline: freezed == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as PatientTimeline?,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TimelineFilter,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineState].
extension TimelineStatePatterns on TimelineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineState value)  $default,){
final _that = this;
switch (_that) {
case _TimelineState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineState value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimelineStatus status,  PatientTimeline? timeline,  TimelineFilter filter,  String query,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
return $default(_that.status,_that.timeline,_that.filter,_that.query,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimelineStatus status,  PatientTimeline? timeline,  TimelineFilter filter,  String query,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TimelineState():
return $default(_that.status,_that.timeline,_that.filter,_that.query,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimelineStatus status,  PatientTimeline? timeline,  TimelineFilter filter,  String query,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TimelineState() when $default != null:
return $default(_that.status,_that.timeline,_that.filter,_that.query,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TimelineState extends TimelineState {
  const _TimelineState({this.status = TimelineStatus.initial, this.timeline, this.filter = TimelineFilter.all, this.query = '', this.errorMessage}): super._();
  

@override@JsonKey() final  TimelineStatus status;
@override final  PatientTimeline? timeline;
@override@JsonKey() final  TimelineFilter filter;
@override@JsonKey() final  String query;
@override final  String? errorMessage;

/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineStateCopyWith<_TimelineState> get copyWith => __$TimelineStateCopyWithImpl<_TimelineState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineState&&(identical(other.status, status) || other.status == status)&&(identical(other.timeline, timeline) || other.timeline == timeline)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.query, query) || other.query == query)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,timeline,filter,query,errorMessage);

@override
String toString() {
  return 'TimelineState(status: $status, timeline: $timeline, filter: $filter, query: $query, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TimelineStateCopyWith<$Res> implements $TimelineStateCopyWith<$Res> {
  factory _$TimelineStateCopyWith(_TimelineState value, $Res Function(_TimelineState) _then) = __$TimelineStateCopyWithImpl;
@override @useResult
$Res call({
 TimelineStatus status, PatientTimeline? timeline, TimelineFilter filter, String query, String? errorMessage
});




}
/// @nodoc
class __$TimelineStateCopyWithImpl<$Res>
    implements _$TimelineStateCopyWith<$Res> {
  __$TimelineStateCopyWithImpl(this._self, this._then);

  final _TimelineState _self;
  final $Res Function(_TimelineState) _then;

/// Create a copy of TimelineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? timeline = freezed,Object? filter = null,Object? query = null,Object? errorMessage = freezed,}) {
  return _then(_TimelineState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimelineStatus,timeline: freezed == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as PatientTimeline?,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TimelineFilter,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
