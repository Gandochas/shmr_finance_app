import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shmr_finance_app/core/network/connection_checker.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/account_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/pending_operations_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/transaction_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/sources/bank_account_datasource.dart';
import 'package:shmr_finance_app/domain/sources/transaction_datasource.dart';

class SyncService {
  SyncService({
    required this.transactionApiSource,
    required this.bankAccountApiSource,
    required this.transactionDao,
    required this.accountDao,
    required this.pendingOperationsDao,
  });

  final TransactionDatasource transactionApiSource;
  final BankAccountDatasource bankAccountApiSource;
  final TransactionDao transactionDao;
  final AccountDao accountDao;
  final PendingOperationsDao pendingOperationsDao;
  final ConnectionChecker _connectionChecker = ConnectionChecker();
  bool _isSyncing = false;

  Future<void> sync() async {
    if (_isSyncing || !await _connectionChecker.isConnected()) {
      return;
    }
    _isSyncing = true;

    try {
      final pending = await pendingOperationsDao.getAll();
      for (final operation in pending) {
        await _processOperation(operation);
        await pendingOperationsDao.deleteOperation(operation.id);
      }
    } on Exception catch (e) {
      debugPrint('Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processOperation(PendingOperationEntity operation) async {
    switch (operation.entityType) {
      case 'transaction':
        await _syncTransaction(operation);
      case 'account':
        await _syncAccount(operation);
    }
  }

  Future<void> _syncAccount(PendingOperationEntity operation) async {
    final data = jsonDecode(operation.data) as Map<String, dynamic>;
    // For accounts, we only support update
    switch (operation.operationType) {
      case OperationType.update:
        final request = AccountUpdateRequest.fromJson(data);
        await bankAccountApiSource.update(
          accountId: operation.entityId,
          updateRequest: request,
        );
      case OperationType.create:
      case OperationType.delete:
        // Not supported for accounts in this logic
        break;
    }
  }

  Future<void> _syncTransaction(PendingOperationEntity operation) async {
    final data = jsonDecode(operation.data) as Map<String, dynamic>;
    switch (operation.operationType) {
      case OperationType.create:
        final request = TransactionRequest.fromJson(data);
        await transactionApiSource.create(request);
      case OperationType.update:
        final request = TransactionRequest.fromJson(data);
        await transactionApiSource.update(
          transactionId: operation.entityId,
          transactionRequest: request,
        );
      case OperationType.delete:
        await transactionApiSource.delete(operation.entityId);
    }
  }
}
