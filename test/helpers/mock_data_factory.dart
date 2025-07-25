import 'package:shmr_finance_app/domain/models/account_brief/account_brief.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

class MockDataFactory {
  static AccountBrief createAccountBrief({
    int id = 1,
    String name = 'Test Account',
    String balance = '1000.00',
    String currency = 'RUB',
  }) {
    return AccountBrief(
      id: id,
      name: name,
      balance: balance,
      currency: currency,
    );
  }

  static Category createCategory({
    int id = 1,
    String name = 'Food',
    String emoji = '🍕',
    bool isIncome = false,
  }) {
    return Category(id: id, name: name, emoji: emoji, isIncome: isIncome);
  }

  static TransactionResponse createTransaction({
    int id = 1,
    AccountBrief? account,
    Category? category,
    String amount = '100.00',
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? comment,
  }) {
    final now = DateTime.now();
    return TransactionResponse(
      id: id,
      account: account ?? createAccountBrief(),
      category: category ?? createCategory(),
      amount: amount,
      transactionDate: transactionDate ?? now,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      comment: comment,
    );
  }

  static List<TransactionResponse> createEmptyTransactions() {
    return [];
  }

  static List<TransactionResponse> createSingleTransaction({
    String currency = 'RUB',
    String amount = '250.50',
  }) {
    return [
      createTransaction(
        account: createAccountBrief(currency: currency),
        amount: amount,
      ),
    ];
  }

  static List<TransactionResponse> createMultipleTransactions({
    String currency = 'RUB',
  }) {
    final account = createAccountBrief(currency: currency);
    return [
      createTransaction(
        id: 1,
        account: account,
        amount: '150.00',
        category: createCategory(name: 'Food', emoji: '🍕'),
      ),
      createTransaction(
        id: 2,
        account: account,
        amount: '75.25',
        category: createCategory(name: 'Transport', emoji: '🚗'),
      ),
      createTransaction(
        id: 3,
        account: account,
        amount: '200.00',
        category: createCategory(name: 'Shopping', emoji: '🛒'),
      ),
    ];
  }
}
