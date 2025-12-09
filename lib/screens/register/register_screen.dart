import 'package:flutter/material.dart';
import 'widgets/register_header.dart';
import 'widgets/register_form.dart';

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
