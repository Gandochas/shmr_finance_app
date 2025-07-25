import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance_app/presentation/main_app.dart';

void main() {
  patrolTest('Изменение имени аккаунта', (tester) async {
    final sharedPrefs = await SharedPreferences.getInstance();

    await tester.pumpWidgetAndSettle(MainApp(sharedPreferences: sharedPrefs));

    await tester('Balance').tap();

    await tester.enterText(
      tester(#update_balance_name),
      'integration test name',
    );

    await tester(#confirm_name_change).tap();

    await tester('integration test name').waitUntilVisible();
  });
}
