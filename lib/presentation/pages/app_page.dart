import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/widgets/svg_icon.dart';
import 'package:shmr_finance_app/presentation/pages/articles_tab.dart';
import 'package:shmr_finance_app/presentation/pages/balance_tab.dart';
import 'package:shmr_finance_app/presentation/pages/expenses_incomes_navigator_tab.dart';
import 'package:shmr_finance_app/presentation/pages/settings_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentPageIndex = 0;

  final _navigatorKeys = List.generate(
    5,
    (index) => GlobalKey<NavigatorState>(),
  );

  Widget _buildTab(int index) => switch (index) {
    0 => const ExpensesIncomesNavigatorTab(isIncomePage: false),
    1 => const ExpensesIncomesNavigatorTab(isIncomePage: true),
    2 => const BalanceTab(),
    3 => const ArticlesTab(),
    4 => const SettingsPage(),
    _ => const ExpensesIncomesNavigatorTab(isIncomePage: false),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: List.generate(
          _navigatorKeys.length,
          (index) => Navigator(
            key: _navigatorKeys[index],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (context) => _buildTab(index));
            },
          ),
        ),
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
