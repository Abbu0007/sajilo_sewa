import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_providers.dart';
import '../../../../../core/services/hive/hive_service.dart';
import 'register_input.dart';
import 'register_role_selector.dart';
import 'profession_field.dart';
import 'terms_checkbox.dart';
import 'create_account_button.dart';
import 'social_buttons.dart';
import 'signin_link.dart';

enum RegisterRole { client, provider }

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final profession = TextEditingController();

  RegisterRole role = RegisterRole.client;

  bool hidePass = true;
  bool hideConfirmPass = true;
  bool agree = false;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    profession.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  bool _isStrongPassword(String value) {
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{7,}$',
    );
    return regex.hasMatch(value);
  }

  Future<void> _openProfessionPicker() async {
    final result = await HiveService.instance.getProfessions();

    result.fold((f) => _snack(f.message ?? 'Failed to load professions'), (
      items,
    ) async {
      await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (ctx) => ListView(
          padding: const EdgeInsets.all(12),
          children: items
              .map(
                (p) => ListTile(
                  title: Text(p),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => profession.text = p);
                  },
                ),
              )
              .toList(),
        ),
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!agree) {
      _snack("Please accept the terms");
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          fullName: fullName.text.trim(),
          email: email.text.trim(),
          password: password.text,
          role: role == RegisterRole.client ? 'client' : 'provider',
          profession: role == RegisterRole.provider
              ? profession.text.trim()
              : null,
        );

    final state = ref.read(authControllerProvider);

    state.when(
      data: (v) {
        if (v == 'success') {
          _snack("Account Created");
          Navigator.pop(context);
        }
      },
      loading: () {},
      error: (e, _) => _snack(e.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            RegisterInput(
              label: "Full Name",
              controller: fullName,
              hint: "Enter your full name",
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? "Please enter your name" : null,
            ),
            const SizedBox(height: 16),

            RegisterInput(
              label: "Email Address",
              controller: email,
              hint: "Enter your email",
              icon: Icons.email_outlined,
              validator: (v) {
                if (v!.isEmpty) return "Please enter your email";
                if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(v)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            RegisterInput(
              label: "Phone Number",
              controller: phone,
              hint: "+977-98XXXXXXX",
              icon: Icons.phone_outlined,
              validator: (v) {
                if (v!.isEmpty) return "Please enter your phone number";
                if (!RegExp(r"^\+977-9\d{9}$").hasMatch(v)) {
                  return "Enter a valid Nepali phone number";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            RegisterInput(
              label: "Password",
              controller: password,
              hint: "Create a strong password",
              icon: Icons.lock_outline,
              obscure: hidePass,
              suffix: GestureDetector(
                onTap: () => setState(() => hidePass = !hidePass),
                child: Icon(
                  hidePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
              validator: (v) {
                if (v!.isEmpty) return "Please enter a password";
                if (v.length < 7) {
                  return "Password must be at least 7 characters long";
                }
                if (!_isStrongPassword(v)) {
                  return "Password must contain at least one uppercase letter, one number, and one special character";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            RegisterInput(
              label: "Confirm Password",
              controller: confirmPassword,
              hint: "Confirm your password",
              icon: Icons.lock_outline,
              obscure: hideConfirmPass,
              suffix: GestureDetector(
                onTap: () => setState(() => hideConfirmPass = !hideConfirmPass),
                child: Icon(
                  hideConfirmPass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
              validator: (v) =>
                  v != password.text ? "Passwords do not match" : null,
            ),
            const SizedBox(height: 16),

            RegisterRoleSelector(
              role: role,
              onChanged: (r) => setState(() => role = r),
            ),

            if (role == RegisterRole.provider) ...[
              const SizedBox(height: 10),
              ProfessionField(
                controller: profession,
                onOpenPicker: _openProfessionPicker,
              ),
            ],

            const SizedBox(height: 16),

            TermsCheckbox(
              value: agree,
              onChanged: (v) => setState(() => agree = v),
              onTapTerms: () {},
            ),

            const SizedBox(height: 24),

            CreateAccountButton(isLoading: isLoading, onTap: _submit),

            const SizedBox(height: 24),

            const SocialButtons(),
            const SizedBox(height: 24),
            const SignInLink(),
          ],
        ),
      ),
    );
  }
}
