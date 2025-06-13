import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? comment,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, Object?> json) => _$TransactionFromJson(json);
}
