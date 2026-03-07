import 'package:flutter/material.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/onboarding/presentation/widgets/indicator.dart';
import 'package:sajilo_sewa/features/onboarding/presentation/widgets/onboard_page.dart';

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
      'title': 'Home Cleaning',
      'subtitle':
          'Professional cleaners at your doorstep. Book trusted home cleaning services in seconds.',
      'image': 'assets/images/onboard1.png',
    },
    {
      'title': 'Plumbing',
      'subtitle':
          'Experienced plumbers ready to solve leaks, repairs, and installations quickly and safely.',
      'image': 'assets/images/onboard2.png',
    },
    {
      'title': 'Contact Us',
      'subtitle':
          'Need help? Our support team is always ready to assist you with your service requests.',
      'image': 'assets/images/onboard3.png',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onNextPressed() async {
    if (currentIndex == pages.length - 1) {
      await UserSessionService.instance.setOnboardingDone(true);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _skip() async {
    await UserSessionService.instance.setOnboardingDone(true);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8FAFF),
              Color(0xFFEFF2FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skip,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
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

              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => Indicator(isActive: index == currentIndex),
                ),
              ),

              const SizedBox(height: 24),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B4FFF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      currentIndex == pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}