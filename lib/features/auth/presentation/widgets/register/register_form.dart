import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/api/api_client.dart';
import 'package:sajilo_sewa/core/widgets/my_textformfield.dart';
import '../../providers/auth_providers.dart';
import 'register_role.dart';
import 'register_role_selector.dart';
import 'profession_field.dart';
import 'terms_checkbox.dart';
import 'create_account_button.dart';
import 'social_buttons.dart';
import 'signin_link.dart';

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

  // ✅ NEW: services from backend
  bool servicesLoading = false;
  String? servicesError;
  List<Map<String, String>> services = []; // [{name, slug}]
  String? selectedServiceSlug;
  String? selectedServiceName;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

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

  String _onlyDigits10(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length <= 10) return digits;
    return digits.substring(digits.length - 10);
  }

  Future<void> _loadServices() async {
    setState(() {
      servicesLoading = true;
      servicesError = null;
    });

    try {
      final Dio dio = ApiClient.instance.dio;

      final res = await dio.get('/api/services');

      final data = res.data;

      final List items = (data is Map && data['items'] is List) ? data['items'] : [];

      final parsed = items.map<Map<String, String>>((e) {
        final m = (e as Map).cast<String, dynamic>();
        return {
          'name': (m['name'] ?? '').toString(),
          'slug': (m['slug'] ?? '').toString(),
        };
      }).where((x) => x['slug']!.trim().isNotEmpty).toList();

      setState(() {
        services = parsed;
      });
    } catch (e) {
      setState(() {
        servicesError = e.toString();
      });
    } finally {
      setState(() {
        servicesLoading = false;
      });
    }
  }

  Future<void> _openServicePicker() async {
    if (servicesLoading) {
      _snack("Loading services...");
      return;
    }
    if (servicesError != null) {
      _snack("Service load failed. Tap again after refresh.");
      return;
    }
    if (services.isEmpty) {
      _snack("No services available");
      return;
    }

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(12),
        children: services
            .map(
              (s) => ListTile(
                title: Text(s['name'] ?? ''),
                subtitle: Text(s['slug'] ?? ''),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    selectedServiceSlug = s['slug'];
                    selectedServiceName = s['name'];
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!agree) {
      _snack("Please accept the terms");
      return;
    }

    final phone10 = _onlyDigits10(phone.text.trim());
    if (phone10.length != 10) {
      _snack("Phone must be exactly 10 digits");
      return;
    }

    if (role == RegisterRole.provider) {
      if (profession.text.trim().isEmpty) {
        _snack("Profession is required for providers");
        return;
      }
      if (selectedServiceSlug == null || selectedServiceSlug!.trim().isEmpty) {
        _snack("Please select a service");
        return;
      }
    }

    await ref.read(authControllerProvider.notifier).signUp(
          fullName: fullName.text.trim(),
          email: email.text.trim(),
          phone: phone10,
          password: password.text,
          role: role.value,
          profession: role == RegisterRole.provider ? profession.text.trim() : null,
          serviceSlug: role == RegisterRole.provider ? selectedServiceSlug : null,
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
              validator: (v) =>
                  v == null || v.trim().length < 2 ? "Enter valid full name" : null,
            ),
            const SizedBox(height: 14),

            MyTextFormField(
              label: "Email",
              controller: email,
              hint: "Enter your email",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || !v.contains("@") ? "Enter valid email" : null,
            ),
            const SizedBox(height: 14),

            MyTextFormField(
              label: "Phone",
              controller: phone,
              hint: "98XXXXXXXX (10 digits)",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                final p = _onlyDigits10(v ?? '');
                if (p.length != 10) return "Phone must be exactly 10 digits";
                return null;
              },
            ),
            const SizedBox(height: 14),

            MyTextFormField(
              label: "Password",
              controller: password,
              hint: "Min 7 chars, 1 capital, 1 number, 1 special",
              icon: Icons.lock_outline,
              obscure: hidePass,
              suffix: IconButton(
                icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => hidePass = !hidePass),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Password is required";
                if (!_isStrongPassword(v)) return "Password not strong enough";
                return null;
              },
            ),
            const SizedBox(height: 14),

            MyTextFormField(
              label: "Confirm Password",
              controller: confirmPassword,
              hint: "Confirm password",
              icon: Icons.lock_outline,
              obscure: hideConfirmPass,
              suffix: IconButton(
                icon: Icon(hideConfirmPass ? Icons.visibility_off : Icons.visibility),
                onPressed: () =>
                    setState(() => hideConfirmPass = !hideConfirmPass),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Confirm password";
                if (v != password.text) return "Passwords do not match";
                return null;
              },
            ),
            const SizedBox(height: 12),

            RegisterRoleSelector(
              role: role,
              onChanged: (r) {
                setState(() {
                  role = r;
                  if (role == RegisterRole.client) {
                    profession.clear();
                    selectedServiceSlug = null;
                    selectedServiceName = null;
                  }
                });
              },
            ),

            if (role == RegisterRole.provider) ...[
              const SizedBox(height: 10),

              // ✅ Service Category selector (backend driven)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Service Category",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _openServicePicker,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedServiceName ??
                              (servicesLoading
                                  ? "Loading services..."
                                  : "Select a service"),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (servicesError != null)
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _loadServices,
                        )
                      else
                        const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),

              if (servicesError != null) ...[
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Network error. Tap refresh.",
                    style: TextStyle(color: Colors.red.shade600, fontSize: 12),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              ProfessionField(
                controller: profession,
                onTapPick: () {
                },
              ),
            ],

            const SizedBox(height: 10),
            TermsCheckbox(
              value: agree,
              onChanged: (v) => setState(() => agree = v ?? false),
            ),

            const SizedBox(height: 14),
            CreateAccountButton(
              isLoading: isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 10),
            const SocialButtons(),
            const SizedBox(height: 10),
            const SignInLink(),
          ],
        ),
      ),
    );
  }
}
