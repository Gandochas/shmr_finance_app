import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance_app/presentation/main_app.dart';
import 'package:worker_manager/worker_manager.dart';

void main() {
  runZonedGuarded(
    () async {
      await dotenv.load(fileName: '.env');
      WidgetsFlutterBinding.ensureInitialized();
      await workerManager.init();
      final sharedPreferences = await SharedPreferences.getInstance();
      runApp(MainApp(sharedPreferences: sharedPreferences));
    },
    (error, stack) {
      debugPrint('[FATAL ERROR]: $error\n$stack');
    },
  );
}
