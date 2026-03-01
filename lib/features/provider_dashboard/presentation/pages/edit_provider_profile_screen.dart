import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/utils/avatar_picker.dart';
import '../view_model/provider_profile_controller.dart';

class EditProviderProfileScreen extends StatefulWidget {
  const EditProviderProfileScreen({super.key});

  @override
  State<EditProviderProfileScreen> createState() => _EditProviderProfileScreenState();
}

class _EditProviderProfileScreenState extends State<EditProviderProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  bool _prefilled = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _prefillOnce(ProviderProfileController c) {
    if (_prefilled) return;

    final me = c.me;
    final profile = c.profile;
    if (me == null || profile == null) return;

    _firstNameCtrl.text = me.firstName;
    _lastNameCtrl.text = me.lastName;
    _priceCtrl.text = (profile.startingPrice ?? 500).toString();

    _prefilled = true;
  }

  Future<void> _changeAvatar(ProviderProfileController c) async {
    if (c.loading) return;

    final action = await showModalBottomSheet<_AvatarAction>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Change profile photo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text("Choose from gallery"),
                onTap: () => Navigator.pop(ctx, _AvatarAction.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Take a photo"),
                onTap: () => Navigator.pop(ctx, _AvatarAction.camera),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );

    if (action == null) return;

    File? file;
    if (action == _AvatarAction.gallery) {
      file = await AvatarPicker.pickFromGallery();
    } else {
      file = await AvatarPicker.pickFromCamera();
    }

    if (file == null) return;

    await c.uploadMyAvatar(file.path);
    if (!mounted) return;

    if (c.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Avatar updated")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(c.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProviderProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillOnce(c));

    final me = c.me;
    final profile = c.profile;

    if (me == null || profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profession = (me.profession ?? "").trim();
    final email = me.email ?? "";
    final phone = me.phone ?? "";
    final avatarUrl = me.avatarUrl ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          color: Colors.black.withOpacity(0.08),
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: avatarUrl.isEmpty
                          ? const Icon(Icons.person, size: 48)
                          : Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 48),
                              loadingBuilder: (ctx, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: c.loading ? null : () => _changeAvatar(c),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: c.loading ? Colors.grey : const Color(0xFF5B4FFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (c.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECEC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFC9C9)),
                ),
                child: Text(
                  c.error!,
                  style: const TextStyle(
                    color: Color(0xFFB00020),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            if (c.error != null) const SizedBox(height: 14),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField("First Name", _firstNameCtrl),
                  const SizedBox(height: 12),
                  _buildField("Last Name", _lastNameCtrl),
                  const SizedBox(height: 12),

                  _buildLockedField("Profession", profession),
                  const SizedBox(height: 12),

                  _buildLockedField("Email", email),
                  const SizedBox(height: 12),

                  _buildLockedField("Phone", phone),
                  const SizedBox(height: 12),

                  _buildField(
                    "Starting Price (Rs/hr)",
                    _priceCtrl,
                    keyboard: TextInputType.number,
                    validator: (v) {
                      final n = num.tryParse((v ?? '').trim());
                      if (n == null) return "Enter a valid price";
                      if (n <= 0) return "Price must be greater than 0";
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: c.loading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (!(_formKey.currentState?.validate() ?? false)) return;

                        await c.saveEditProfile(
                          firstName: _firstNameCtrl.text.trim(),
                          lastName: _lastNameCtrl.text.trim(),
                          startingPrice: num.tryParse(_priceCtrl.text.trim()) ?? 500,
                        );

                        if (!context.mounted) return;
                        Navigator.pop(context, true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B4FFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: c.loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator: validator ?? (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildLockedField(String label, String value) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

enum _AvatarAction { gallery, camera }