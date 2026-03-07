import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/email_field.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/password_field.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/remember_forgot_row.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/sign_in_button.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/login/sign_up_text.dart';
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

  bool _isEmailNotVerifiedError(String message) {
    final m = message.toLowerCase();
    return m.contains('email not verified') ||
        (m.contains('not verified') && m.contains('email'));
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();

    await ref.read(authControllerProvider.notifier).login(
          email: email,
          password: _passwordController.text,
        );

    final state = ref.read(authControllerProvider);

    state.when(
      data: (role) {
        if (role == null) return;

        final normalizedRole = role.trim().toLowerCase();

        if (normalizedRole == 'admin') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.adminMain,
            (r) => false,
          );
        } else if (normalizedRole == 'provider') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.providerMain,
            (r) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
            (r) => false,
          );
        }
      },
      loading: () {},
      error: (e, _) {
        final message = e.toString();

        if (_isEmailNotVerifiedError(message)) {
          _snack('Email not verified. Please verify your email first.');

          Navigator.pushNamed(
            context,
            AppRoutes.verifyEmail,
            arguments: email,
          );
          return;
        }

        _snack(message);
      },
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

          Image(
            image: AssetImage('assets/images/sajilo_sewa_logo.png'),
            height: 120,
          ),

          SizedBox(height: 20),

          Text(
            'Welcome to Sajilo Sewa',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          Text(
            'Book trusted home services easily',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )
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
            onForgot: () =>
                Navigator.pushNamed(context, AppRoutes.forgotPassword),
          ),

          const SizedBox(height: 24),

          SignInButton(onPressed: isLoading ? () {} : _login),

          const SizedBox(height: 24),
          const SizedBox(height: 24),

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