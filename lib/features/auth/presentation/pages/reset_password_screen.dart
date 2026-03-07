import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import '../providers/auth_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool obscurePassword = true;

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _resetPassword() async {
    await ref.read(authControllerProvider.notifier).resetPassword(
          email: widget.email,
          otp: otpController.text.trim(),
          newPassword: newPasswordController.text,
        );

    final state = ref.read(authControllerProvider);

    state.when(
      data: (v) {
        if (v == 'password_reset') {
          _snack("Password reset successful. Please login.");

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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.password, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              "Reset your password",
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
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: "New Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _resetPassword,
                child: const Text("Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}