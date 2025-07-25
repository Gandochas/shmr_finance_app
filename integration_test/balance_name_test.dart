import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance_app/presentation/main_app.dart';
import 'package:worker_manager/worker_manager.dart';

void main() {
  patrolTest('Изменение имени аккаунта', (tester) async {
    await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();
    await workerManager.init();
    final sharedPreferences = await SharedPreferences.getInstance();
    await tester.pumpWidgetAndSettle(
      MainApp(sharedPreferences: sharedPreferences),
    );

    await tester.enterText(tester(#insert_pin_field), '1111');

    await tester(#check_pin_button).tap();

    await tester(#balance_page).tap();

    await Future<void>.delayed(const Duration(seconds: 5));

    await tester(#dialog_balance_name).tap();

    await tester.enterText(
      tester(#update_balance_name),
      'integration test name',
    );

    await tester(#confirm_name_change).tap();

    await tester('integration test name').waitUntilVisible();
  });
}
