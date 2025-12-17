import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'widgets/onboard_page.dart';
import 'widgets/indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome',
      'subtitle': 'Book your home services easily',
      'image': '', // add image path if needed
    },
    {
      'title': 'Fast & Reliable',
      'subtitle': 'Trusted service providers near you',
      'image': '',
    },
    {
      'title': 'Get Started',
      'subtitle': 'Enjoy convenient home services',
      'image': '',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (currentIndex == pages.length - 1) {
      // ✅ Go to Login (NOT Home, NOT Bottom Nav yet)
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Pages
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return OnboardPage(
                  title: pages[index]['title']!,
                  subtitle: pages[index]['subtitle']!,
                  imagePath: pages[index]['image']!,
                );
              },
            ),
          ),

          /// Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => Indicator(isActive: index == currentIndex),
            ),
          ),

          const SizedBox(height: 24),

          /// Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentIndex == pages.length - 1 ? 'Get Started' : 'Next',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
