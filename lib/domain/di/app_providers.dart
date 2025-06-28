import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/data/repositories/bank_account_repository_impl.dart';
import 'package:shmr_finance_app/data/repositories/category_repository_impl.dart';
import 'package:shmr_finance_app/data/repositories/transaction_repository_impl.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/account_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/category_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/transaction_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/mock/bank_account_mock_datasource_impl.dart';
import 'package:shmr_finance_app/data/sources/mock/category_mock_datasource_impl.dart';
import 'package:shmr_finance_app/data/sources/mock/transaction_mock_datasource_impl.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (context) => AppDatabase()),
        Provider<BankAccountMockDatasourceImpl>(
          create: (context) => BankAccountMockDatasourceImpl(),
        ),
        Provider<AccountDao>(
          create: (context) => context.read<AppDatabase>().accountDao,
        ),
        Provider<BankAccountRepository>(
          create: (context) => BankAccountRepositoryImpl(
            apiSource: context.read<BankAccountMockDatasourceImpl>(),
            accountDao: context.read<AccountDao>(),
          ),
        ),
        Provider<CategoryMockDatasourceImpl>(
          create: (context) => CategoryMockDatasourceImpl(),
        ),
        Provider<CategoryDao>(
          create: (context) => context.read<AppDatabase>().categoryDao,
        ),
        Provider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(
            apiSource: context.read<CategoryMockDatasourceImpl>(),
            categoryDao: context.read<CategoryDao>(),
          ),
        ),
        Provider<TransactionMockDatasourceImpl>(
          create: (context) => TransactionMockDatasourceImpl(
            categoriesSource: context.read<CategoryMockDatasourceImpl>(),
            accountsSource: context.read<BankAccountMockDatasourceImpl>(),
          ),
        ),
        Provider<TransactionDao>(
          create: (context) => context.read<AppDatabase>().transactionDao,
        ),
        Provider<TransactionRepository>(
          create: (context) => TransactionRepositoryImpl(
            apiSource: context.read<TransactionMockDatasourceImpl>(),
            transactionDao: context.read<TransactionDao>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
