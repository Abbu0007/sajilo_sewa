import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';

class AdminUserEditResult {
  final String fullName;
  final XFile? pickedAvatar;

  const AdminUserEditResult({
    required this.fullName,
    this.pickedAvatar,
  });
}

class AdminUserEditForm extends StatefulWidget {
  final AdminUserEntity user;
  final void Function(AdminUserEditResult result) onSave;

  const AdminUserEditForm({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<AdminUserEditForm> createState() => _AdminUserEditFormState();
}

class _AdminUserEditFormState extends State<AdminUserEditForm> {
  late final TextEditingController _name;

  XFile? _pickedAvatar;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  bool get _isProvider => widget.user.role.trim().toLowerCase() == 'provider';

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.fullName);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;
    setState(() => _pickedAvatar = file);
  }

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file == null) return;
    setState(() => _pickedAvatar = file);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    widget.onSave(
      AdminUserEditResult(
        fullName: _name.text.trim(),
        pickedAvatar: _pickedAvatar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final networkAvatar = (widget.user.avatarUrl ?? '').trim();
    final showNetworkAvatar = networkAvatar.isNotEmpty && _pickedAvatar == null;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _CoverHeader(
            fullName: widget.user.fullName,
            role: widget.user.role,
            email: widget.user.email,
            phone: widget.user.phone,
            profession: widget.user.profession,
            serviceSlug: widget.user.serviceSlug,
            isProvider: _isProvider,
            picked: _pickedAvatar,
            showNetwork: showNetworkAvatar,
            networkUrl: networkAvatar,
            onCamera: _pickFromCamera,
            onGallery: _pickFromGallery,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
              color: scheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.06),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit Details',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 14),
                _LockedField(
                  icon: Icons.badge_outlined,
                  label: 'Role',
                  value: widget.user.role,
                ),
                const SizedBox(height: 12),
                _LockedField(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: widget.user.email,
                ),
                const SizedBox(height: 12),
                _LockedField(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: widget.user.phone,
                ),
                if (_isProvider) ...[
                  const SizedBox(height: 12),
                  _LockedField(
                    icon: Icons.work_outline,
                    label: 'Profession',
                    value: (widget.user.profession ?? '').trim().isEmpty
                        ? '—'
                        : widget.user.profession!.trim(),
                  ),
                  const SizedBox(height: 12),
                  _LockedField(
                    icon: Icons.miscellaneous_services_outlined,
                    label: 'Service Slug',
                    value: (widget.user.serviceSlug ?? '').trim().isEmpty
                        ? '—'
                        : widget.user.serviceSlug!.trim(),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverHeader extends StatelessWidget {
  final String fullName;
  final String role;
  final String email;
  final String phone;
  final String? profession;
  final String? serviceSlug;
  final bool isProvider;

  final XFile? picked;
  final bool showNetwork;
  final String networkUrl;

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _CoverHeader({
    required this.fullName,
    required this.role,
    required this.email,
    required this.phone,
    required this.profession,
    required this.serviceSlug,
    required this.isProvider,
    required this.picked,
    required this.showNetwork,
    required this.networkUrl,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    ImageProvider? img;
    if (picked != null) {
      img = FileImage(File(picked!.path));
    } else if (showNetwork) {
      img = NetworkImage(networkUrl);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: scheme.primary.withOpacity(0.10),
                    child: img != null
                        ? Image(image: img, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 44,
                                color: scheme.primary,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        _SmallIconBtn(icon: Icons.camera_alt_outlined, onTap: onCamera),
                        const SizedBox(width: 8),
                        _SmallIconBtn(icon: Icons.photo_library_outlined, onTap: onGallery),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _RoleChip(role: role),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: phone),
                  if (isProvider) ...[
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.miscellaneous_services_outlined,
                      label: 'Service',
                      value: (serviceSlug ?? '').trim().isEmpty ? '—' : serviceSlug!.trim(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LockedField({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: muted),
          const SizedBox(width: 10),
          SizedBox(
            width: 92,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: muted)),
          ),
          const Icon(Icons.lock_outline, size: 16, color: Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    final r = role.trim().toLowerCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Text(
        r,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallIconBtn({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.16),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade700;

    return Row(
      children: [
        Icon(icon, size: 18, color: muted),
        const SizedBox(width: 10),
        SizedBox(
          width: 62,
          child: Text(label, style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}