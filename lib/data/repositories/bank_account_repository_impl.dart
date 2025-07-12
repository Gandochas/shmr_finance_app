import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shmr_finance_app/data/services/sync_service.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/account_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/pending_operations_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/drift/mappers/drift_mappers.dart';
import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/account_create_request/account_create_request.dart';
import 'package:shmr_finance_app/domain/models/account_history_response/account_history_response.dart';
import 'package:shmr_finance_app/domain/models/account_response/account_response.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/sources/bank_account_datasource.dart';

final class BankAccountRepositoryImpl implements BankAccountRepository {
  BankAccountRepositoryImpl({
    required this.apiSource,
    required this.accountDao,
    required this.pendingOperationsDao,
    required this.syncService,
  });

  final BankAccountDatasource apiSource;
  final AccountDao accountDao;
  final PendingOperationsDao pendingOperationsDao;
  final SyncService syncService;

  @override
  Future<Account> create(AccountCreateRequest createRequest) async {
    // Creating accounts offline is not supported in this logic,
    // as we usually need an immediate ID from the server.
    // We will perform a direct API call.
    final account = await apiSource.create(createRequest);
    await _syncAccountToLocal(account);
    return account;
  }

  @override
  Future<List<Account>> getAll() async {
    await syncService.sync();
    try {
      final accounts = await apiSource.getAll();
      await _syncAccountsToLocal(accounts);
    } on Exception {
      // In case of network error, we proceed with local data
    }
    final entities = await accountDao.getAllAccounts();
    return entities.map(DriftMappers.accountEntityToModel).toList();
  }

  @override
  Future<AccountResponse> getById(int accountId) async {
    await syncService.sync();
    try {
      final accountResponse = await apiSource.getById(accountId);
      final account = Account(
        id: accountResponse.id,
        userId: accountResponse.id,
        name: accountResponse.name,
        balance: accountResponse.balance,
        currency: accountResponse.currency,
        createdAt: accountResponse.createdAt,
        updatedAt: accountResponse.updatedAt,
      );
      await _syncAccountToLocal(account);
    } on Exception {
      // In case of network error, we proceed with local data
    }

    final entity = await accountDao.getAccountById(accountId);
    if (entity == null) {
      throw Exception('Account not found');
    }
    return DriftMappers.accountEntityToResponse(entity);
  }

  @override
  Future<AccountHistoryResponse> getHistory(int accountId) {
    // This should also be synced, but for now, we pass it through.
    return apiSource.getHistory(accountId);
  }

  @override
  Future<Account> update({
    required int accountId,
    required AccountUpdateRequest updateRequest,
  }) async {
    // 1. Update locally
    final companion = AccountsCompanion(
      name: Value(updateRequest.name),
      balance: Value(updateRequest.balance),
      currency: Value(updateRequest.currency),
      updatedAt: Value(DateTime.now()),
    );
    await accountDao.updateAccount(accountId, companion);
    final entity = await accountDao.getAccountById(accountId);

    // 2. Add to pending operations
    await pendingOperationsDao.insert(
      PendingOperationsCompanion.insert(
        entityType: 'account',
        entityId: accountId,
        operationType: OperationType.update,
        data: jsonEncode(updateRequest.toJson()),
        createdAt: DateTime.now(),
      ),
    );

    // 3. Try to sync
    syncService.sync();

    // 4. Return local data
    return DriftMappers.accountEntityToModel(entity!);
  }

  Future<void> _syncAccountsToLocal(List<Account> accounts) async {
    for (final account in accounts) {
      await _syncAccountToLocal(account);
    }
  }

  Future<void> _syncAccountToLocal(Account account) async {
    final companion = AccountsCompanion(
      id: Value(account.id),
      userId: Value(account.userId),
      name: Value(account.name),
      balance: Value(account.balance),
      currency: Value(account.currency),
      createdAt: Value(account.createdAt),
      updatedAt: Value(account.updatedAt),
    );
    await accountDao.insertOrUpdate(companion);
  }
}
