import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/theme/light_theme.dart';
import 'package:shmr_finance_app/data/repositories/mock/mock_bank_account_repository.dart';
import 'package:shmr_finance_app/data/repositories/mock/mock_category_repository.dart';
import 'package:shmr_finance_app/data/repositories/mock/mock_transaction_repository.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/app_page.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MainApp());
    },
    (error, stack) {
      debugPrint('[FATAL ERROR]: $error\n$stack');
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BankAccountRepository>(
            create: (context) => MockBankAccountRepository(),
          ),
          RepositoryProvider<CategoryRepository>(
            create: (context) => MockCategoryRepository(),
          ),
          RepositoryProvider<TransactionRepository>(
            create: (context) => MockTransactionRepository(
              categoriesRepo: context.read<CategoryRepository>(),
              accountsRepo: context.read<BankAccountRepository>(),
            ),
          ),
        ],
        child: const AppPage(),
      ),
    );
  }
}
