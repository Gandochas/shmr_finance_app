import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/core/network/connection_checker.dart';
import 'package:shmr_finance_app/core/widgets/svg_icon.dart';
import 'package:shmr_finance_app/domain/controllers/haptic_touch/haptic_touch_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';
import 'package:shmr_finance_app/presentation/articles_tab.dart';
import 'package:shmr_finance_app/presentation/balance_tab.dart';
import 'package:shmr_finance_app/presentation/expenses_incomes_tab.dart';
import 'package:shmr_finance_app/presentation/pages/settings_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentPageIndex = 0;
  bool _isOffline = false;
  late Timer _timer;

  final _navigatorKeys = List.generate(
    5,
    (index) => GlobalKey<NavigatorState>(),
  );

  Widget _buildTab(int index) => switch (index) {
    0 => const ExpensesIncomesTab(isIncomePage: false),
    1 => const ExpensesIncomesTab(isIncomePage: true),
    2 => const BalanceTab(),
    3 => const ArticlesTab(),
    4 => const SettingsPage(),
    _ => const ExpensesIncomesTab(isIncomePage: false),
  };

  final _connectionChecker = ConnectionChecker();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkConnection();
    });

    _checkConnection();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    final isConnected = await _connectionChecker.isConnected();
    setState(() {
      _isOffline = !isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hapticTouchController = context.watch<HapticTouchController>();
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentPageIndex,
            children: List.generate(
              _navigatorKeys.length,
              (index) => Navigator(
                key: _navigatorKeys[index],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => _buildTab(index),
                  );
                },
              ),
            ),
          ),
          if (_isOffline)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: theme.colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  localization.offline_mode,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (pageIndex) {
          if (hapticTouchController.isHapticFeedbackEnabled) {
            HapticFeedback.mediumImpact();
          }
          setState(() {
            _currentPageIndex = pageIndex;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: [
          NavigationDestination(
            icon: const SvgIcon(asset: 'assets/icons/expenses_icon.svg'),
            label: localization.expenses,
          ),
          NavigationDestination(
            icon: const SvgIcon(asset: 'assets/icons/incomes_icon.svg'),
            label: localization.incomes,
          ),
          NavigationDestination(
            icon: const SvgIcon(asset: 'assets/icons/account_icon.svg'),
            label: localization.balance,
          ),
          NavigationDestination(
            icon: const SvgIcon(asset: 'assets/icons/articles_icon.svg'),
            label: localization.articles,
          ),
          NavigationDestination(
            icon: const SvgIcon(asset: 'assets/icons/settings_icon.svg'),
            label: localization.settings,
          ),
        ],
      ),
    );
  }
}
