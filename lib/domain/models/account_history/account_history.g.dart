// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountHistory _$AccountHistoryFromJson(Map<String, dynamic> json) =>
    _AccountHistory(
      id: (json['id'] as num).toInt(),
      accountId: (json['accountId'] as num).toInt(),
      changeType: $enumDecode(
        _$AccountHistoryChangeTypeEnumMap,
        json['changeType'],
      ),
      newState: AccountState.fromJson(json['newState'] as Map<String, dynamic>),
      changeTimeStamp: DateTime.parse(json['changeTimeStamp'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      previousState:
          json['previousState'] == null
              ? null
              : AccountState.fromJson(
                json['previousState'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$AccountHistoryToJson(_AccountHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'changeType': _$AccountHistoryChangeTypeEnumMap[instance.changeType]!,
      'newState': instance.newState,
      'changeTimeStamp': instance.changeTimeStamp.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'previousState': instance.previousState,
    };

const _$AccountHistoryChangeTypeEnumMap = {
  AccountHistoryChangeType.creation: 'creation',
  AccountHistoryChangeType.modification: 'modification',
};
