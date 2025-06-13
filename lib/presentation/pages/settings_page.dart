import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Настройки', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
        centerTitle: true,
      ),
      body: const Center(child: Text('Settings')),
    );
  }
}
