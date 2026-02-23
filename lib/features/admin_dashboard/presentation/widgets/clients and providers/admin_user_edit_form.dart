import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';

class AdminUserEditResult {
  final String fullName;
  final String phone;
  final String role; // client/provider/admin
  final String? profession;
  final XFile? pickedAvatar;
  final bool removeAvatar;

  const AdminUserEditResult({
    required this.fullName,
    required this.phone,
    required this.role,
    this.profession,
    this.pickedAvatar,
    required this.removeAvatar,
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
  late final TextEditingController _profession;

  String _role = 'client';
  XFile? _pickedAvatar;
  bool _removeAvatar = false;

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.fullName);
    _profession = TextEditingController(text: widget.user.profession ?? '');
    _role = widget.user.role.trim().toLowerCase().isEmpty
        ? 'client'
        : widget.user.role.trim().toLowerCase();
  }

  @override
  void dispose() {
    _name.dispose();
    _profession.dispose();
    super.dispose();
  }

  bool get _isProvider => _role == 'provider';

  Future<void> _pickFromGallery() async {
    final file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;
    setState(() {
      _pickedAvatar = file;
      _removeAvatar = false;
    });
  }

  Future<void> _pickFromCamera() async {
    final file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file == null) return;
    setState(() {
      _pickedAvatar = file;
      _removeAvatar = false;
    });
  }

  void _removeCurrentAvatar() {
    setState(() {
      _pickedAvatar = null;
      _removeAvatar = true;
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final fullName = _name.text.trim();
    final phone = widget.user.phone;
    final profession = _isProvider ? _profession.text.trim() : '';

    if (_isProvider && profession.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profession is required for service provider')),
      );
      return;
    }

    widget.onSave(
      AdminUserEditResult(
        fullName: fullName,
        phone: phone,
        role: _role,
        profession: _isProvider ? profession : null,
        pickedAvatar: _pickedAvatar,
        removeAvatar: _removeAvatar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final networkAvatar = (widget.user.avatarUrl ?? '').trim();
    final showNetworkAvatar =
        networkAvatar.isNotEmpty && !_removeAvatar && _pickedAvatar == null;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _CoverHeader(
            fullName: widget.user.fullName,
            role: _role,
            email: widget.user.email,
            phone: widget.user.phone,
            picked: _pickedAvatar,
            showNetwork: showNetworkAvatar,
            networkUrl: networkAvatar,
            onCamera: _pickFromCamera,
            onGallery: _pickFromGallery,
            onRemoveAvatar: _removeCurrentAvatar,
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
                const Text(
                  'Edit Details',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
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
                const SizedBox(height: 12),

                TextFormField(
                  initialValue: widget.user.phone,
                  enabled: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                    helperText: 'Phone number cannot be changed',
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'client', child: Text('Client')),
                    DropdownMenuItem(value: 'provider', child: Text('Service Provider')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _role = v;
                      if (!_isProvider) _profession.text = '';
                    });
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _profession,
                  enabled: _isProvider,
                  decoration: InputDecoration(
                    labelText: 'Profession (provider only)',
                    prefixIcon: const Icon(Icons.work_outline),
                    hintText:
                        _isProvider ? 'e.g. Plumber, Electrician' : 'Disabled for client/admin',
                  ),
                ),

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
                        style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),
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

  final XFile? picked;
  final bool showNetwork;
  final String networkUrl;

  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemoveAvatar;

  const _CoverHeader({
    required this.fullName,
    required this.role,
    required this.email,
    required this.phone,
    required this.picked,
    required this.showNetwork,
    required this.networkUrl,
    required this.onCamera,
    required this.onGallery,
    required this.onRemoveAvatar,
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
                        colors: [
                          Colors.transparent,
                          Color(0x99000000),
                        ],
                      ),
                    ),
                  ),

                  
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        _SmallIconBtn(
                          icon: Icons.camera_alt_outlined,
                          onTap: onCamera,
                        ),
                        const SizedBox(width: 8),
                        _SmallIconBtn(
                          icon: Icons.photo_library_outlined,
                          onTap: onGallery,
                        ),
                        const SizedBox(width: 8),
                        _SmallIconBtn(
                          icon: Icons.delete_outline,
                          onTap: onRemoveAvatar,
                          isDanger: true,
                        ),
                      ],
                    ),
                  ),

                  // bottom-left name + role chip
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

            // details strip
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: phone),
                ],
              ),
            ),
          ],
        ),
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
    final label = (r == 'provider')
        ? 'provider'
        : (r == 'admin')
            ? 'admin'
            : 'client';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDanger;

  const _SmallIconBtn({
    required this.icon,
    required this.onTap,
    this.isDanger = false,
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
          child: Icon(
            icon,
            size: 18,
            color: isDanger ? const Color(0xFFFFCDD2) : Colors.white,
          ),
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
          child: Text(
            label,
            style: TextStyle(color: muted, fontWeight: FontWeight.w700),
          ),
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
