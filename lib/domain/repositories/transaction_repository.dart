import 'package:shmr_finance_app/domain/models/transaction/transaction.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

abstract interface class TransactionRepository {
  Future<Transaction> create(TransactionRequest transactionRequest);

  Future<TransactionResponse> getById(int transactionId);

  Future<TransactionResponse> update({
    required int transactionId,
    required TransactionRequest transactionRequest,
  });

  Future<void> delete(int transactionId);

  Future<List<TransactionResponse>> getByAccountIdAndPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

final class TransactionNotExistException implements Exception {
  const TransactionNotExistException(this.message);

  final String message;

  @override
  String toString() {
    return 'TransactionNotExistException: $message';
  }
}
