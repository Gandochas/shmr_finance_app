import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/domain/controllers/biometric/biometric_controller.dart';

class BiometricSettingsPage extends StatefulWidget {
  const BiometricSettingsPage({super.key});

  @override
  State<BiometricSettingsPage> createState() => _BiometricSettingsPageState();
}

class _BiometricSettingsPageState extends State<BiometricSettingsPage> {
  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки биометрии'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer<BiometricController>(
              builder: (context, biometricController, child) {
                return SwitchListTile(
                  title: const Text('Включить биометрическую аутентификацию'),
                  value: biometricController.isBiometricEnabled,
                  onChanged: (value) async {
                    await biometricController.setBiometricEnabled(
                      isEnabled: value,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
