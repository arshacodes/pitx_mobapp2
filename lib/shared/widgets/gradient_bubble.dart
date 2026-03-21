import 'package:flutter/material.dart';

class GradientBubble extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const GradientBubble({super.key, required this.size, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors, stops: const [0.0, 1.0]),
      ),
    );
  }
}
