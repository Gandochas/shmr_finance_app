import 'dart:ui';

import 'package:flutter/material.dart';

class BlurOverlay extends StatelessWidget {
  const BlurOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ColoredBox(color: Colors.black.withValues(alpha: 0.5)),
      ),
    );
  }
}
