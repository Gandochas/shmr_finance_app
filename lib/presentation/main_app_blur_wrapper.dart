import 'package:flutter/material.dart';
import 'package:shmr_finance_app/presentation/blur_overlay.dart';

class MainAppBlurWrapper extends StatefulWidget {
  const MainAppBlurWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<MainAppBlurWrapper> createState() => _MainAppBlurWrapperState();
}

class _MainAppBlurWrapperState extends State<MainAppBlurWrapper>
    with WidgetsBindingObserver {
  bool _isBlurred = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused) {
        _isBlurred = true;
      } else if (state == AppLifecycleState.resumed) {
        _isBlurred = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [widget.child, if (_isBlurred) const BlurOverlay()]);
  }
}
