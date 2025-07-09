import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shmr_finance_app/core/network/connection_checker.dart';
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
  }) : _apiSource = apiSource,
       _transactionDao = transactionDao;

  final TransactionDatasource _apiSource;
  final TransactionDao _transactionDao;
  final ConnectionChecker _connectionChecker = ConnectionChecker();

  @override
  Future<Transaction> create(TransactionRequest transactionRequest) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final transaction = await _apiSource.create(transactionRequest);
        await _syncTransactionToLocal(transaction);
        return transaction;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final companion = TransactionsCompanion.insert(
      accountId: transactionRequest.accountId,
      categoryId: transactionRequest.categoryId,
      amount: transactionRequest.amount,
      comment: Value(transactionRequest.comment),
      transactionDate: transactionRequest.transactionDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDirty: const Value(true),
    );

    final id = await _transactionDao.insertTransaction(companion);
    final entity = await _transactionDao.getTransactionById(id);
    return DriftMappers.transactionEntityToModel(entity!);
  }

  @override
  Future<void> delete(int transactionId) async {
    try {
      if (await _connectionChecker.isConnected()) {
        await _apiSource.delete(transactionId);
        await _transactionDao.deleteTransaction(transactionId);
        return;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    await _transactionDao.deleteTransaction(transactionId);
  }

  @override
  Future<List<TransactionResponse>> getByAccountIdAndPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final responses = await _apiSource.getByAccountIdAndPeriod(
          accountId: accountId,
          startDate: startDate,
          endDate: endDate,
        );
        return responses;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final details = await _transactionDao.getTransactionsWithDetails(
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
    );

    return details.map(DriftMappers.transactionWithDetailsToResponse).toList();
  }

  @override
  Future<TransactionResponse> getById(int transactionId) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final response = await _apiSource.getById(transactionId);
        return response;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final details = await _transactionDao.getTransactionsWithDetails(
      accountId: 1,
    );

    final detail = details.firstWhere(
      (d) => d.transaction.id == transactionId,
      orElse: () =>
          throw const TransactionNotExistException('Transaction not found'),
    );

    return DriftMappers.transactionWithDetailsToResponse(detail);
  }

  @override
  Future<TransactionResponse> update({
    required int transactionId,
    required TransactionRequest transactionRequest,
  }) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final response = await _apiSource.update(
          transactionId: transactionId,
          transactionRequest: transactionRequest,
        );
        return response;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final companion = TransactionsCompanion(
      accountId: Value(transactionRequest.accountId),
      categoryId: Value(transactionRequest.categoryId),
      amount: Value(transactionRequest.amount),
      comment: Value(transactionRequest.comment),
      transactionDate: Value(transactionRequest.transactionDate),
      updatedAt: Value(DateTime.now()),
      isDirty: const Value(true),
    );

    await _transactionDao.updateTransaction(transactionId, companion);

    final details = await _transactionDao.getTransactionsWithDetails(
      accountId: 1,
    );

    final detail = details.firstWhere(
      (d) => d.transaction.id == transactionId,
      orElse: () =>
          throw const TransactionNotExistException('Transaction not found'),
    );

    return DriftMappers.transactionWithDetailsToResponse(detail);
  }

  Future<void> _syncTransactionToLocal(Transaction transaction) async {
    final existing = await _transactionDao.getTransactionById(transaction.id);

    if (existing == null) {
      // Insert new transaction
      final companion = TransactionsCompanion.insert(
        id: Value(transaction.id),
        accountId: transaction.accountId,
        categoryId: transaction.categoryId,
        amount: transaction.amount,
        comment: Value(transaction.comment),
        transactionDate: transaction.transactionDate,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
        lastSyncDate: Value(DateTime.now()),
        isDirty: const Value(false),
      );
      await _transactionDao.insertTransaction(companion);
    } else {
      // Update existing transaction
      final companion = TransactionsCompanion(
        accountId: Value(transaction.accountId),
        categoryId: Value(transaction.categoryId),
        amount: Value(transaction.amount),
        comment: Value(transaction.comment),
        transactionDate: Value(transaction.transactionDate),
        createdAt: Value(transaction.createdAt),
        updatedAt: Value(transaction.updatedAt),
        lastSyncDate: Value(DateTime.now()),
        isDirty: const Value(false),
      );
      await _transactionDao.updateTransaction(transaction.id, companion);
    }
  }
}
