import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/domain/controllers/biometric/biometric_controller.dart';
import 'package:shmr_finance_app/domain/controllers/pin_code/pin_code_controller.dart';
import 'package:shmr_finance_app/presentation/pages/app_page.dart';

enum PinCodeState { setup, update, verify }

class PinCodePage extends StatefulWidget {
  const PinCodePage({required this.state, super.key});

  final PinCodeState state;

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  final _inputPinCodeController = TextEditingController();
  final _confirmPinCodeController = TextEditingController();
  String _errorMessage = '';

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    final biometricController = context.read<BiometricController>();
    if (biometricController.isBiometricEnabled) {
      final localAuth = LocalAuthentication();
      try {
        final authenticated = await localAuth.authenticate(
          localizedReason: 'Приложите палец для аутентификации.',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (!context.mounted) return;
        if (authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (context) => const AppPage()),
          );
        }
      } on Object catch (e) {
        setState(() {
          _errorMessage = 'Ошибка биометрической аутентификации: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pinCodeController = context.read<PinCodeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.state == PinCodeState.setup
              ? 'Установите пин-код'
              : widget.state == PinCodeState.update
              ? 'Измените пин-код'
              : 'Введите пин-код',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _inputPinCodeController,
              decoration: InputDecoration(
                labelText:
                    widget.state == PinCodeState.setup ||
                        widget.state == PinCodeState.update
                    ? 'Введите новый пин-код'
                    : 'Пин-код',
                labelStyle: theme.textTheme.bodyLarge,
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            if (widget.state == PinCodeState.update)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  controller: _confirmPinCodeController,
                  decoration: InputDecoration(
                    labelText: 'Подтвердите пин-код',
                    labelStyle: theme.textTheme.bodyLarge,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final pinCode = _inputPinCodeController.text;
                if (pinCode.length != 4) {
                  setState(() {
                    _errorMessage = 'Пин-код должен содержать 4 цифры';
                  });
                  return;
                }

                if (widget.state == PinCodeState.setup) {
                  try {
                    await pinCodeController.setPinCode(pinCode);
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (context) => const AppPage(),
                      ),
                    );
                  } on Object catch (e) {
                    setState(() {
                      _errorMessage = e.toString().substring(10);
                    });
                  }
                } else if (widget.state == PinCodeState.update) {
                  final confirmPinCode = _confirmPinCodeController.text;

                  if (pinCode != confirmPinCode) {
                    setState(() {
                      _errorMessage = 'Пин-коды не совпадают';
                    });
                    return;
                  }

                  try {
                    await pinCodeController.setPinCode(pinCode);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } on Object catch (e) {
                    setState(() {
                      _errorMessage = e.toString().substring(10);
                    });
                  }
                } else if (widget.state == PinCodeState.verify) {
                  final isCorrect = pinCodeController.isPinCodeCorrect(pinCode);

                  if (isCorrect) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (context) => const AppPage(),
                      ),
                    );
                  } else {
                    if (pinCodeController.attemptsLeft > 0) {
                      setState(() {
                        _errorMessage =
                            'Неверный пин-код. Осталось попыток: ${pinCodeController.attemptsLeft}';
                      });
                    } else {
                      setState(() {
                        _errorMessage =
                            'Попытки закончились. Попробуйте позже.';
                      });
                    }
                  }
                }
              },
              child: Text(
                widget.state == PinCodeState.setup
                    ? 'Установить пин-код'
                    : widget.state == PinCodeState.update
                    ? 'Изменить пин-код'
                    : 'Подтвердить пин-код',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            if (context.watch<BiometricController>().isBiometricEnabled)
              ElevatedButton(
                onPressed: () => _authenticateWithBiometrics(context),
                child: Text(
                  'Авторизоваться, используя отпечаток пальца',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
