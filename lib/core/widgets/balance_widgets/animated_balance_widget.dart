import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBalanceWidget extends StatelessWidget {
  const AnimatedBalanceWidget({
    required this.hidden,
    required this.balance,
    required this.currency,
    super.key,
  });

  final bool hidden;
  final String balance;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: hidden ? 0 : 5, end: hidden ? 5 : 0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, blur, child) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child!,
        );
      },
      child: Text('$balance $currency', style: theme.textTheme.bodyLarge),
    );
  }
}
