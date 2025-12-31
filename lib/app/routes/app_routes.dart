import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/login_screen.dart';
import 'package:sajilo_sewa/features/auth/presentation/pages/register_screen.dart';
import 'package:sajilo_sewa/features/auth/data/repositories/auth_repository.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/login_usecase.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:sajilo_sewa/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:sajilo_sewa/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:sajilo_sewa/features/splash/presentation/pages/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),

    onboarding: (context) => const OnboardingScreen(),

    login: (context) => ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        signUpUseCase: SignUpUseCase(AuthRepositoryImpl()),
        loginUseCase: LoginUseCase(AuthRepositoryImpl()),
      ),
      child: const LoginScreen(),
    ),

    register: (context) => ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        signUpUseCase: SignUpUseCase(AuthRepositoryImpl()),
        loginUseCase: LoginUseCase(AuthRepositoryImpl()),
      ),
      child: const RegisterScreen(),
    ),

    main: (context) => const MainBottomNavigationBar(),
  };
}
