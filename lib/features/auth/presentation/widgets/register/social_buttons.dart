import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/auth/presentation/widgets/register/social_register_button.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
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
        SizedBox(height: 16),
        SocialRegisterButton(label: "Google"),
        SizedBox(height: 12),
        SocialRegisterButton(label: "Apple"),
        SizedBox(height: 12),
        SocialRegisterButton(label: "Facebook"),
      ],
    );
  }
}
