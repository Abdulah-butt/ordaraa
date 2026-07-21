import 'package:flutter/material.dart';

class SplashGlowCircle extends StatelessWidget {
  final double size;
  final List<Color> colors;
  final double blurRadius;
  final double spreadRadius;
  final Alignment begin;
  final Alignment end;

  const SplashGlowCircle({
    super.key,
    required this.size,
    required this.colors,
    this.blurRadius = 72,
    this.spreadRadius = 4,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.22),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(begin: begin, end: end, colors: colors),
        ),
      ),
    );
  }
}
