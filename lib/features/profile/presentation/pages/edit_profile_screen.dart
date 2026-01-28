import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/features/profile/presentation/utils/avatar_picker.dart';
import 'package:sajilo_sewa/features/profile/presentation/view_models/profile_view_model.dart';


class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final vm = ref.read(profileViewModelProvider.notifier);
      final st = ref.read(profileViewModelProvider);
      if (st.profile == null) {
        await vm.loadProfile();
      }
      _prefillOnce();
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _prefillOnce() {
    if (_prefilled) return;
    final profile = ref.read(profileViewModelProvider).profile;
    if (profile == null) return;

    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text = profile.lastName;
    _emailCtrl.text = profile.email;
    _phoneCtrl.text = profile.phone;

    _prefilled = true;
    setState(() {});
  }

  Future<void> _pickAvatar() async {
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

    final ok = await ref.read(profileViewModelProvider.notifier).uploadAvatar(file);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Avatar updated")),
      );
      setState(() {});
    } else {
      final err = ref.read(profileViewModelProvider).error ?? "Avatar upload failed";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await ref.read(profileViewModelProvider.notifier).updateProfile(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          // email not sent by default; add only if backend allows updating it
        );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
      Navigator.pop(context, true); // return true so ProfileScreen can refresh
    } else {
      final err = ref.read(profileViewModelProvider).error ?? "Update failed";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    final profile = state.profile;

    // Keep controllers in sync once profile arrives
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillOnce());

    final avatarUrl = profile?.avatarUrl ?? "";
    final isBusy = state.isLoading || state.isSaving;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: state.isLoading && profile == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                child: Column(
                  children: [
                    // Avatar section
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
                                  spreadRadius: 0,
                                  color: Colors.black.withOpacity(0.08),
                                  offset: const Offset(0, 8),
                                )
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
                                      loadingBuilder: (context, child, progress) {
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
                              onTap: isBusy ? null : _pickAvatar,
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
                                  color: isBusy ? Colors.grey : const Color(0xFF5B4FFF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (state.error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECEC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFC9C9)),
                        ),
                        child: Text(
                          state.error!,
                          style: const TextStyle(
                            color: Color(0xFFB00020),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                    const SizedBox(height: 14),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _fieldLabel("First Name"),
                          TextFormField(
                            controller: _firstNameCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(hint: "Enter first name"),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return "First name is required";
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          _fieldLabel("Last Name"),
                          TextFormField(
                            controller: _lastNameCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(hint: "Enter last name"),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return "Last name is required";
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          _fieldLabel("Email"),
                          TextFormField(
                            controller: _emailCtrl,
                            enabled: false, // recommended: keep email readonly
                            decoration: _inputDecoration(hint: "Email"),
                          ),
                          const SizedBox(height: 12),

                          _fieldLabel("Phone Number"),
                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            decoration: _inputDecoration(hint: "Enter phone number"),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return "Phone number is required";
                              if (v.trim().length < 7) return "Enter a valid phone number";
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isBusy ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B4FFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: state.isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}

enum _AvatarAction { gallery, camera }
