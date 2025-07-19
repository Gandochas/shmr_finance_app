import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/balance/balance_cubit.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/balance_page.dart';

class BalanceTab extends StatelessWidget {
  const BalanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BalanceCubit>(
      create: (context) => BalanceCubit(
        bankAccountRepository: context.read<BankAccountRepository>(),
        transactionRepository: context.read<TransactionRepository>(),
      )..loadAll(),
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const BalancePage());
        },
      ),
    );
  }
}
