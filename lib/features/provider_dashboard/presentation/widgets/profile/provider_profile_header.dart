import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';

class ProviderProfileHeader extends StatelessWidget {
  final String name;
  final String profession;
  final String phone;
  final String email;
  final String? avatarUrl;
  final VoidCallback onSettingsTap;

  const ProviderProfileHeader({
    super.key,
    required this.name,
    required this.profession,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.onSettingsTap,
  });

  String? _resolveAvatar(String? url) {
    final resolved = UrlUtils.normalizeMediaUrl(url);
    return resolved.isEmpty ? null : resolved;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedAvatar = _resolveAvatar(avatarUrl);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white24,
            backgroundImage:
                resolvedAvatar != null ? NetworkImage(resolvedAvatar) : null,
            child: resolvedAvatar == null
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profession,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onSettingsTap,
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
    );
  }
}