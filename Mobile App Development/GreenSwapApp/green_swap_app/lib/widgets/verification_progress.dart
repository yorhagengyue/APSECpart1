import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum VerificationStep {
  phoneInput,
  codeVerification,
  profileSetup,
  complete,
}

class VerificationProgress extends StatelessWidget {
  final VerificationStep currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final double lineHeight;
  final double circleSize;
  final bool showLabels;
  final Function(VerificationStep)? onStepTapped;

  const VerificationProgress({
    super.key,
    required this.currentStep,
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = Colors.grey,
    this.lineHeight = 3,
    this.circleSize = 24,
    this.showLabels = true,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildStep(
              VerificationStep.phoneInput, 
              'Phone', 
              Icons.phone_android,
            ),
            _buildLine(
              VerificationStep.phoneInput.index < currentStep.index,
            ),
            _buildStep(
              VerificationStep.codeVerification, 
              'Verify', 
              Icons.sms,
            ),
            _buildLine(
              VerificationStep.codeVerification.index < currentStep.index,
            ),
            _buildStep(
              VerificationStep.profileSetup, 
              'Profile', 
              Icons.person,
            ),
            _buildLine(
              VerificationStep.profileSetup.index < currentStep.index,
            ),
            _buildStep(
              VerificationStep.complete, 
              'Done', 
              Icons.check_circle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep(VerificationStep step, String label, IconData icon) {
    final bool isActive = step.index <= currentStep.index;
    final bool isCurrent = step.index == currentStep.index;
    
    Widget stepCircle = Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor.withAlpha(77),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor.withAlpha(128),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: circleSize * 0.6,
          color: isActive ? Colors.white : inactiveColor,
        ),
      ),
    );
    
    if (isCurrent) {
      stepCircle = stepCircle
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
          duration: 700.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .shimmer(
          duration: 1200.ms,
          color: Colors.white.withAlpha(77),
        );
    }
    
    return Expanded(
      child: GestureDetector(
        onTap: onStepTapped != null ? () => onStepTapped!(step) : null,
        child: Column(
          children: [
            stepCircle,
            if (showLabels) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? activeColor : inactiveColor,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      width: 30,
      height: lineHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isActive ? activeColor.withAlpha(204) : inactiveColor.withAlpha(77),
      ),
    ).animate(
      target: isActive ? 1 : 0,
    ).custom(
      duration: 600.ms,
      builder: (context, value, child) {
        return Container(
          width: 30,
          height: lineHeight,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      activeColor,
                      activeColor.withAlpha(204),
                      activeColor,
                    ],
                    stops: [0, 0.5 + (0.5 * value), 1],
                  )
                : null,
            color: isActive ? null : inactiveColor.withAlpha(77),
          ),
        );
      },
    );
  }
} 