import 'package:flutter/material.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/divider_text.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/email_field.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/password_field.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/remember_forgot_row.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/sign_in_button.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/sign_up_text.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [_buildHeader(), _buildForm()]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to book your home services',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const Text(
            'Login',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          EmailField(controller: _emailController),
          const SizedBox(height: 16),
          PasswordField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),
          RememberForgotRow(
            rememberMe: _rememberMe,
            onChanged: (val) => setState(() => _rememberMe = val ?? false),
            onForgot: () {},
          ),
          const SizedBox(height: 24),
          SignInButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.main);
            },
          ),

          const SizedBox(height: 24),
          const DividerText(),
          const SizedBox(height: 24),
          SocialLoginButton(
            icon: Icons.g_mobiledata,
            label: 'Continue with Google',
            onPressed: () {},
            iconColor: Colors.red,
          ),
          const SizedBox(height: 7),
          SocialLoginButton(
            icon: Icons.facebook,
            label: 'Continue with Facebook',
            onPressed: () {},
            iconColor: const Color(0xFF1877F2),
          ),
          const SizedBox(height: 7),
          SocialLoginButton(
            icon: Icons.apple,
            label: 'Continue with Apple',
            onPressed: () {},
            iconColor: const Color.fromARGB(255, 146, 155, 167),
          ),
          const SizedBox(height: 24),
          SignUpText(
            onSignUp: () {
              Navigator.pushNamed(context, AppRoutes.register);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
