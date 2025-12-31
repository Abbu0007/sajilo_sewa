import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/user_entity.dart';
import '../../view_model/auth_view_model.dart';
import 'register_role_selector.dart';
import 'register_text_field.dart';
import 'service_input_field.dart';
import 'register_terms_checkbox.dart';
import 'register_submit_button.dart';
import 'register_social_section.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final service = TextEditingController();

  String userType = 'client';
  bool agree = false;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            RegisterRoleSelector(
              value: userType,
              onChanged: (v) {
                setState(() {
                  userType = v;
                  service.clear();
                });
              },
            ),

            // FULL NAME
            RegisterTextField(
              label: "Full Name",
              hint: "Enter your full name",
              controller: fullName,
              icon: Icons.person_outline,
              validator: (v) =>
                  v == null || v.isEmpty ? "Please enter your name" : null,
            ),

            // EMAIL
            RegisterTextField(
              label: "Email Address",
              hint: "example@email.com",
              controller: email,
              icon: Icons.email_outlined,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Please enter your email";
                }
                if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(v)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),

            // PHONE
            RegisterTextField(
              label: "Phone Number",
              hint: "98XXXXXXXX",
              controller: phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Please enter phone number";
                }
                if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                  return "Phone number must be exactly 10 digits";
                }
                return null;
              },
            ),

            if (userType == 'provider') ServiceInputField(controller: service),

            // PASSWORD
            RegisterTextField(
              label: "Password",
              hint: "Enter your password",
              controller: password,
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Please enter password";
                }
                if (!RegExp(
                  r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{7,}$',
                ).hasMatch(v)) {
                  return "Password must have 7+ chars, 1 capital, 1 number & 1 symbol";
                }
                return null;
              },
            ),

            // CONFIRM PASSWORD
            RegisterTextField(
              label: "Confirm Password",
              hint: "Re-enter your password",
              controller: confirmPassword,
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) =>
                  v != password.text ? "Passwords do not match" : null,
            ),

            RegisterTermsCheckbox(
              value: agree,
              onChanged: (v) => setState(() => agree = v),
            ),

            RegisterSubmitButton(onPressed: () => _submit(context)),

            const RegisterSocialSection(),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (!agree) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please accept the terms")));
      return;
    }

    final user = UserEntity(
      fullName: fullName.text,
      email: email.text,
      phone: phone.text,
      password: password.text,
      userType: userType,
      service: userType == 'provider' ? service.text : null,
    );

    final result = await context.read<AuthViewModel>().signUp(user);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );
        Navigator.pop(context);
      },
    );
  }
}
