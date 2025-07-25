import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

const alchemistConfig = AlchemistConfig(
  platformGoldensConfig: PlatformGoldensConfig(enabled: true),
  ciGoldensConfig: CiGoldensConfig(enabled: true),
);

class TestConstraints {
  static const BoxConstraints mobile = BoxConstraints(
    maxWidth: 375,
    maxHeight: 200,
  );

  static const BoxConstraints flexible = BoxConstraints(
    maxWidth: 500,
    maxHeight: 300,
  );
}
