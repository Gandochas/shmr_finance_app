import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shmr_finance_app/core/theme/light_theme.dart';
import 'package:shmr_finance_app/domain/di/app_providers.dart';
import 'package:shmr_finance_app/presentation/pages/app_page.dart';
import 'package:worker_manager/worker_manager.dart';

void main() {
  runZonedGuarded(
    () async {
      await dotenv.load(fileName: '.env');
      WidgetsFlutterBinding.ensureInitialized();
      await workerManager.init();
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
    return AppProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getLightTheme(),
        home: const AppPage(),
      ),
    );
  }
}
