import 'package:flutter/material.dart';
import 'package:sajilo_sewa/app/theme/theme_data.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_clients_screen.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_main_screen.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_providers_screen.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/login_screen.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/register_screen.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/verify_email_screen.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/edit_profile_screen.dart';
import 'package:sajilo_sewa/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/pages/provider_dashboard_screen.dart';
import 'package:sajilo_sewa/features/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String main = '/main';
  static const String providerMain = '/provider-main';
  static const String adminMain = '/admin-main';
  static const String editProfile = '/edit-profile';
  static const String adminClients = '/admin/clients';
  static const String adminProviders = '/admin/providers';

  static Widget _fixedLight(Widget child) {
    return Theme(
      data: AppTheme.lightTheme,
      child: child,
    );
  }

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => _fixedLight(const SplashScreen()),
    onboarding: (context) => _fixedLight(const OnboardingScreen()),
    login: (context) => _fixedLight(const LoginScreen()),
    register: (context) => _fixedLight(const RegisterScreen()),
    forgotPassword: (context) => _fixedLight(const ForgotPasswordScreen()),
    main: (context) => const MainBottomNavigationBar(),
    providerMain: (context) => const ProviderDashboardScreen(),
    adminMain: (context) => _fixedLight(const AdminMainScreen()),
    adminClients: (context) => _fixedLight(const AdminClientsScreen()),
    adminProviders: (context) => _fixedLight(const AdminProvidersScreen()),

    editProfile: (context) => const EditProfileScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case verifyEmail:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => _fixedLight(VerifyEmailScreen(email: email)),
          settings: settings,
        );

      case resetPassword:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => _fixedLight(ResetPasswordScreen(email: email)),
          settings: settings,
        );

      default:
        return null;
    }
  }
}