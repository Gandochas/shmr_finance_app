import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/data/repositories/bank_account_repository_impl.dart';
import 'package:shmr_finance_app/data/repositories/category_repository_impl.dart';
import 'package:shmr_finance_app/data/repositories/transaction_repository_impl.dart';
import 'package:shmr_finance_app/data/services/sync_service.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/account_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/category_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/pending_operations_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/transaction_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/network/bank_account_network_datasource_impl.dart';
import 'package:shmr_finance_app/data/sources/network/category_network_datasource_impl.dart';
import 'package:shmr_finance_app/data/sources/network/transaction_network_datasource_impl.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/domain/sources/bank_account_datasource.dart';
import 'package:shmr_finance_app/domain/sources/category_datasource.dart';
import 'package:shmr_finance_app/domain/sources/transaction_datasource.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (context) => AppDatabase(),
          dispose: (context, db) => db.close(),
        ),
        Provider<BankAccountDatasource>(
          create: (context) => BankAccountNetworkDatasourceImpl(),
        ),
        Provider<AccountDao>(
          create: (context) => AccountDao(context.read<AppDatabase>()),
        ),
        Provider<CategoryDatasource>(
          create: (context) => CategoryNetworkDatasourceImpl(),
        ),
        Provider<CategoryDao>(
          create: (context) => CategoryDao(context.read<AppDatabase>()),
        ),
        Provider<TransactionDatasource>(
          create: (context) => TransactionNetworkDatasourceImpl(
            // categoriesSource: context.read<CategoryDatasource>(),
            // accountsSource: context.read<BankAccountDatasource>(),
          ),
        ),
        Provider<TransactionDao>(
          create: (context) => TransactionDao(context.read<AppDatabase>()),
        ),
        Provider<PendingOperationsDao>(
          create: (context) =>
              PendingOperationsDao(context.read<AppDatabase>()),
        ),
        Provider<SyncService>(
          create: (context) => SyncService(
            transactionApiSource: context.read<TransactionDatasource>(),
            bankAccountApiSource: context.read<BankAccountDatasource>(),
            transactionDao: context.read<TransactionDao>(),
            accountDao: context.read<AccountDao>(),
            pendingOperationsDao: context.read<PendingOperationsDao>(),
          ),
        ),
        Provider<BankAccountRepository>(
          create: (context) => BankAccountRepositoryImpl(
            apiSource: BankAccountNetworkDatasourceImpl(),
            accountDao: context.read<AccountDao>(),
            pendingOperationsDao: context.read<PendingOperationsDao>(),
            syncService: context.read<SyncService>(),
          ),
        ),
        Provider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(
            apiSource: context.read<CategoryDatasource>(),
            categoryDao: context.read<CategoryDao>(),
          ),
        ),
        Provider<TransactionRepository>(
          create: (context) => TransactionRepositoryImpl(
            apiSource: TransactionNetworkDatasourceImpl(),
            transactionDao: context.read<TransactionDao>(),
            pendingOperationsDao: context.read<PendingOperationsDao>(),
            syncService: context.read<SyncService>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
