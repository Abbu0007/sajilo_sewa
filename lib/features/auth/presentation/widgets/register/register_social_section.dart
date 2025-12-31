import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/register/social_register_button.dart';

class RegisterSocialSection extends StatelessWidget {
  const RegisterSocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("or continue with"),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SocialRegisterButton(label: "Google"),
        const SizedBox(height: 12),
        SocialRegisterButton(label: "Apple"),
        const SizedBox(height: 12),
        SocialRegisterButton(label: "Facebook"),
        const SizedBox(height: 24),
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
    );
  }
}
