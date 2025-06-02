import 'package:flutter/material.dart';

enum GradientDirection {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft,
  diagonal,
  radial,
}

class GradientOverlay extends StatelessWidget {
  final Widget? child;
  final List<Color> colors;
  final List<double>? stops;
  final GradientDirection direction;
  final double opacity;
  final BlendMode blendMode;
  final BorderRadius? borderRadius;

  const GradientOverlay({
    super.key,
    this.child,
    required this.colors,
    this.stops,
    this.direction = GradientDirection.topToBottom,
    this.opacity = 1.0,
    this.blendMode = BlendMode.srcOver,
    this.borderRadius,
  });

  /// Creates a dark gradient overlay (transparent to black)
  factory GradientOverlay.dark({
    Key? key,
    Widget? child,
    GradientDirection direction = GradientDirection.bottomToTop,
    double opacity = 0.7,
    BorderRadius? borderRadius,
  }) {
    return GradientOverlay(
      key: key,
      colors: [
        Colors.transparent,
        Colors.black.withAlpha((opacity * 255).round()),
      ],
      direction: direction,
      borderRadius: borderRadius,
      child: child,
    );
  }

  /// Creates a light gradient overlay (transparent to white)
  factory GradientOverlay.light({
    Key? key,
    Widget? child,
    GradientDirection direction = GradientDirection.topToBottom,
    double opacity = 0.7,
    BorderRadius? borderRadius,
  }) {
    return GradientOverlay(
      key: key,
      colors: [
        Colors.transparent,
        Colors.white.withAlpha((opacity * 255).round()),
      ],
      direction: direction,
      borderRadius: borderRadius,
      child: child,
    );
  }

  /// Creates a green-themed gradient overlay for the app
  factory GradientOverlay.greenTheme({
    Key? key,
    Widget? child,
    GradientDirection direction = GradientDirection.diagonal,
    double opacity = 0.85,
    BorderRadius? borderRadius,
  }) {
    return GradientOverlay(
      key: key,
      colors: [
        const Color(0xFF4CAF50).withAlpha((opacity * 255).round()),
        const Color(0xFF8BC34A).withAlpha((opacity * 255).round()),
        const Color(0xFF4CAF50).withAlpha((opacity * 0.7 * 255).round()),
      ],
      direction: direction,
      borderRadius: borderRadius,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          if (child != null) child!,
          Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                gradient: _buildGradient(),
                borderRadius: borderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Gradient _buildGradient() {
    switch (direction) {
      case GradientDirection.topToBottom:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: stops,
        );
      case GradientDirection.bottomToTop:
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: colors,
          stops: stops,
        );
      case GradientDirection.leftToRight:
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
          stops: stops,
        );
      case GradientDirection.rightToLeft:
        return LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: colors,
          stops: stops,
        );
      case GradientDirection.diagonal:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: stops,
        );
      case GradientDirection.radial:
        return RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: colors,
          stops: stops,
        );
    }
  }
} 