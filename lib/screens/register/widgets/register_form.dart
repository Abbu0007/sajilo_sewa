import 'package:flutter/material.dart';
import 'social_register_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _hidePass = true;
  bool _hideConfirmPass = true;
  bool _agree = false;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FULL NAME ----------------------------
            const Text(
              "Full Name",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildInput(
              controller: _fullName,
              hint: "Enter your full name",
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? "Please enter your name" : null,
            ),
            const SizedBox(height: 16),

            // EMAIL ----------------------------
            const Text(
              "Email Address",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildInput(
              controller: _email,
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

            // PHONE ----------------------------
            const Text(
              "Phone Number",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildInput(
              controller: _phone,
              hint: "+977-98XXXXXXX",
              icon: Icons.phone_outlined,
              validator: (v) =>
                  v!.isEmpty ? "Please enter your phone number" : null,
            ),
            const SizedBox(height: 16),

            // PASSWORD ----------------------------
            const Text(
              "Password",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildInput(
              controller: _password,
              hint: "Create a strong password",
              icon: Icons.lock_outline,
              obscure: _hidePass,
              suffix: GestureDetector(
                onTap: () => setState(() => _hidePass = !_hidePass),
                child: Icon(
                  _hidePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
              validator: (v) {
                if (v!.isEmpty) return "Enter password";
                if (v.length < 6) return "Min 6 characters";
                return null;
              },
            ),
            const SizedBox(height: 16),

            // CONFIRM PASSWORD ----------------------------
            const Text(
              "Confirm Password",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildInput(
              controller: _confirmPassword,
              hint: "Confirm your password",
              icon: Icons.lock_outline,
              obscure: _hideConfirmPass,
              suffix: GestureDetector(
                onTap: () =>
                    setState(() => _hideConfirmPass = !_hideConfirmPass),
                child: Icon(
                  _hideConfirmPass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
              validator: (v) =>
                  v != _password.text ? "Passwords do not match" : null,
            ),
            const SizedBox(height: 16),

            // TERMS CHECKBOX ----------------------------
            Row(
              children: [
                Checkbox(
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v!),
                  activeColor: const Color(0xFF5B4FFF),
                ),
                const Text("Agree to "),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Terms of Service",
                    style: TextStyle(
                      color: Color(0xFF5B4FFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // CREATE ACCOUNT BUTTON ----------------------------
            _buildSubmitButton(),

            const SizedBox(height: 24),

            // DIVIDER ----------------------------
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "or continue with",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 16),

            // SOCIAL BUTTONS ----------------------------
            SocialRegisterButton(label: "Google"),
            const SizedBox(height: 12),
            SocialRegisterButton(label: "Apple"),
            const SizedBox(height: 12),
            SocialRegisterButton(label: "Facebook"),

            const SizedBox(height: 24),

            // SIGN IN LINK ----------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color(0xFF5B4FFF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------- INPUT FIELD -----------------------
  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    Widget? suffix,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ---------------- BUTTON -----------------------
  Widget _buildSubmitButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B4FFF), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (_formKey.currentState!.validate()) {
              if (!_agree) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please accept the terms")),
                );
                return;
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Account Created")));
            }
          },
          child: const Center(
            child: Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
