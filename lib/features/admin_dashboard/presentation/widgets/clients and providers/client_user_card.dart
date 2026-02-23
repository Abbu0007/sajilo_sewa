import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';

class ClientUserCard extends StatelessWidget {
  final AdminUserEntity user;

  /// Tap on the card body (left side)
  final VoidCallback? onTap;

  /// Tap on the 3-dots menu
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

    final hasAvatar =
        user.avatarUrl != null && user.avatarUrl!.trim().isNotEmpty;

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
          // ✅ ONLY THIS PART IS TAPPABLE (left side)
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
                        backgroundImage:
                            hasAvatar ? NetworkImage(user.avatarUrl!) : null,
                        child: hasAvatar
                            ? null
                            : Text(
                                user.fullName.isNotEmpty
                                    ? user.fullName[0].toUpperCase()
                                    : '?',
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
                            Text(
                              user.phone,
                              style: TextStyle(color: Colors.grey.shade700),
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
