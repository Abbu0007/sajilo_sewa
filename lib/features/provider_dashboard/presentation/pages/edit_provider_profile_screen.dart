import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/utils/avatar_picker.dart';
import '../view_model/provider_profile_provider.dart';
import '../view_model/provider_profile_state.dart';

class EditProviderProfileScreen extends ConsumerStatefulWidget {
  const EditProviderProfileScreen({super.key});

  @override
  ConsumerState<EditProviderProfileScreen> createState() =>
      _EditProviderProfileScreenState();
}

class _EditProviderProfileScreenState
    extends ConsumerState<EditProviderProfileScreen> {
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

  void _prefillOnce(ProviderProfileState state) {
    if (_prefilled) return;

    final me = state.me;
    final profile = state.profile;
    if (me == null || profile == null) return;

    _firstNameCtrl.text = me.firstName;
    _lastNameCtrl.text = me.lastName;
    _priceCtrl.text = (profile.startingPrice ?? 500).toString();

    _prefilled = true;
  }

  Future<void> _changeAvatar() async {
    final currentState = ref.read(providerProfileProvider);
    if (currentState.loading) return;

    final action = await showModalBottomSheet<_AvatarAction>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).cardColor,
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

    final ok =
        await ref.read(providerProfileProvider.notifier).uploadMyAvatar(file.path);

    if (!mounted) return;

    final state = ref.read(providerProfileProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? "Avatar updated" : (state.error ?? "Failed to update avatar"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefillOnce(state);
    });

    final me = state.me;
    final profile = state.profile;

    if (me == null || profile == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final profession = (me.profession ?? "").trim();
    final email = me.email ?? "";
    final phone = me.phone ?? "";
    final avatarUrl = UrlUtils.normalizeMediaUrl(me.avatarUrl);

    final pageBg = Theme.of(context).scaffoldBackgroundColor;
    final appBarBg = isDark ? const Color(0xFF161A22) : Colors.white;
    final avatarShellBg =
        isDark ? const Color(0xFF1B2230) : Colors.grey.withOpacity(0.2);
    final avatarBorder = isDark ? const Color(0xFF2A3140) : Colors.white;
    final cameraBg = isDark ? const Color(0xFF161A22) : Colors.white;
    final cameraBorder =
        isDark ? const Color(0xFF2A3140) : Colors.grey.shade200;
    final errorBg = isDark ? const Color(0xFF2A1517) : const Color(0xFFFFECEC);
    final errorBorder =
        isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFFC9C9);
    final errorText =
        isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB00020);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: appBarBg,
        surfaceTintColor: appBarBg,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarShellBg,
                      border: Border.all(color: avatarBorder, width: 3),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          color: Colors.black.withOpacity(isDark ? 0.18 : 0.08),
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
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.person, size: 48),
                              loadingBuilder: (ctx, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
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
                      onTap: state.loading ? null : _changeAvatar,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: cameraBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: cameraBorder),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color:
                              state.loading ? Colors.grey : const Color(0xFF5B4FFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: errorBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: errorBorder),
                ),
                child: Text(
                  state.error!,
                  style: TextStyle(
                    color: errorText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (state.error != null) const SizedBox(height: 14),
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
                onPressed: state.loading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        final ok = await ref
                            .read(providerProfileProvider.notifier)
                            .saveEditProfile(
                              firstName: _firstNameCtrl.text.trim(),
                              lastName: _lastNameCtrl.text.trim(),
                              startingPrice:
                                  num.tryParse(_priceCtrl.text.trim()) ?? 500,
                            );

                        if (!mounted) return;

                        if (ok) {
                          Navigator.pop(context, true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B4FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: state.loading
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
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF161A22) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A3140) : Colors.grey.shade200;

    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator: validator ??
          (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5B4FFF), width: 1.4),
        ),
      ),
    );
  }

  Widget _buildLockedField(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor =
        isDark ? const Color(0xFF1B2230) : Colors.grey.shade200;
    final borderColor =
        isDark ? const Color(0xFF2A3140) : Colors.grey.shade300;
    final iconColor =
        isDark ? const Color(0xFF9CA3AF) : null;

    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fillColor,
        prefixIcon: Icon(Icons.lock_outline, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}

enum _AvatarAction { gallery, camera }