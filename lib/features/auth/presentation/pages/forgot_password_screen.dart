import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _sendOtp() async {
    final email = emailController.text.trim();

    await ref.read(authControllerProvider.notifier).forgotPassword(
          email: email,
        );

    final state = ref.read(authControllerProvider);

    state.when(
      data: (v) {
        if (v == 'otp_sent') {
          _snack("Reset code sent. Please check your email.");

          Navigator.pushNamed(
            context,
            AppRoutes.resetPassword,
            arguments: email,
          );
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
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.lock_reset, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              "Forgot your password?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your email and we will send you a reset code.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _sendOtp,
                child: const Text("Send Reset Code"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}