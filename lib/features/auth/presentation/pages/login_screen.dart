import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/divider_text.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/email_field.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/password_field.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/remember_forgot_row.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/sign_in_button.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/sign_up_text.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/social_login_button.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _login() async {
    await ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    final state = ref.read(authControllerProvider);

    state.when(
      data: (role) {
        if (role == null) return;

        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        } else if (role == 'provider') {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        }
      },
      loading: () {},
      error: (e, _) => _snack(e.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [_buildHeader(), _buildForm(isLoading)]),
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
        children: const [
          SizedBox(height: 20),
          Icon(Icons.home, size: 40, color: Colors.white),
          SizedBox(height: 20),
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sign in to book your home services',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isLoading) {
    return Padding(
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

          SignInButton(onPressed: isLoading ? () {} : _login),

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
            iconColor: Color(0xFF1877F2),
          ),
          const SizedBox(height: 7),

          SocialLoginButton(
            icon: Icons.apple,
            label: 'Continue with Apple',
            onPressed: () {},
            iconColor: Color.fromARGB(255, 146, 155, 167),
          ),

          const SizedBox(height: 24),

          SignUpText(
            onSignUp: () => Navigator.pushNamed(context, AppRoutes.register),
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
