import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

enum BubblePosition { left, right, top, bottom }

class SpeechBubble extends StatelessWidget {
  final String text;
  final double width;
  final BubblePosition position;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool animate;
  final int animationDuration;
  final bool wave;

  const SpeechBubble({
    super.key,
    required this.text,
    this.width = 150,
    this.position = BubblePosition.left,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.animate = true,
    this.animationDuration = 1200,
    this.wave = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor.withAlpha(204),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildText(),
    );
  }

  Widget _buildText() {
    if (!animate) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      );
    }

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      textAlign: TextAlign.center,
      child: AnimatedTextKit(
        animatedTexts: [
          wave 
              ? WavyAnimatedText(
                  text,
                  speed: Duration(milliseconds: animationDuration ~/ text.length),
                ) 
              : TypewriterAnimatedText(
                  text,
                  speed: Duration(milliseconds: animationDuration ~/ text.length),
                ),
        ],
        isRepeatingAnimation: false,
        totalRepeatCount: 1,
      ),
    );
  }
} 