import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';

class ClientUserCard extends StatelessWidget {
  final AdminUserEntity user;
  final VoidCallback? onTap;
  final VoidCallback onMore;

  const ClientUserCard({
    super.key,
    required this.user,
    this.onTap,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final hasAvatar = user.avatarUrl != null && user.avatarUrl!.trim().isNotEmpty;

    final isProvider = user.role.trim().toLowerCase() == 'provider';
    final serviceSlug = (user.serviceSlug ?? '').trim();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.surface,
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: scheme.primary.withOpacity(0.10),
                        backgroundImage: hasAvatar ? NetworkImage(user.avatarUrl!) : null,
                        onBackgroundImageError: hasAvatar ? (_, __) {} : null,
                        child: hasAvatar
                            ? null
                            : Text(
                                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: scheme.primary,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.phone,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _MiniPill(
                                  icon: Icons.star_rounded,
                                  text:
                                      '${user.ratingAvg.toStringAsFixed(1)} (${user.ratingCount})',
                                  tint: const Color(0xFFF59E0B),
                                ),
                                _MiniPill(
                                  icon: Icons.verified_rounded,
                                  text: '${user.completedBookings} completed',
                                  tint: const Color(0xFF10B981),
                                ),
                                if (isProvider && serviceSlug.isNotEmpty)
                                  _MiniPill(
                                    icon: Icons.category_outlined,
                                    text: serviceSlug,
                                    tint: scheme.primary,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: onMore,
              splashRadius: 22,
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color tint;

  const _MiniPill({
    required this.icon,
    required this.text,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tint.withOpacity(0.10),
        border: Border.all(color: tint.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: tint),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: tint.withOpacity(0.95),
            ),
          ),
        ],
      ),
    );
  }
}