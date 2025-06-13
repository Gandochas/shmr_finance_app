import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({required this.asset, this.color, super.key});

  final String asset;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      colorFilter: ColorFilter.mode(IconTheme.of(context).color ?? Colors.black, BlendMode.srcIn),
      height: 24,
      width: 24,
    );
  }
}
