import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance_app/core/network/network_client.dart';
import 'package:shmr_finance_app/domain/models/transaction/transaction.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/sources/transaction_datasource.dart';

final class TransactionNetworkDatasourceImpl implements TransactionDatasource {
  TransactionNetworkDatasourceImpl();

  final NetworkClient _networkClient = NetworkClient();

  @override
  Future<Transaction> create(TransactionRequest transactionRequest) async {
    try {
      final response = await _networkClient.post<Map<String, Object?>>(
        '/transactions',
        data: {
          'accountId': transactionRequest.accountId,
          'categoryId': transactionRequest.categoryId,
          'amount': transactionRequest.amount,
          'transactionDate': transactionRequest.transactionDate
              .toUtc()
              .toIso8601String(),
          'comment': transactionRequest.comment,
        },
      );

      return Transaction.fromJson(response.data ?? {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Resource not found: ${e.response?.data}');
      } else {
        throw Exception('Failed to create transaction: $e');
      }
    }
  }

  @override
  Future<void> delete(int transactionId) async {
    try {
      await _networkClient.delete<void>('/transactions/$transactionId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Resource not found: ${e.response?.data}');
      } else {
        throw Exception('Failed to delete transaction: $e');
      }
    }
  }

  @override
  Future<List<TransactionResponse>> getByAccountIdAndPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final response = await _networkClient.get<List<dynamic>>(
        '/transactions/account/$accountId/period',
        params: {
          'startDate': ?(startDate != null
              ? dateFormat.format(startDate.toUtc())
              : null),
          'endDate': ?(endDate != null
              ? dateFormat.format(endDate.toUtc())
              : null),
        },
      );

      final data = response.data ?? [];

      return data
          .map(
            (transactionData) => TransactionResponse.fromJson(
              transactionData as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else {
        throw Exception('Failed to fetch transactions: $e');
      }
    }
  }

  @override
  Future<TransactionResponse> getById(int transactionId) async {
    try {
      final response = await _networkClient.get<Map<String, Object?>>(
        '/transactions/$transactionId',
      );

      return TransactionResponse.fromJson(response.data ?? {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Resource not found: ${e.response?.data}');
      } else {
        throw Exception('Failed to fetch transaction by id: $e');
      }
    }
  }

  @override
  Future<TransactionResponse> update({
    required int transactionId,
    required TransactionRequest transactionRequest,
  }) async {
    try {
      final response = await _networkClient.put<Map<String, Object?>>(
        '/transactions/$transactionId',
        data: {
          'accountId': transactionRequest.accountId,
          'categoryId': transactionRequest.categoryId,
          'amount': transactionRequest.amount,
          'transactionDate': transactionRequest.transactionDate
              .toUtc()
              .toIso8601String(),
          'comment': transactionRequest.comment,
        },
      );

      return TransactionResponse.fromJson(response.data ?? {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Resource not found: ${e.response?.data}');
      } else {
        throw Exception('Failed to update transaction: $e');
      }
    }
  }
}
