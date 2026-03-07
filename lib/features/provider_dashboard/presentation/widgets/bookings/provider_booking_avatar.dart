import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';

class ProviderBookingAvatar extends StatelessWidget {
  final String avatarUrl;
  final String name;

  const ProviderBookingAvatar({
    super.key,
    required this.avatarUrl,
    required this.name,
  });

  String _initials() {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "U";
    final parts =
        trimmed.split(RegExp(r"\s+")).where((e) => e.isNotEmpty).toList();
    final i1 = parts.isNotEmpty ? parts[0][0] : "U";
    final i2 = parts.length > 1 ? parts[1][0] : "";
    return ("$i1$i2").toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedAvatar = UrlUtils.normalizeMediaUrl(avatarUrl);
    final hasAvatar = resolvedAvatar.trim().isNotEmpty;
    final initials = _initials();

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 56,
        width: 56,
        color: const Color(0xFFF3F4F6),
        child: hasAvatar
            ? Image.network(
                resolvedAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
      ),
    );
  }
}