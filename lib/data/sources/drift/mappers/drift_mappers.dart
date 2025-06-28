import 'package:shmr_finance_app/data/sources/drift/daos/transaction_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/account_brief/account_brief.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/models/transaction/transaction.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

class DriftMappers {
  // Account mappers
  static Account accountEntityToModel(AccountEntity entity) {
    return Account(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      balance: entity.balance,
      currency: entity.currency,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static AccountBrief accountEntityToBrief(AccountEntity entity) {
    return AccountBrief(
      id: entity.id,
      name: entity.name,
      balance: entity.balance,
      currency: entity.currency,
    );
  }

  // Category mappers
  static Category categoryEntityToModel(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
      emoji: entity.emoji,
      isIncome: entity.isIncome,
    );
  }

  // Transaction mappers
  static Transaction transactionEntityToModel(TransactionEntity entity) {
    return Transaction(
      id: entity.id,
      accountId: entity.accountId,
      categoryId: entity.categoryId,
      amount: entity.amount,
      comment: entity.comment,
      transactionDate: entity.transactionDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Complex mapper for transaction with details
  static TransactionResponse transactionWithDetailsToResponse(
    TransactionWithDetails details,
  ) {
    final transaction = details.transaction;
    final account = details.account;
    final category = details.category;

    if (account == null || category == null) {
      throw Exception('Transaction must have account and category');
    }

    return TransactionResponse(
      id: transaction.id,
      account: accountEntityToBrief(account),
      category: categoryEntityToModel(category),
      amount: transaction.amount,
      comment: transaction.comment,
      transactionDate: transaction.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }
}
