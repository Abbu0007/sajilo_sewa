import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/widgets/my_textformfield.dart';
import '../../providers/auth_providers.dart';
import '../../../../../core/services/hive/hive_service.dart';
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
  final phone = TextEditingController(); // ✅ store only 10 digits
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

  String _onlyDigits(String v) => v.replaceAll(RegExp(r'[^0-9]'), '');

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

    final phone10 = _onlyDigits(phone.text.trim()); // ✅ exactly 10 digits

    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          fullName: fullName.text.trim(),
          email: email.text.trim(),
          phone: phone10, // ✅ DTO expects /^\d{10}$/
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
            MyTextFormField(
              label: "Full Name",
              controller: fullName,
              hint: "Enter your full name",
              icon: Icons.person_outline,
              validator: (v) {
                final name = (v ?? '').trim();
                final parts = name
                    .split(RegExp(r'\s+'))
                    .where((e) => e.isNotEmpty)
                    .toList();

                if (parts.length < 2) return "Enter first and last name";
                if (parts.first.length < 2) {
                  return "First name must be at least 2 characters";
                }
                if (parts.sublist(1).join(' ').length < 2) {
                  return "Last name must be at least 2 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            MyTextFormField(
              label: "Email Address",
              controller: email,
              hint: "Enter your email",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Please enter your email";
                }
                if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(v.trim())) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ✅ Nepal phone field
            MyTextFormField(
              label: "Phone Number",
              controller: phone,
              hint: "98XXXXXXXX",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              prefix: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "🇳🇵  +977",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Text("|"),
                  SizedBox(width: 8),
                ],
              ),
              validator: (v) {
                final digits = _onlyDigits(v ?? '');
                if (digits.isEmpty) return "Please enter your phone number";
                if (!RegExp(r'^\d{10}$').hasMatch(digits)) {
                  return "Enter exactly 10 digits";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            MyTextFormField(
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
                if (v == null || v.isEmpty) return "Please enter a password";
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

            MyTextFormField(
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
              validator: (v) {
                if (v == null || v.isEmpty) return "Confirm your password";
                if (v != password.text) return "Passwords do not match";
                return null;
              },
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
