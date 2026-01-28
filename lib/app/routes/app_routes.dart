import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/login_screen.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/register_screen.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:sajilo_sewa/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:sajilo_sewa/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:sajilo_sewa/features/splash/presentation/pages/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';

  
  static const String editProfile = '/edit-profile';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    main: (context) => const MainBottomNavigationBar(),

   
    editProfile: (context) => const EditProfileScreen(),
  };
}
