// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_board_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReferralBoardEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralBoardEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReferralBoardEvent()';
}


}

/// @nodoc
class $ReferralBoardEventCopyWith<$Res>  {
$ReferralBoardEventCopyWith(ReferralBoardEvent _, $Res Function(ReferralBoardEvent) __);
}


/// Adds pattern-matching-related methods to [ReferralBoardEvent].
extension ReferralBoardEventPatterns on ReferralBoardEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReferralBoardStarted value)?  started,TResult Function( ReferralTabChanged value)?  tabChanged,TResult Function( ReferralAccepted value)?  accepted,TResult Function( ReferralDeclined value)?  declined,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReferralBoardStarted() when started != null:
return started(_that);case ReferralTabChanged() when tabChanged != null:
return tabChanged(_that);case ReferralAccepted() when accepted != null:
return accepted(_that);case ReferralDeclined() when declined != null:
return declined(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReferralBoardStarted value)  started,required TResult Function( ReferralTabChanged value)  tabChanged,required TResult Function( ReferralAccepted value)  accepted,required TResult Function( ReferralDeclined value)  declined,}){
final _that = this;
switch (_that) {
case ReferralBoardStarted():
return started(_that);case ReferralTabChanged():
return tabChanged(_that);case ReferralAccepted():
return accepted(_that);case ReferralDeclined():
return declined(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReferralBoardStarted value)?  started,TResult? Function( ReferralTabChanged value)?  tabChanged,TResult? Function( ReferralAccepted value)?  accepted,TResult? Function( ReferralDeclined value)?  declined,}){
final _that = this;
switch (_that) {
case ReferralBoardStarted() when started != null:
return started(_that);case ReferralTabChanged() when tabChanged != null:
return tabChanged(_that);case ReferralAccepted() when accepted != null:
return accepted(_that);case ReferralDeclined() when declined != null:
return declined(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( int index)?  tabChanged,TResult Function( String reference,  String? routedSpecialty)?  accepted,TResult Function( String reference)?  declined,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReferralBoardStarted() when started != null:
return started();case ReferralTabChanged() when tabChanged != null:
return tabChanged(_that.index);case ReferralAccepted() when accepted != null:
return accepted(_that.reference,_that.routedSpecialty);case ReferralDeclined() when declined != null:
return declined(_that.reference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( int index)  tabChanged,required TResult Function( String reference,  String? routedSpecialty)  accepted,required TResult Function( String reference)  declined,}) {final _that = this;
switch (_that) {
case ReferralBoardStarted():
return started();case ReferralTabChanged():
return tabChanged(_that.index);case ReferralAccepted():
return accepted(_that.reference,_that.routedSpecialty);case ReferralDeclined():
return declined(_that.reference);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( int index)?  tabChanged,TResult? Function( String reference,  String? routedSpecialty)?  accepted,TResult? Function( String reference)?  declined,}) {final _that = this;
switch (_that) {
case ReferralBoardStarted() when started != null:
return started();case ReferralTabChanged() when tabChanged != null:
return tabChanged(_that.index);case ReferralAccepted() when accepted != null:
return accepted(_that.reference,_that.routedSpecialty);case ReferralDeclined() when declined != null:
return declined(_that.reference);case _:
  return null;

}
}

}

/// @nodoc


class ReferralBoardStarted implements ReferralBoardEvent {
  const ReferralBoardStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralBoardStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReferralBoardEvent.started()';
}


}




/// @nodoc


class ReferralTabChanged implements ReferralBoardEvent {
  const ReferralTabChanged(this.index);
  

 final  int index;

/// Create a copy of ReferralBoardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralTabChangedCopyWith<ReferralTabChanged> get copyWith => _$ReferralTabChangedCopyWithImpl<ReferralTabChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralTabChanged&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'ReferralBoardEvent.tabChanged(index: $index)';
}


}

/// @nodoc
abstract mixin class $ReferralTabChangedCopyWith<$Res> implements $ReferralBoardEventCopyWith<$Res> {
  factory $ReferralTabChangedCopyWith(ReferralTabChanged value, $Res Function(ReferralTabChanged) _then) = _$ReferralTabChangedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$ReferralTabChangedCopyWithImpl<$Res>
    implements $ReferralTabChangedCopyWith<$Res> {
  _$ReferralTabChangedCopyWithImpl(this._self, this._then);

  final ReferralTabChanged _self;
  final $Res Function(ReferralTabChanged) _then;

/// Create a copy of ReferralBoardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(ReferralTabChanged(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ReferralAccepted implements ReferralBoardEvent {
  const ReferralAccepted(this.reference, {this.routedSpecialty});
  

 final  String reference;
 final  String? routedSpecialty;

/// Create a copy of ReferralBoardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralAcceptedCopyWith<ReferralAccepted> get copyWith => _$ReferralAcceptedCopyWithImpl<ReferralAccepted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralAccepted&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.routedSpecialty, routedSpecialty) || other.routedSpecialty == routedSpecialty));
}


@override
int get hashCode => Object.hash(runtimeType,reference,routedSpecialty);

@override
String toString() {
  return 'ReferralBoardEvent.accepted(reference: $reference, routedSpecialty: $routedSpecialty)';
}


}

/// @nodoc
abstract mixin class $ReferralAcceptedCopyWith<$Res> implements $ReferralBoardEventCopyWith<$Res> {
  factory $ReferralAcceptedCopyWith(ReferralAccepted value, $Res Function(ReferralAccepted) _then) = _$ReferralAcceptedCopyWithImpl;
@useResult
$Res call({
 String reference, String? routedSpecialty
});




}
/// @nodoc
class _$ReferralAcceptedCopyWithImpl<$Res>
    implements $ReferralAcceptedCopyWith<$Res> {
  _$ReferralAcceptedCopyWithImpl(this._self, this._then);

  final ReferralAccepted _self;
  final $Res Function(ReferralAccepted) _then;

/// Create a copy of ReferralBoardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reference = null,Object? routedSpecialty = freezed,}) {
  return _then(ReferralAccepted(
null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,routedSpecialty: freezed == routedSpecialty ? _self.routedSpecialty : routedSpecialty // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ReferralDeclined implements ReferralBoardEvent {
  const ReferralDeclined(this.reference);
  

 final  String reference;

/// Create a copy of ReferralBoardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralDeclinedCopyWith<ReferralDeclined> get copyWith => _$ReferralDeclinedCopyWithImpl<ReferralDeclined>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralDeclined&&(identical(other.reference, reference) || other.reference == reference));
}


@override
int get hashCode => Object.hash(runtimeType,reference);

@override
String toString() {
  return 'ReferralBoardEvent.declined(reference: $reference)';
}


}

/// @nodoc
abstract mixin class $ReferralDeclinedCopyWith<$Res> implements $ReferralBoardEventCopyWith<$Res> {
  factory $ReferralDeclinedCopyWith(ReferralDeclined value, $Res Function(ReferralDeclined) _then) = _$ReferralDeclinedCopyWithImpl;
@useResult
$Res call({
 String reference
});




}
/// @nodoc
class _$ReferralDeclinedCopyWithImpl<$Res>
    implements $ReferralDeclinedCopyWith<$Res> {
  _$ReferralDeclinedCopyWithImpl(this._self, this._then);

  final ReferralDeclined _self;
  final $Res Function(ReferralDeclined) _then;

/// Create a copy of ReferralBoardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reference = null,}) {
  return _then(ReferralDeclined(
null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ReferralBoardState {

 ReferralBoardStatus get status; ReferralBoard? get board; int get selectedTab;/// The reference currently being accepted/declined, so its card can show
/// a spinner without freezing the rest of the list.
 String? get actioningReference; String? get errorMessage;
/// Create a copy of ReferralBoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralBoardStateCopyWith<ReferralBoardState> get copyWith => _$ReferralBoardStateCopyWithImpl<ReferralBoardState>(this as ReferralBoardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralBoardState&&(identical(other.status, status) || other.status == status)&&(identical(other.board, board) || other.board == board)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.actioningReference, actioningReference) || other.actioningReference == actioningReference)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,board,selectedTab,actioningReference,errorMessage);

@override
String toString() {
  return 'ReferralBoardState(status: $status, board: $board, selectedTab: $selectedTab, actioningReference: $actioningReference, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ReferralBoardStateCopyWith<$Res>  {
  factory $ReferralBoardStateCopyWith(ReferralBoardState value, $Res Function(ReferralBoardState) _then) = _$ReferralBoardStateCopyWithImpl;
@useResult
$Res call({
 ReferralBoardStatus status, ReferralBoard? board, int selectedTab, String? actioningReference, String? errorMessage
});




}
/// @nodoc
class _$ReferralBoardStateCopyWithImpl<$Res>
    implements $ReferralBoardStateCopyWith<$Res> {
  _$ReferralBoardStateCopyWithImpl(this._self, this._then);

  final ReferralBoardState _self;
  final $Res Function(ReferralBoardState) _then;

/// Create a copy of ReferralBoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? board = freezed,Object? selectedTab = null,Object? actioningReference = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReferralBoardStatus,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as ReferralBoard?,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,actioningReference: freezed == actioningReference ? _self.actioningReference : actioningReference // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralBoardState].
extension ReferralBoardStatePatterns on ReferralBoardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralBoardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralBoardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralBoardState value)  $default,){
final _that = this;
switch (_that) {
case _ReferralBoardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralBoardState value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralBoardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReferralBoardStatus status,  ReferralBoard? board,  int selectedTab,  String? actioningReference,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralBoardState() when $default != null:
return $default(_that.status,_that.board,_that.selectedTab,_that.actioningReference,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReferralBoardStatus status,  ReferralBoard? board,  int selectedTab,  String? actioningReference,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ReferralBoardState():
return $default(_that.status,_that.board,_that.selectedTab,_that.actioningReference,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReferralBoardStatus status,  ReferralBoard? board,  int selectedTab,  String? actioningReference,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ReferralBoardState() when $default != null:
return $default(_that.status,_that.board,_that.selectedTab,_that.actioningReference,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ReferralBoardState extends ReferralBoardState {
  const _ReferralBoardState({this.status = ReferralBoardStatus.initial, this.board, this.selectedTab = 0, this.actioningReference, this.errorMessage}): super._();
  

@override@JsonKey() final  ReferralBoardStatus status;
@override final  ReferralBoard? board;
@override@JsonKey() final  int selectedTab;
/// The reference currently being accepted/declined, so its card can show
/// a spinner without freezing the rest of the list.
@override final  String? actioningReference;
@override final  String? errorMessage;

/// Create a copy of ReferralBoardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralBoardStateCopyWith<_ReferralBoardState> get copyWith => __$ReferralBoardStateCopyWithImpl<_ReferralBoardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralBoardState&&(identical(other.status, status) || other.status == status)&&(identical(other.board, board) || other.board == board)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.actioningReference, actioningReference) || other.actioningReference == actioningReference)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,board,selectedTab,actioningReference,errorMessage);

@override
String toString() {
  return 'ReferralBoardState(status: $status, board: $board, selectedTab: $selectedTab, actioningReference: $actioningReference, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ReferralBoardStateCopyWith<$Res> implements $ReferralBoardStateCopyWith<$Res> {
  factory _$ReferralBoardStateCopyWith(_ReferralBoardState value, $Res Function(_ReferralBoardState) _then) = __$ReferralBoardStateCopyWithImpl;
@override @useResult
$Res call({
 ReferralBoardStatus status, ReferralBoard? board, int selectedTab, String? actioningReference, String? errorMessage
});




}
/// @nodoc
class __$ReferralBoardStateCopyWithImpl<$Res>
    implements _$ReferralBoardStateCopyWith<$Res> {
  __$ReferralBoardStateCopyWithImpl(this._self, this._then);

  final _ReferralBoardState _self;
  final $Res Function(_ReferralBoardState) _then;

/// Create a copy of ReferralBoardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? board = freezed,Object? selectedTab = null,Object? actioningReference = freezed,Object? errorMessage = freezed,}) {
  return _then(_ReferralBoardState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReferralBoardStatus,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as ReferralBoard?,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,actioningReference: freezed == actioningReference ? _self.actioningReference : actioningReference // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
