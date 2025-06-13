// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountHistory {

 int get id; int get accountId; AccountHistoryChangeType get changeType; AccountState get newState; DateTime get changeTimeStamp; DateTime get createdAt; AccountState? get previousState;
/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountHistoryCopyWith<AccountHistory> get copyWith => _$AccountHistoryCopyWithImpl<AccountHistory>(this as AccountHistory, _$identity);

  /// Serializes this AccountHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.newState, newState) || other.newState == newState)&&(identical(other.changeTimeStamp, changeTimeStamp) || other.changeTimeStamp == changeTimeStamp)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.previousState, previousState) || other.previousState == previousState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,changeType,newState,changeTimeStamp,createdAt,previousState);

@override
String toString() {
  return 'AccountHistory(id: $id, accountId: $accountId, changeType: $changeType, newState: $newState, changeTimeStamp: $changeTimeStamp, createdAt: $createdAt, previousState: $previousState)';
}


}

/// @nodoc
abstract mixin class $AccountHistoryCopyWith<$Res>  {
  factory $AccountHistoryCopyWith(AccountHistory value, $Res Function(AccountHistory) _then) = _$AccountHistoryCopyWithImpl;
@useResult
$Res call({
 int id, int accountId, AccountHistoryChangeType changeType, AccountState newState, DateTime changeTimeStamp, DateTime createdAt, AccountState? previousState
});


$AccountStateCopyWith<$Res> get newState;$AccountStateCopyWith<$Res>? get previousState;

}
/// @nodoc
class _$AccountHistoryCopyWithImpl<$Res>
    implements $AccountHistoryCopyWith<$Res> {
  _$AccountHistoryCopyWithImpl(this._self, this._then);

  final AccountHistory _self;
  final $Res Function(AccountHistory) _then;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? changeType = null,Object? newState = null,Object? changeTimeStamp = null,Object? createdAt = null,Object? previousState = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as AccountHistoryChangeType,newState: null == newState ? _self.newState : newState // ignore: cast_nullable_to_non_nullable
as AccountState,changeTimeStamp: null == changeTimeStamp ? _self.changeTimeStamp : changeTimeStamp // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,previousState: freezed == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as AccountState?,
  ));
}
/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountStateCopyWith<$Res> get newState {
  
  return $AccountStateCopyWith<$Res>(_self.newState, (value) {
    return _then(_self.copyWith(newState: value));
  });
}/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountStateCopyWith<$Res>? get previousState {
    if (_self.previousState == null) {
    return null;
  }

  return $AccountStateCopyWith<$Res>(_self.previousState!, (value) {
    return _then(_self.copyWith(previousState: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AccountHistory implements AccountHistory {
  const _AccountHistory({required this.id, required this.accountId, required this.changeType, required this.newState, required this.changeTimeStamp, required this.createdAt, this.previousState});
  factory _AccountHistory.fromJson(Map<String, dynamic> json) => _$AccountHistoryFromJson(json);

@override final  int id;
@override final  int accountId;
@override final  AccountHistoryChangeType changeType;
@override final  AccountState newState;
@override final  DateTime changeTimeStamp;
@override final  DateTime createdAt;
@override final  AccountState? previousState;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountHistoryCopyWith<_AccountHistory> get copyWith => __$AccountHistoryCopyWithImpl<_AccountHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.newState, newState) || other.newState == newState)&&(identical(other.changeTimeStamp, changeTimeStamp) || other.changeTimeStamp == changeTimeStamp)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.previousState, previousState) || other.previousState == previousState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,changeType,newState,changeTimeStamp,createdAt,previousState);

@override
String toString() {
  return 'AccountHistory(id: $id, accountId: $accountId, changeType: $changeType, newState: $newState, changeTimeStamp: $changeTimeStamp, createdAt: $createdAt, previousState: $previousState)';
}


}

/// @nodoc
abstract mixin class _$AccountHistoryCopyWith<$Res> implements $AccountHistoryCopyWith<$Res> {
  factory _$AccountHistoryCopyWith(_AccountHistory value, $Res Function(_AccountHistory) _then) = __$AccountHistoryCopyWithImpl;
@override @useResult
$Res call({
 int id, int accountId, AccountHistoryChangeType changeType, AccountState newState, DateTime changeTimeStamp, DateTime createdAt, AccountState? previousState
});


@override $AccountStateCopyWith<$Res> get newState;@override $AccountStateCopyWith<$Res>? get previousState;

}
/// @nodoc
class __$AccountHistoryCopyWithImpl<$Res>
    implements _$AccountHistoryCopyWith<$Res> {
  __$AccountHistoryCopyWithImpl(this._self, this._then);

  final _AccountHistory _self;
  final $Res Function(_AccountHistory) _then;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? changeType = null,Object? newState = null,Object? changeTimeStamp = null,Object? createdAt = null,Object? previousState = freezed,}) {
  return _then(_AccountHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as AccountHistoryChangeType,newState: null == newState ? _self.newState : newState // ignore: cast_nullable_to_non_nullable
as AccountState,changeTimeStamp: null == changeTimeStamp ? _self.changeTimeStamp : changeTimeStamp // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,previousState: freezed == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as AccountState?,
  ));
}

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountStateCopyWith<$Res> get newState {
  
  return $AccountStateCopyWith<$Res>(_self.newState, (value) {
    return _then(_self.copyWith(newState: value));
  });
}/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountStateCopyWith<$Res>? get previousState {
    if (_self.previousState == null) {
    return null;
  }

  return $AccountStateCopyWith<$Res>(_self.previousState!, (value) {
    return _then(_self.copyWith(previousState: value));
  });
}
}

// dart format on
