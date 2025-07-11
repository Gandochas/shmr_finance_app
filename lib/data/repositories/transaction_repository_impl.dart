import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shmr_finance_app/data/services/sync_service.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/pending_operations_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/transaction_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/drift/mappers/drift_mappers.dart';
import 'package:shmr_finance_app/domain/models/transaction/transaction.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/domain/sources/transaction_datasource.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({
    required TransactionDatasource apiSource,
    required TransactionDao transactionDao,
    required PendingOperationsDao pendingOperationsDao,
    required SyncService syncService,
  }) : _apiSource = apiSource,
       _transactionDao = transactionDao,
       _pendingOperationsDao = pendingOperationsDao,
       _syncService = syncService;

  final TransactionDatasource _apiSource;
  final TransactionDao _transactionDao;
  final PendingOperationsDao _pendingOperationsDao;
  final SyncService _syncService;

  @override
  Future<Transaction> create(TransactionRequest transactionRequest) async {
    // 1. Save locally
    final companion = TransactionsCompanion.insert(
      accountId: transactionRequest.accountId,
      categoryId: transactionRequest.categoryId,
      amount: transactionRequest.amount,
      comment: Value(transactionRequest.comment),
      transactionDate: transactionRequest.transactionDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final entity = await _transactionDao.insertAndReturn(companion);

    // 2. Add to pending operations
    await _pendingOperationsDao.insert(
      PendingOperationsCompanion.insert(
        entityType: 'transaction',
        entityId: entity.id,
        operationType: OperationType.create,
        data: jsonEncode(transactionRequest.toJson()),
        createdAt: DateTime.now(),
      ),
    );

    // 3. Try to sync
    _syncService.sync();

    // 4. Return local data
    return DriftMappers.transactionEntityToModel(entity);
  }

  @override
  Future<void> delete(int transactionId) async {
    // 1. Delete locally
    await _transactionDao.deleteTransaction(transactionId);

    // 2. Add to pending operations
    await _pendingOperationsDao.insert(
      PendingOperationsCompanion.insert(
        entityType: 'transaction',
        entityId: transactionId,
        operationType: OperationType.delete,
        data: '{}', // No data needed for delete
        createdAt: DateTime.now(),
      ),
    );

    // 3. Try to sync
    _syncService.sync();
  }

  @override
  Future<List<TransactionResponse>> getByAccountIdAndPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // 1. Try to sync pending operations first
    await _syncService.sync();

    try {
      // 2. Fetch from network and update local DB
      final remoteTransactions = await _apiSource.getByAccountIdAndPeriod(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );
      await _transactionDao.clearAndInsert(
        remoteTransactions
            .map(DriftMappers.transactionResponseToCompanion)
            .toList(),
      );
    } on Exception {
      // In case of network error, we proceed with local data
    }

    // 3. Return data from local DB
    final details = await _transactionDao.getTransactionsWithDetails(
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
    );

    return details.map(DriftMappers.transactionWithDetailsToResponse).toList();
  }

  @override
  Future<TransactionResponse> getById(int transactionId) async {
    final details = await _transactionDao.getTransactionWithDetails(
      transactionId,
    );
    if (details == null) {
      throw const TransactionNotExistException('Transaction not found');
    }
    return DriftMappers.transactionWithDetailsToResponse(details);
  }

  @override
  Future<TransactionResponse> update({
    required int transactionId,
    required TransactionRequest transactionRequest,
  }) async {
    // 1. Update locally
    final companion = TransactionsCompanion(
      accountId: Value(transactionRequest.accountId),
      categoryId: Value(transactionRequest.categoryId),
      amount: Value(transactionRequest.amount),
      comment: Value(transactionRequest.comment),
      transactionDate: Value(transactionRequest.transactionDate),
      updatedAt: Value(DateTime.now()),
    );
    await _transactionDao.updateTransaction(transactionId, companion);

    // 2. Add to pending operations
    await _pendingOperationsDao.insert(
      PendingOperationsCompanion.insert(
        entityType: 'transaction',
        entityId: transactionId,
        operationType: OperationType.update,
        data: jsonEncode(transactionRequest.toJson()),
        createdAt: DateTime.now(),
      ),
    );

    // 3. Try to sync
    _syncService.sync();

    // 4. Return local data
    final details = await _transactionDao.getTransactionWithDetails(
      transactionId,
    );
    if (details == null) {
      throw const TransactionNotExistException('Transaction not found');
    }
    return DriftMappers.transactionWithDetailsToResponse(details);
  }
}
