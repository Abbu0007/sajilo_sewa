import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import '../providers/auth_providers.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final TextEditingController otpController = TextEditingController();

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _verify() async {
    await ref.read(authControllerProvider.notifier).verifyEmail(
          email: widget.email,
          otp: otpController.text.trim(),
        );

    final state = ref.read(authControllerProvider);

    state.when(
      data: (v) {
        if (v == 'verified') {
          _snack("Email verified. Please login.");

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (r) => false,
          );
        }
      },
      loading: () {},
      error: (e, _) => _snack(e.toString()),
    );
  }

  Future<void> _resend() async {
    await ref.read(authControllerProvider.notifier).resendVerification(
          email: widget.email,
        );

    final state = ref.read(authControllerProvider);

    state.when(
      data: (v) {
        if (v == 'resent') {
          _snack("Verification code resent.");
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
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Icon(Icons.email_outlined, size: 80, color: Colors.blue),

            const SizedBox(height: 24),

            const Text(
              "Verify your email",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Enter the OTP sent to\n${widget.email}",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "OTP Code",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _verify,
                child: const Text("Verify Email"),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: isLoading ? null : _resend,
              child: const Text("Resend Code"),
            ),
          ],
        ),
      ),
    );
  }
}