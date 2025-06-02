import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum ButtonType { primary, secondary, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final double height;
  final double width;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool fullWidth;
  final double elevation;
  final bool animate;
  final bool loading;
  final double fontSize;
  final Color? outlineColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.height = 60,
    this.width = double.infinity,
    this.borderRadius = 30,
    this.color,
    this.textColor,
    this.padding,
    this.prefixIcon,
    this.suffixIcon,
    this.fullWidth = true,
    this.elevation = 0,
    this.animate = true,
    this.loading = false,
    this.fontSize = 22,
    this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = color ?? _getDefaultColor(context);
    final Color buttonTextColor = textColor ?? _getDefaultTextColor(context);
    
    Widget button = Container(
      width: fullWidth ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: buttonColor.withAlpha(77),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ] : null,
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: buttonTextColor,
          elevation: loading ? 0 : elevation,
          shadowColor: buttonColor,
          minimumSize: Size(double.infinity, height),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: type == ButtonType.outlined
                ? BorderSide(
                    color: outlineColor ?? buttonColor,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          disabledBackgroundColor: buttonColor.withAlpha(128),
          disabledForegroundColor: buttonTextColor.withAlpha(128),
        ),
        child: _buildButtonContent(buttonTextColor),
      ),
    );

    if (animate && onPressed != null) {
      return button
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
          autoPlay: false,
        )
        .shimmer(
          delay: 400.ms,
          duration: 1800.ms,
          color: buttonTextColor.withAlpha(51),
        )
        .animate(target: onPressed == null ? 0 : 1)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          curve: Curves.easeOut,
          duration: 200.ms,
        );
    }

    return button;
  }

  Widget _buildButtonContent(Color textColor) {
    if (loading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: textColor,
        ),
      );
    }

    List<Widget> children = [];

    if (prefixIcon != null) {
      children.add(prefixIcon!);
      children.add(const SizedBox(width: 8));
    }

    children.add(
      Flexible(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    if (suffixIcon != null) {
      children.add(const SizedBox(width: 8));
      children.add(suffixIcon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Color _getDefaultColor(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return const Color(0xFF7CFC7C);
      case ButtonType.secondary:
        return Colors.grey.shade200;
      case ButtonType.outlined:
      case ButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getDefaultTextColor(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return Colors.black;
      case ButtonType.secondary:
        return Colors.black87;
      case ButtonType.outlined:
      case ButtonType.text:
        return const Color(0xFF4CAF50);
    }
  }
} 