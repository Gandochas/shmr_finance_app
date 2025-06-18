import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/widgets/svg_icon.dart';
import 'package:shmr_finance_app/presentation/pages/articles_page.dart';
import 'package:shmr_finance_app/presentation/pages/balance_page.dart';
import 'package:shmr_finance_app/presentation/pages/expenses_incomes_page.dart';
import 'package:shmr_finance_app/presentation/pages/settings_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentPageIndex = 0;
  static const _pages = <Widget>[
    ExpensesIncomesPage(isIncomePage: false),
    ExpensesIncomesPage(isIncomePage: true),
    BalancePage(),
    ArticlesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentPageIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(
          context,
        ).floatingActionButtonTheme.backgroundColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (pageIndex) {
          setState(() {
            _currentPageIndex = pageIndex;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: SvgIcon(asset: 'assets/icons/expenses_icon.svg'),
            label: 'Расходы',
          ),
          NavigationDestination(
            icon: SvgIcon(asset: 'assets/icons/incomes_icon.svg'),
            label: 'Доходы',
          ),
          NavigationDestination(
            icon: SvgIcon(asset: 'assets/icons/account_icon.svg'),
            label: 'Счет',
          ),
          NavigationDestination(
            icon: SvgIcon(asset: 'assets/icons/articles_icon.svg'),
            label: 'Статьи',
          ),
          NavigationDestination(
            icon: SvgIcon(asset: 'assets/icons/settings_icon.svg'),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
