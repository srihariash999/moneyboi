import 'package:flutter/material.dart';
import 'package:moneyboi/Constants/colors.dart';

class BigBarButtonBody extends StatelessWidget {
  const BigBarButtonBody({
    Key? key,
    this.horizontalPadding,
    required this.child,
    this.borderRadius,
  }) : super(key: key);
  final double? horizontalPadding;
  final Widget child;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 30.0,
      ),
      padding: const EdgeInsets.all(16.0),
      width: double.maxFinite,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: moneyBoyPurple,
        borderRadius: BorderRadius.circular(borderRadius ?? 18.0),
      ),
      child: child,
    );
  }
}
