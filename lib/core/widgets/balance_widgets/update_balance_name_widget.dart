import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/balance/balance_cubit.dart';

class UpdateBalanceNameWidget extends StatelessWidget {
  const UpdateBalanceNameWidget({required this.accountName, super.key});

  final String accountName;

  @override
  Widget build(BuildContext context) {
    final accountNameController = TextEditingController();
    final balanceCubit = context.read<BalanceCubit>();
    return AlertDialog(
      title: const Text('Изменить имя счёта'),
      content: TextField(
        controller: accountNameController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: accountName,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () async {
            final newName = accountNameController.text.trim();
            if (newName.isEmpty || newName == accountName) {
              Navigator.of(context).pop();
              return;
            }
            await balanceCubit.updateAccountName(newName);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Изменить'),
        ),
      ],
    );
  }
}
