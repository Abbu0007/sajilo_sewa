import 'package:flutter/material.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      final session = UserSessionService.instance;

      if (session.isLoggedIn()) {
        final role = session.getRoleNormalized();

        if (role == 'admin') {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.adminMain,
          );
        } else if (role == 'provider') {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.providerMain,
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.main,
          );
        }
        return;
      }

      if (session.isOnboardingDone()) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B4FFF), 
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Image(
              image: AssetImage('assets/images/sajilo_sewa_logo.png'),
              width: 120,
            ),
            SizedBox(height: 18),
            Text(
              'Sajilo Sewa',
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}