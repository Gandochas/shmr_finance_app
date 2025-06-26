import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/balance/balance_cubit.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  Future<void> _showCurrencyPicker() async {
    final cubit = context.read<BalanceCubit>();

    final selectedCurrency = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          ListTile(
            leading: Text('₽', style: Theme.of(context).textTheme.bodyLarge),
            title: Text(
              'Российский рубль ₽',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () => Navigator.of(context).pop('₽'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: Text(r'$', style: Theme.of(context).textTheme.bodyLarge),
            title: Text(
              r'Американский доллар $',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () => Navigator.of(context).pop(r'$'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: Text('€', style: Theme.of(context).textTheme.bodyLarge),
            title: Text('Евро €', style: Theme.of(context).textTheme.bodyLarge),
            onTap: () => Navigator.of(context).pop('€'),
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.error,
            leading: const Icon(Icons.close),
            title: const Text('Отмена'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    if (selectedCurrency != null) {
      await cubit.updateCurrency(selectedCurrency);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: const Text(
              'Мой счет',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Theme.of(
              context,
            ).floatingActionButtonTheme.backgroundColor,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
          body: Builder(
            builder: (context) {
              return switch (state) {
                BalanceLoadingState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                BalanceErrorState() => Center(child: Text(state.errorMessage)),
                BalanceIdleState(:final balance, :final currency) => Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '💰',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        title: Text(
                          'Баланс',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$balance $currency',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.navigate_next),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: ListTile(
                        title: Text(
                          'Валюта',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currency,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            IconButton(
                              onPressed: _showCurrencyPicker,
                              icon: const Icon(Icons.navigate_next),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              };
            },
          ),
        );
      },
    );
  }
}
