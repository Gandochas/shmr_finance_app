import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance_app/core/locale_decimal_formatter.dart';
import 'package:shmr_finance_app/core/widgets/format_date.dart';
import 'package:shmr_finance_app/core/widgets/format_time.dart';
import 'package:shmr_finance_app/domain/bloc/transaction_form/transaction_form_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({
    required this.isIncomePage,
    required this.onSave,
    required this.onDelete,
    this.transaction,
    super.key,
  });

  final TransactionResponse? transaction;
  final bool isIncomePage;
  final Future<void> Function(TransactionRequest updatedTransaction) onSave;
  final Future<void> Function() onDelete;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _commentController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int? _selectedAccountId;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    _amountController = TextEditingController(text: transaction?.amount ?? '');
    _commentController = TextEditingController(
      text: transaction?.comment ?? '',
    );
    _selectedDate = transaction?.transactionDate ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);

    if (transaction != null) {
      _selectedAccountId = transaction.account.id;
      _selectedCategoryId = transaction.category.id;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (_amountController.text.trim().isEmpty ||
        _selectedCategoryId == null ||
        _selectedAccountId == null) {
      return false;
    }
    return true;
  }

  Future<void> _showValidationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(
            'Пожалуйста, заполните все обязательные поля.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final separator = NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: CloseButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          widget.transaction == null
              ? (widget.isIncomePage ? 'Добавить доход' : 'Добавить расход')
              : (widget.isIncomePage
                    ? 'Редактировать доход'
                    : 'Редактировать расход'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (!_validateFields()) {
                await _showValidationDialog();
                return;
              }
              await _onSave();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionFormCubit, TransactionFormState>(
        builder: (context, state) {
          return switch (state) {
            TransactionFormLoadingState() => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),

            TransactionFormErrorState() => Center(
              child: Text(state.errorMessage),
            ),

            TransactionFormIdleState(:final accounts, :final categories) =>
              ListView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                children: [
                  ListTile(
                    title: const Text('Счет'),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedAccountId ??= accounts.first.id,
                        items: accounts
                            .map(
                              (account) => DropdownMenuItem(
                                value: account.id,
                                child: Text(
                                  '${account.name}, ${account.currency}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedAccountId = value);
                        },
                      ),
                    ),
                  ),

                  Divider(height: 1, color: Theme.of(context).dividerColor),

                  ListTile(
                    title: const Text('Статья'),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedCategoryId,
                        hint: const Text('Выберите категорию'),
                        items: categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.id,
                                child: Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategoryId = value);
                          }
                        },
                      ),
                    ),
                  ),

                  Divider(height: 1, color: Theme.of(context).dividerColor),

                  ListTile(
                    title: const Text('Сумма'),
                    trailing: SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [LocaleDecimalFormatter(separator)],
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  Divider(height: 1, color: Theme.of(context).dividerColor),

                  ListTile(
                    title: const Text('Дата'),
                    trailing: TextButton(
                      onPressed: _pickDate,
                      child: Text(
                        formatDate(date: _selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),

                  Divider(height: 1, color: Theme.of(context).dividerColor),

                  ListTile(
                    title: const Text('Время'),
                    trailing: TextButton(
                      onPressed: _pickTime,
                      child: Text(
                        formatTimeOfDay(_selectedTime),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),

                  Divider(height: 1, color: Theme.of(context).dividerColor),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Комментарий',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  const SizedBox(height: 24),

                  if (widget.transaction != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () async {
                          await widget.onDelete();
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.isIncomePage
                              ? 'Удалить доход'
                              : 'Удалить расход',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
          };
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final pick = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pick != null) setState(() => _selectedDate = pick);
  }

  Future<void> _pickTime() async {
    final pick = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (pick != null) setState(() => _selectedTime = pick);
  }

  Future<void> _onSave() async {
    final combinedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final request = TransactionRequest(
      id: widget.transaction?.id ?? _selectedAccountId!,
      categoryId: _selectedCategoryId!,
      amount: _amountController.text.trim(),
      transactionDate: combinedDate,
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
    );

    await widget.onSave(request);
  }
}
