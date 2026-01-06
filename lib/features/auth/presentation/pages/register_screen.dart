import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/register/register_form.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/register/register_header.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [RegisterHeader(), RegisterForm()]),
      ),
    );
  }
}
