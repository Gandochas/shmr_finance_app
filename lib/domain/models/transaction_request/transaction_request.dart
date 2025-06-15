import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_request.freezed.dart';
part 'transaction_request.g.dart';

@freezed
abstract class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    required int id,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
  }) = _TransactionRequest;

  factory TransactionRequest.fromJson(Map<String, Object?> json) =>
      _$TransactionRequestFromJson(json);
}
