import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingPage({
    super.key,
    required this.onComplete,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingScreenData> _pages = [
    OnboardingScreenData(
      title: 'Welcome to GreenSwap',
      description: 'Connect with plant enthusiasts, swap plants and contribute to a greener planet.',
      image: 'assets/images/onboarding/nature.jpg',
      backgroundColor: const Color(0xFF388E3C),
      isDark: true,
    ),
    OnboardingScreenData(
      title: 'Discover Plants',
      description: 'Browse through thousands of plants shared by the community and find your next green companion.',
      image: 'assets/images/onboarding/onboarding2.png',
      backgroundColor: const Color(0xFF4CAF50),
      isDark: true,
    ),
    OnboardingScreenData(
      title: 'Swap & Share',
      description: 'Exchange plants with enthusiasts nearby or share growing tips with the global community.',
      image: 'assets/images/onboarding/onboarding3.png',
      backgroundColor: const Color(0xFF8BC34A),
      isDark: true,
    ),
    OnboardingScreenData(
      title: 'Start Your Journey',
      description: 'Join us today and be part of a movement that makes the world greener one plant at a time.',
      image: 'assets/images/onboarding/onboarding4.png',
      backgroundColor: const Color(0xFFE8F5E9),
      isDark: false,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _goToPrevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background and page content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              final isDark = page.isDark;
              
              return _buildPage(
                page.title,
                page.description,
                page.image,
                page.backgroundColor,
                isDark,
              );
            },
          ),
          
          // Skip button
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: widget.onComplete,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: _currentPage == _pages.length - 1 ? Colors.black54 : Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          // Logo
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                Icon(
                  Icons.eco,
                  color: _currentPage == _pages.length - 1 ? const Color(0xFF4CAF50) : Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'GreenSwap',
                  style: TextStyle(
                    color: _currentPage == _pages.length - 1 ? Colors.black87 : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom buttons and page indicator
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : (_pages[_currentPage].isDark
                                ? Colors.grey.withAlpha(77)
                                : Colors.white.withAlpha(77)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Prev button (only show after first page)
                    if (_currentPage > 0)
                      CustomButton(
                        text: 'Prev',
                        type: ButtonType.outlined,
                        textColor: _currentPage == _pages.length - 1 ? Colors.black54 : Colors.white,
                        onPressed: _goToPrevPage,
                        width: 120,
                        fullWidth: false,
                        height: 50,
                      )
                    else
                      const SizedBox(width: 120),
                    
                    // Next or Get Started button
                    CustomButton(
                      text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      onPressed: _goToNextPage,
                      color: _currentPage == _pages.length - 1 
                        ? const Color(0xFF4CAF50) 
                        : const Color(0xFFB4E082),
                      textColor: Colors.black87,
                      width: 160,
                      fullWidth: false,
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    String title,
    String description,
    String imagePath,
    Color backgroundColor,
    bool isDark,
  ) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Optional image
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOut),
              ),

              // Content with text
              Animate(
                effects: [
                  FadeEffect(duration: 600.ms, delay: 200.ms),
                  SlideEffect(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                    duration: 600.ms,
                    delay: 200.ms,
                  ),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark 
                          ? const Color(0xE6FFFFFF)
                          : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark 
                          ? const Color(0xB3FFFFFF)
                          : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingScreenData {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;
  final bool isDark;
  
  const OnboardingScreenData({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
    required this.isDark,
  });
} 