import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shmr_finance_app/core/connection_checker.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/account_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/drift/mappers/drift_mappers.dart';
import 'package:shmr_finance_app/data/sources/mock/bank_account_mock_datasource_impl.dart';
import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/account_create_request/account_create_request.dart';
import 'package:shmr_finance_app/domain/models/account_history_response/account_history_response.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';

final class BankAccountRepositoryImpl implements BankAccountRepository {
  BankAccountRepositoryImpl({
    required BankAccountMockDatasourceImpl apiSource,
    required AccountDao accountDao,
  }) : _apiSource = apiSource,
       _accountDao = accountDao;

  final BankAccountMockDatasourceImpl _apiSource;
  final AccountDao _accountDao;
  final ConnectionChecker _connectionChecker = ConnectionChecker();

  @override
  Future<Account> create(AccountCreateRequest createRequest) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final account = await _apiSource.create(createRequest);
        await _syncAccountToLocal(account);
        return account;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final companion = AccountsCompanion.insert(
      userId: 1,
      name: createRequest.name,
      balance: createRequest.balance,
      currency: createRequest.currency,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDirty: const Value(true),
    );

    final id = await _accountDao.insertAccount(companion);
    final entity = await _accountDao.getAccountById(id);
    return DriftMappers.accountEntityToModel(entity!);
  }

  @override
  Future<List<Account>> getAll() async {
    try {
      if (await _connectionChecker.isConnected()) {
        final accounts = await _apiSource.getAll();
        await _syncAccountsToLocal(accounts);
        return accounts;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final entities = await _accountDao.getAllAccounts();
    return entities.map(DriftMappers.accountEntityToModel).toList();
  }

  @override
  Future<Account> getById(int accountId) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final account = await _apiSource.getById(accountId);
        await _syncAccountToLocal(account);
        return account;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final entity = await _accountDao.getAccountById(accountId);
    if (entity == null) {
      throw Exception('Account not found');
    }
    return DriftMappers.accountEntityToModel(entity);
  }

  @override
  Future<AccountHistoryResponse> getHistory(int accountId) async {
    // По хорошему наверное надо создать отдельную таблицу под AccountHistory
    // Но пока что, решил не усложнять получение истории

    return _apiSource.getHistory(accountId);
  }

  @override
  Future<Account> update({
    required int accountId,
    required AccountUpdateRequest updateRequest,
  }) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final account = await _apiSource.update(
          accountId: accountId,
          updateRequest: updateRequest,
        );
        await _syncAccountToLocal(account);
        return account;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final companion = AccountsCompanion(
      name: Value(updateRequest.name),
      balance: Value(updateRequest.balance),
      currency: Value(updateRequest.currency),
      updatedAt: Value(DateTime.now()),
      isDirty: const Value(true),
    );

    await _accountDao.updateAccount(accountId, companion);
    final entity = await _accountDao.getAccountById(accountId);
    return DriftMappers.accountEntityToModel(entity!);
  }

  Future<void> _syncAccountsToLocal(List<Account> accounts) async {
    for (final account in accounts) {
      await _syncAccountToLocal(account);
    }
  }

  Future<void> _syncAccountToLocal(Account account) async {
    final existing = await _accountDao.getAccountById(account.id);

    if (existing == null) {
      // Insert new account
      final companion = AccountsCompanion.insert(
        id: Value(account.id),
        userId: account.userId,
        name: account.name,
        balance: account.balance,
        currency: account.currency,
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
        lastSyncDate: Value(DateTime.now()),
        isDirty: const Value(false),
      );
      await _accountDao.insertAccount(companion);
    } else {
      // Update existing account
      final companion = AccountsCompanion(
        userId: Value(account.userId),
        name: Value(account.name),
        balance: Value(account.balance),
        currency: Value(account.currency),
        createdAt: Value(account.createdAt),
        updatedAt: Value(account.updatedAt),
        lastSyncDate: Value(DateTime.now()),
        isDirty: const Value(false),
      );
      await _accountDao.updateAccount(account.id, companion);
    }
  }
}
