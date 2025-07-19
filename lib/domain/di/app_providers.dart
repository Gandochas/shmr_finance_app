import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance_app/data/repositories/bank_account_repository_impl.dart';
import 'package:shmr_finance_app/data/repositories/category_repository_impl.dart';
import 'package:shmr_finance_app/data/repositories/transaction_repository_impl.dart';
import 'package:shmr_finance_app/data/services/sync_service.dart';
import 'package:shmr_finance_app/data/sources/app_color/app_color_datasource.dart';
import 'package:shmr_finance_app/data/sources/app_theme/app_theme_datasource.dart';
import 'package:shmr_finance_app/data/sources/biometric/biometric_datasource.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/account_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/category_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/pending_operations_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/transaction_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/haptic_touch/haptic_touch_datasource.dart';
import 'package:shmr_finance_app/data/sources/localization/localization_datasource.dart';
import 'package:shmr_finance_app/data/sources/network/bank_account_network_datasource_impl.dart';
import 'package:shmr_finance_app/data/sources/network/category_network_datasource_impl.dart';
import 'package:shmr_finance_app/data/sources/network/transaction_network_datasource_impl.dart';
import 'package:shmr_finance_app/data/sources/pin_code/pin_code_datasource.dart';
import 'package:shmr_finance_app/domain/controllers/app_color/app_color_controller.dart';
import 'package:shmr_finance_app/domain/controllers/app_theme/app_theme_controller.dart';
import 'package:shmr_finance_app/domain/controllers/biometric/biometric_controller.dart';
import 'package:shmr_finance_app/domain/controllers/haptic_touch/haptic_touch_controller.dart';
import 'package:shmr_finance_app/domain/controllers/localization/localization_controller.dart';
import 'package:shmr_finance_app/domain/controllers/pin_code/pin_code_controller.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/domain/sources/bank_account_datasource.dart';
import 'package:shmr_finance_app/domain/sources/category_datasource.dart';
import 'package:shmr_finance_app/domain/sources/transaction_datasource.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.child,
    required this.sharedPreferences,
    super.key,
  });

  final Widget child;
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppColorDatasource>(
          create: (context) =>
              AppColorDatasource(preferences: sharedPreferences),
        ),
        ChangeNotifierProvider<AppColorController>(
          create: (context) {
            final appColorController = AppColorController(
              appColorDatasource: context.read<AppColorDatasource>(),
            );
            appColorController.load();
            return appColorController;
          },
        ),
        Provider<AppThemeDatasource>(
          create: (context) =>
              AppThemeDatasource(preferences: sharedPreferences),
        ),
        ChangeNotifierProvider<AppThemeController>(
          create: (context) {
            final appThemeController = AppThemeController(
              appThemeDatasource: context.read<AppThemeDatasource>(),
            );
            appThemeController.load();
            return appThemeController;
          },
        ),
        Provider<HapticTouchDatasource>(
          create: (context) =>
              HapticTouchDatasource(preferences: sharedPreferences),
        ),
        ChangeNotifierProvider<HapticTouchController>(
          create: (context) {
            final hapticTouchController = HapticTouchController(
              hapticFeedbackDatasource: context.read<HapticTouchDatasource>(),
            );
            hapticTouchController.load();
            return hapticTouchController;
          },
        ),
        Provider<FlutterSecureStorage>(
          create: (context) => const FlutterSecureStorage(),
        ),
        Provider<PinCodeDatasource>(
          create: (context) => PinCodeDatasource(
            secureStorage: context.read<FlutterSecureStorage>(),
          ),
        ),
        ChangeNotifierProvider<PinCodeController>(
          create: (context) {
            final pinCodeController = PinCodeController(
              pinCodeDatasource: context.read<PinCodeDatasource>(),
            );
            pinCodeController.loadPinCode();
            return pinCodeController;
          },
        ),
        Provider<BiometricDatasource>(
          create: (context) =>
              BiometricDatasource(preferences: sharedPreferences),
        ),
        ChangeNotifierProvider<BiometricController>(
          create: (context) {
            final biometricController = BiometricController(
              biometricDatasource: context.read<BiometricDatasource>(),
            );
            biometricController.loadBiometricSetting();
            return biometricController;
          },
        ),
        Provider<LocalizationDatasource>(
          create: (context) =>
              LocalizationDatasource(preferences: sharedPreferences),
        ),
        ChangeNotifierProvider<LocalizationController>(
          create: (context) {
            final localizationController = LocalizationController(
              localizationDatasource: context.read<LocalizationDatasource>(),
            );
            localizationController.loadLocalization();
            return localizationController;
          },
        ),
        Provider<AppDatabase>(
          create: (context) => AppDatabase(),
          dispose: (context, db) => db.close(),
        ),
        Provider<BankAccountDatasource>(
          create: (context) => BankAccountNetworkDatasourceImpl(),
        ),
        Provider<AccountDao>(
          create: (context) => AccountDao(context.read<AppDatabase>()),
        ),
        Provider<CategoryDatasource>(
          create: (context) => CategoryNetworkDatasourceImpl(),
        ),
        Provider<CategoryDao>(
          create: (context) => CategoryDao(context.read<AppDatabase>()),
        ),
        Provider<TransactionDatasource>(
          create: (context) => TransactionNetworkDatasourceImpl(),
        ),
        Provider<TransactionDao>(
          create: (context) => TransactionDao(context.read<AppDatabase>()),
        ),
        Provider<PendingOperationsDao>(
          create: (context) =>
              PendingOperationsDao(context.read<AppDatabase>()),
        ),
        Provider<SyncService>(
          create: (context) => SyncService(
            transactionApiSource: context.read<TransactionDatasource>(),
            bankAccountApiSource: context.read<BankAccountDatasource>(),
            transactionDao: context.read<TransactionDao>(),
            accountDao: context.read<AccountDao>(),
            pendingOperationsDao: context.read<PendingOperationsDao>(),
          ),
        ),
        Provider<BankAccountRepository>(
          create: (context) => BankAccountRepositoryImpl(
            apiSource: BankAccountNetworkDatasourceImpl(),
            accountDao: context.read<AccountDao>(),
            pendingOperationsDao: context.read<PendingOperationsDao>(),
            syncService: context.read<SyncService>(),
          ),
        ),
        Provider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(
            apiSource: context.read<CategoryDatasource>(),
            categoryDao: context.read<CategoryDao>(),
          ),
        ),
        Provider<TransactionRepository>(
          create: (context) => TransactionRepositoryImpl(
            apiSource: TransactionNetworkDatasourceImpl(),
            transactionDao: context.read<TransactionDao>(),
            pendingOperationsDao: context.read<PendingOperationsDao>(),
            syncService: context.read<SyncService>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
