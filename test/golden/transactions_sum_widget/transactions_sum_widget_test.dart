import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_sum_widget.dart';

import '../../helpers/mock_data_factory.dart';
import '../../helpers/test_app_wrapper.dart';

void main() {
  group('TransactionsSumWidget Golden Tests', () {
    goldenTest(
      'empty transactions',
      fileName: 'transactions_sum_widget_empty',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 400),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: TestAppWrapperFactory.lightEnglish(
              child: TransactionsSumWidget(
                transactions: MockDataFactory.createEmptyTransactions(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: TestAppWrapperFactory.darkEnglish(
              child: TransactionsSumWidget(
                transactions: MockDataFactory.createEmptyTransactions(),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'single transaction',
      fileName: 'transactions_sum_widget_single',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 400),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: TestAppWrapperFactory.lightEnglish(
              child: TransactionsSumWidget(
                transactions: MockDataFactory.createSingleTransaction(
                  currency: 'RUB',
                  amount: '250.50',
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: TestAppWrapperFactory.darkEnglish(
              child: TransactionsSumWidget(
                transactions: MockDataFactory.createSingleTransaction(
                  currency: 'RUB',
                  amount: '250.50',
                ),
              ),
            ),
          ),
        ],
      ),
    );
    goldenTest(
      'multiple transactions',
      fileName: 'transactions_sum_widget_multiple',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 400),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: TestAppWrapperFactory.lightEnglish(
              child: TransactionsSumWidget(
                transactions: MockDataFactory.createMultipleTransactions(
                  currency: 'RUB',
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: TestAppWrapperFactory.darkEnglish(
              child: TransactionsSumWidget(
                transactions: MockDataFactory.createMultipleTransactions(
                  currency: 'RUB',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
