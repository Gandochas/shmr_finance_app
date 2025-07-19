import 'package:flutter/material.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';
import 'package:shmr_finance_app/presentation/pages/pin_code_page.dart';

class PinCodeChanger extends StatelessWidget {
  const PinCodeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ListTile(
      title: Text(
        localization.to_change_pincode,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (context) =>
                  const PinCodePage(state: PinCodeState.update),
            ),
          );
        },
        icon: const Icon(Icons.navigate_next),
      ),
    );
  }
}
