import 'package:dio/dio.dart';
import 'package:shmr_finance_app/core/network/network_client.dart';
import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/account_create_request/account_create_request.dart';
import 'package:shmr_finance_app/domain/models/account_history_response/account_history_response.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';
import 'package:shmr_finance_app/domain/sources/bank_account_datasource.dart';

final class BankAccountNetworkDatasourceImpl implements BankAccountDatasource {
  BankAccountNetworkDatasourceImpl();

  final NetworkClient _networkClient = NetworkClient();

  @override
  Future<Account> create(AccountCreateRequest createRequest) async {
    try {
      final response = await _networkClient.post<Map<String, Object?>>(
        '/accounts',
        data: {
          'name': createRequest.name,
          'balance': createRequest.balance,
          'currency': createRequest.currency,
        },
      );

      return Account.fromJson(response.data ?? {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else {
        throw Exception('Failed to create account: $e');
      }
    }
  }

  @override
  Future<List<Account>> getAll() async {
    try {
      final response = await _networkClient.get<List<Map<String, Object?>>>(
        '/accounts',
      );

      final data = response.data ?? [];

      return data.map((accountData) => Account.fromJson(accountData)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else {
        throw Exception('Failed to fetch accounts: $e');
      }
    }
  }

  @override
  Future<Account> getById(int accountId) async {
    try {
      final response = await _networkClient.get<Map<String, Object?>>(
        '/accounts/$accountId',
      );

      return Account.fromJson(response.data ?? {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Resource not found: ${e.response?.data}');
      } else {
        throw Exception('Failed to fetch account by id: $e');
      }
    }
  }

  @override
  Future<AccountHistoryResponse> getHistory(int accountId) async {
    try {
      final response = await _networkClient.get<Map<String, Object?>>(
        '/accounts/$accountId/history',
      );

      return AccountHistoryResponse.fromJson(response.data ?? {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Resource not found: ${e.response?.data}');
      } else {
        throw Exception('Failed to fetch account history: $e');
      }
    }
  }

  @override
  Future<Account> update({
    required int accountId,
    required AccountUpdateRequest updateRequest,
  }) async {
    try {
      final response = await _networkClient.put<Map<String, Object?>>(
        '/accounts/$accountId',
        data: {
          'name': updateRequest.name,
          'balance': updateRequest.balance,
          'currency': updateRequest.currency,
        },
      );

      return Account.fromJson(response.data ?? {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Resource not found: ${e.response?.data}');
      } else {
        throw Exception('Failed to update account: $e');
      }
    }
  }
}
