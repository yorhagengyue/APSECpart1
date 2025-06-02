import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _animationController.forward();
    
    // Check if user has seen onboarding
    _checkOnboardingStatus();
    
    // Navigate to appropriate screen after splash delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (_hasSeenOnboarding) {
        _navigateToLogin();
      } else {
        _navigateToOnboarding();
      }
    });
  }
  
  Future<void> _checkOnboardingStatus() async {
    // This would typically check shared preferences
    // For demo purposes, we'll assume user hasn't seen onboarding
    setState(() {
      _hasSeenOnboarding = false;
    });
  }
  
  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OnboardingPage(
          onComplete: () {
            // Set flag that user has seen onboarding
            // For a real app, you'd store this in SharedPreferences
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginEmailPage(),
              ),
            );
          },
        ),
      ),
    );
  }
  
  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginEmailPage(),
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_animationController.value * 0.2),
                  child: Opacity(
                    opacity: _animationController.value,
                    child: const Icon(
                      Icons.eco,
                      size: 100,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // App name animation
            Animate(
              effects: [
                FadeEffect(
                  delay: 500.ms,
                  duration: 1000.ms,
                ),
                SlideEffect(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                  delay: 500.ms,
                  duration: 1000.ms,
                  curve: Curves.easeOutCubic,
                ),
              ],
              child: const Text(
                'GreenSwap',
                style: TextStyle(
                  color: Color(0xFF388E3C),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Tagline animation
            Animate(
              effects: [
                FadeEffect(
                  delay: 800.ms,
                  duration: 1000.ms,
                ),
              ],
              child: const Text(
                'Keep rivers clean, love our earth',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
