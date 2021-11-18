import 'package:flutter/material.dart';

class Responsive {
  final Widget widthSmall;
  final Widget widthNormal;
  final Widget widthLarge;

  const Responsive({
    required this.widthSmall,
    required this.widthNormal,
    required this.widthLarge,
  });

  static bool isLarge(BuildContext context) => MediaQuery.of(context).size.width >= 1000;
}
