import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/theme/light_theme.dart';
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
    return MaterialApp(debugShowCheckedModeBanner: false, theme: getLightTheme(), home: const AppPage());
  }
}
