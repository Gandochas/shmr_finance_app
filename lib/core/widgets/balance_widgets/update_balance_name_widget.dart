import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/balance/balance_cubit.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class UpdateBalanceNameWidget extends StatelessWidget {
  const UpdateBalanceNameWidget({required this.accountName, super.key});

  final String accountName;

  @override
  Widget build(BuildContext context) {
    final accountNameController = TextEditingController();
    final balanceCubit = context.read<BalanceCubit>();
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        localization.change_balance_name,
        style: theme.textTheme.bodyLarge,
      ),
      content: TextField(
        controller: accountNameController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: accountName,
          hintStyle: theme.textTheme.bodyLarge,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(localization.cancel, style: theme.textTheme.bodyLarge),
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
          child: Text(localization.change, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }
}
