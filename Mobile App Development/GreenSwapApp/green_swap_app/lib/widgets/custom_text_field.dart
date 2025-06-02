import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final Color? fillColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final double elevation;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText = '',
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.fillColor,
    this.borderRadius = 15,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.elevation = 3,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.fillColor ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.elevation > 0 ? [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ] : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        textCapitalization: widget.textCapitalization,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
          contentPadding: widget.contentPadding,
          counterText: '',
        ),
      ),
    ).animate(target: _isFocused ? 1 : 0)
      .elevation(
        begin: 0,
        end: 5,
        curve: Curves.easeOut,
        duration: 200.ms,
      )
      .scale(
        begin: const Offset(1, 1),
        end: const Offset(1.02, 1),
        curve: Curves.easeOut,
        duration: 200.ms,
      );
  }
} 