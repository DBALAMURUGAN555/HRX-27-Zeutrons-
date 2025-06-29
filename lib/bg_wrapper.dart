import 'package:flutter/material.dart';

class BgWrapper extends StatelessWidget {
  final Widget child;
  final double opacity;

  const BgWrapper({super.key, required this.child, this.opacity = 0.6});

  @override
  Widget build(BuildContext context) {
    // No background image, just return the child
    return child;
  }
}