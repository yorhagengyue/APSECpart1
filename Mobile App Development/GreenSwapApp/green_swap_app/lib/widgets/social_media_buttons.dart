import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialMediaButtons extends StatelessWidget {
  final Function? onGooglePressed;
  final Function? onFacebookPressed;
  final Function? onTwitterPressed;
  final double size;
  final double spacing;
  final bool showLabels;
  final MainAxisAlignment alignment;

  const SocialMediaButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onTwitterPressed,
    this.size = 50,
    this.spacing = 15,
    this.showLabels = false,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabels)
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              'Or continue with',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: alignment,
          children: [
            _buildSocialButton(
              icon: const Text(
                "G",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              onPressed: () async {
                if (onGooglePressed != null) {
                  onGooglePressed!();
                } else {
                  try {
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    final result = await googleSignIn.signIn();
                    if (result == null) {
                      // User canceled sign-in
                    }
                  } catch (e) {
                    // Handle error
                  }
                }
              },
            ),
            SizedBox(width: spacing),
            _buildSocialButton(
              icon: Icon(
                Icons.facebook,
                color: Colors.white,
                size: size * 0.5,
              ),
              backgroundColor: const Color(0xFF1877F2),
              onPressed: () {
                if (onFacebookPressed != null) {
                  onFacebookPressed!();
                }
              },
            ),
            SizedBox(width: spacing),
            _buildSocialButton(
              icon: Icon(
                Icons.telegram,
                color: Colors.white,
                size: size * 0.5,
              ),
              backgroundColor: const Color(0xFF1DA1F2),
              onPressed: () {
                if (onTwitterPressed != null) {
                  onTwitterPressed!();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: const Offset(0, 3),
              color: Colors.black.withAlpha(38),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    )
    .animate()
    .scale(
      begin: const Offset(1, 1),
      end: const Offset(0.9, 0.9),
      duration: 100.ms,
      curve: Curves.easeInOut,
    )
    .then()
    .scale(
      begin: const Offset(0.9, 0.9),
      end: const Offset(1, 1),
      duration: 200.ms,
      curve: Curves.elasticOut,
    );
  }
} 