import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr_finance_app/domain/models/account_brief/account_brief.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';

part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

@freezed
abstract class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required int id,
    required AccountBrief account,
    required Category category,
    required String amount,
    required DateTime transactionDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? comment,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, Object?> json) => _$TransactionResponseFromJson(json);
}
