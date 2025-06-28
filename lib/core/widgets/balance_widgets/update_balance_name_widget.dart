import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/balance/balance_cubit.dart';

class UpdateBalanceNameWidget extends StatefulWidget {
  const UpdateBalanceNameWidget({required this.accountName, super.key});

  final String accountName;

  @override
  State<UpdateBalanceNameWidget> createState() =>
      _UpdateBalanceNameWidgetState();
}

class _UpdateBalanceNameWidgetState extends State<UpdateBalanceNameWidget> {
  final accountNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final balanceCubit = context.read<BalanceCubit>();
    return AlertDialog(
      title: const Text('Изменить имя счёта'),
      content: TextField(
        controller: accountNameController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.accountName,
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
            if (newName.isEmpty || newName == widget.accountName) {
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
