import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/account_create_request/account_create_request.dart';
import 'package:shmr_finance_app/domain/models/account_history/account_history.dart';
import 'package:shmr_finance_app/domain/models/account_history_response/account_history_response.dart';
import 'package:shmr_finance_app/domain/models/account_response/account_response.dart';
import 'package:shmr_finance_app/domain/models/account_state/account_state.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/sources/bank_account_datasource.dart';

final class BankAccountMockDatasourceImpl implements BankAccountDatasource {
  final _accounts = <Account>[
    Account(
      id: 1,
      userId: 1,
      name: 'my bank acc',
      balance: '1000',
      currency: '₽',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
  ];
  final _accountHistories = <AccountHistory>[
    AccountHistory(
      id: 1,
      accountId: 1,
      changeType: AccountHistoryChangeType.creation,
      newState: const AccountState(
        id: 1,
        name: 'my bank acc',
        balance: '1000',
        currency: '₽',
      ),
      changeTimeStamp: DateTime.now().subtract(const Duration(days: 30)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<Account> create(AccountCreateRequest createRequest) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final newAccount = Account(
      id: _accounts.length + 1,
      userId: 1,
      name: createRequest.name,
      balance: createRequest.balance,
      currency: createRequest.currency,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final newAccountHistory = AccountHistory(
      id: _accountHistories.length + 1,
      accountId: newAccount.id,
      changeType: AccountHistoryChangeType.creation,
      newState: AccountState(
        id: newAccount.id,
        name: newAccount.name,
        balance: newAccount.balance,
        currency: newAccount.currency,
      ),
      changeTimeStamp: DateTime.now(),
      createdAt: DateTime.now(),
    );
    _accounts.add(newAccount);
    _accountHistories.add(newAccountHistory);
    return newAccount;
  }

  @override
  Future<List<Account>> getAll() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return [..._accounts];
  }

  @override
  Future<AccountResponse> getById(int accountId) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final account = _accounts.firstWhere(
      (account) => account.id == accountId,
      orElse: () => throw const BankAccountNotExistsException(
        'Такого аккаунта не существует!',
      ),
    );

    return AccountResponse(
      id: account.id,
      name: account.name,
      balance: account.balance,
      currency: account.currency,
      incomeStats: [],
      expenseStats: [],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<AccountHistoryResponse> getHistory(int accountId) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final account = _accounts.lastWhere(
      (account) => account.id == accountId,
      orElse: () => throw const BankAccountNotExistsException(
        'Такого аккаунта не существует!',
      ),
    );

    return AccountHistoryResponse(
      accountId: accountId,
      accountName: account.name,
      currency: account.currency,
      currentBalance: account.balance,
      history: _accountHistories
          .where((history) => history.accountId == accountId)
          .toList(),
    );
  }

  @override
  Future<Account> update({
    required int accountId,
    required AccountUpdateRequest updateRequest,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final accountIndex = _accounts.lastIndexWhere(
      (account) => account.id == accountId,
    );
    if (accountIndex == -1) {
      throw const BankAccountNotExistsException(
        'Такого аккаунта не существует!',
      );
    }
    final account = _accounts[accountIndex];
    final accountLastHistory = _accountHistories.lastWhere(
      (account) => account.id == accountId,
    );
    final updatedAccount = Account(
      id: account.id,
      userId: account.userId,
      name: updateRequest.name,
      balance: updateRequest.balance,
      currency: updateRequest.currency,
      createdAt: account.createdAt,
      updatedAt: DateTime.now(),
    );
    final updatedAccountHistory = AccountHistory(
      id: _accountHistories.length + 1,
      accountId: accountId,
      changeType: AccountHistoryChangeType.modification,
      newState: AccountState(
        id: account.id,
        name: updatedAccount.name,
        balance: account.balance,
        currency: account.currency,
      ),
      previousState: accountLastHistory.newState,
      changeTimeStamp: DateTime.now(),
      createdAt: accountLastHistory.createdAt,
    );
    _accounts[accountIndex] = updatedAccount;
    _accountHistories.add(updatedAccountHistory);
    return updatedAccount;
  }
}
