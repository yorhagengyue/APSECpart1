import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LeafAnimation extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;
  final double iconSize;

  const LeafAnimation({
    super.key,
    this.size = 100,
    this.color = const Color(0xFF4CAF50),
    this.icon = Icons.spa,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(0, 5),
            color: Colors.black.withAlpha(77),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(delay: 4.seconds, duration: 1.8.seconds)
    .then()
    .scale(
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.05, 1.05),
      duration: 1.seconds,
    )
    .then()
    .scale(
      begin: const Offset(1.05, 1.05),
      end: const Offset(1.0, 1.0),
      duration: 1.seconds,
    );
  }
} 