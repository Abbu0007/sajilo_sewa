import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/view_model/provider_profile_controller.dart';


class EditProviderProfileScreen extends StatefulWidget {
  final ProviderProfileController controller;

  const EditProviderProfileScreen({super.key, required this.controller});

  @override
  State<EditProviderProfileScreen> createState() => _EditProviderProfileScreenState();
}

class _EditProviderProfileScreenState extends State<EditProviderProfileScreen> {
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  late final TextEditingController profession;
  late final TextEditingController startingPrice;

  @override
  void initState() {
    super.initState();
    final me = widget.controller.me;
    final p = widget.controller.profile;

    firstName = TextEditingController(text: me?.firstName ?? "");
    lastName = TextEditingController(text: me?.lastName ?? "");
    profession = TextEditingController(text: p?.profession ?? "");
    startingPrice = TextEditingController(text: (p?.startingPrice ?? 0).toString());
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    profession.dispose();
    startingPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Full UI later — for now just minimal form for wiring
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Provider Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: firstName, decoration: const InputDecoration(labelText: "First Name")),
            const SizedBox(height: 10),
            TextField(controller: lastName, decoration: const InputDecoration(labelText: "Last Name")),
            const SizedBox(height: 10),
            TextField(controller: profession, decoration: const InputDecoration(labelText: "Profession")),
            const SizedBox(height: 10),
            TextField(
              controller: startingPrice,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Starting Price (Rs.)"),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () async {
                // NOTE: updating first/last name needs /users/me PATCH which we will add later in provider layer UI step.
                // For now we are wiring provider profile update (profession/startingPrice).
                final price = num.tryParse(startingPrice.text.trim());

                await widget.controller.saveProfile(
                  profession: profession.text.trim(),
                  startingPrice: price,
                );

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}