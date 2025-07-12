import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/account_create_request/account_create_request.dart';
import 'package:shmr_finance_app/domain/models/account_history_response/account_history_response.dart';
import 'package:shmr_finance_app/domain/models/account_response/account_response.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';

abstract interface class BankAccountDatasource {
  Future<Account> create(AccountCreateRequest createRequest);

  Future<List<Account>> getAll();

  Future<AccountResponse> getById(int accountId);

  Future<AccountHistoryResponse> getHistory(int accountId);

  Future<Account> update({
    required int accountId,
    required AccountUpdateRequest updateRequest,
  });
}
