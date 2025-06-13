import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr_finance_app/domain/models/account_state/account_state.dart';

part 'account_history.freezed.dart';
part 'account_history.g.dart';

@freezed
abstract class AccountHistory with _$AccountHistory {
  const factory AccountHistory({
    required int id,
    required int accountId,
    required AccountHistoryChangeType changeType,
    required AccountState newState,
    required DateTime changeTimeStamp,
    required DateTime createdAt,
    AccountState? previousState,
  }) = _AccountHistory;

  factory AccountHistory.fromJson(Map<String, Object?> json) => _$AccountHistoryFromJson(json);
}

enum AccountHistoryChangeType {
  creation('CREATION'),
  modification('MODIFICATION');

  const AccountHistoryChangeType(this.name);

  final String name;
}
