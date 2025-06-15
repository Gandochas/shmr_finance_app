import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/account_create_request/account_create_request.dart';
import 'package:shmr_finance_app/domain/models/account_history_response/account_history_response.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';

abstract interface class BankAccountRepository {
  Future<List<Account>> getAll();

  Future<Account> create(AccountCreateRequest createRequest);

  Future<Account> getById(int accountId);

  Future<Account> update({
    required int accountId,
    required AccountUpdateRequest updateRequest,
  });

  Future<AccountHistoryResponse> getHistory(int accountId);
}

final class BankAccountNotExistsException implements Exception {
  const BankAccountNotExistsException(this.message);

  final String message;

  @override
  String toString() {
    return 'BankAccountNotExistsException: $message';
  }
}
