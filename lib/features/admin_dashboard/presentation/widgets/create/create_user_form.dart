import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_service_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_avatar_picker.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_card_shell.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_role_profession_row.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_submit_button.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_text_field.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_user_form_result.dart';

class CreateUserForm extends StatefulWidget {
  final bool isLoading;
  final void Function(CreateUserFormResult result) onSubmit;

  // ✅ NEW
  final List<AdminServiceEntity> services;

  const CreateUserForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.services,
  });

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _profession = TextEditingController();
  final _password = TextEditingController();

  String _role = 'client';
  String? _serviceSlug; 
  XFile? _avatarFile;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _profession.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _isProvider => _role.trim().toLowerCase() == 'provider';

  Future<void> _pickCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file == null) return;
    setState(() => _avatarFile = file);
  }

  Future<void> _pickGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;
    setState(() => _avatarFile = file);
  }

  void _clearAvatar() => setState(() => _avatarFile = null);

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final fullName = _fullName.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();
    final password = _password.text;

    final profession = _isProvider ? _profession.text.trim() : '';
    final serviceSlug = _isProvider ? (_serviceSlug ?? '').trim() : '';

    widget.onSubmit(
      CreateUserFormResult(
        fullName: fullName,
        email: email,
        phone: phone,
        role: _role,
        profession: _isProvider ? profession : null,
        serviceSlug: _isProvider ? serviceSlug : null, // ✅ NEW
        password: password,
        avatarFile: _avatarFile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CreateCardShell(
        child: Column(
          children: [
            CreateAvatarPicker(
              fullName: _fullName.text,
              avatarFile: _avatarFile,
              onPickCamera: _pickCamera,
              onPickGallery: _pickGallery,
              onClear: _clearAvatar,
            ),
            const SizedBox(height: 14),

            CreateTextField(
              controller: _fullName,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
            ),
            const SizedBox(height: 12),

            CreateTextField(
              controller: _phone,
              label: 'Phone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
            ),
            const SizedBox(height: 12),

            CreateTextField(
              controller: _email,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 12),

            CreateTextField(
              controller: _password,
              label: 'Password',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (v) {
                final value = (v ?? '');
                if (value.trim().isEmpty) return 'Password is required';
                if (value.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 12),

            CreateRoleProfessionRow(
              role: _role,
              onRoleChanged: (v) {
                setState(() {
                  _role = v;
                  if (!_isProvider) {
                    _profession.text = '';
                    _serviceSlug = null; // ✅ clear service when not provider
                  }
                });
              },
              professionController: _profession,

              // ✅ NEW
              services: widget.services,
              selectedServiceSlug: _serviceSlug,
              onServiceChanged: (slug) => setState(() => _serviceSlug = slug),
            ),

            const SizedBox(height: 18),

            CreateSubmitButton(
              isLoading: widget.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}