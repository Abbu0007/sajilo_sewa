import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';

class AdminUserViewCard extends StatelessWidget {
  final AdminUserEntity user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminUserViewCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  bool get _isProvider => user.role.trim().toLowerCase() == 'provider';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final avatarUrl = (user.avatarUrl ?? '').trim();
    final hasAvatar = avatarUrl.isNotEmpty;

    return Column(
      children: [
        Container(
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
                        child: hasAvatar
                            ? Image.network(avatarUrl, fit: BoxFit.cover)
                            : Center(
                                child: Text(
                                  user.fullName.isNotEmpty
                                      ? user.fullName[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 48,
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
                        left: 14,
                        right: 14,
                        bottom: 14,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.fullName,
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
                            _RoleChip(role: user.role),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _MiniStat(
                            icon: Icons.star_rounded,
                            label: '${user.ratingAvg.toStringAsFixed(1)} (${user.ratingCount})',
                            bg: const Color(0xFFFFF7ED),
                            fg: const Color(0xFF9A3412),
                            border: const Color(0xFFFED7AA),
                          ),
                          const SizedBox(width: 10),
                          _MiniStat(
                            icon: Icons.verified_rounded,
                            label: '${user.completedBookings} completed',
                            bg: const Color(0xFFECFDF5),
                            fg: const Color(0xFF047857),
                            border: const Color(0xFFA7F3D0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(icon: Icons.email_outlined, label: 'Email', value: user.email),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: user.phone),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.badge_outlined, label: 'Role', value: user.role),
                      if (_isProvider) ...[
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.work_outline,
                          label: 'Profession',
                          value: (user.profession ?? '').trim().isEmpty ? '—' : user.profession!.trim(),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.miscellaneous_services_outlined,
                          label: 'Service',
                          value: (user.serviceSlug ?? '').trim().isEmpty ? '—' : user.serviceSlug!.trim(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w800)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  label: const Text('Delete',
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final Color border;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w900, color: fg),
              ),
            ),
          ],
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
          width: 82,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: muted)),
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