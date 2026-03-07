import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/api/api_endpoints.dart';
import '../../../domain/entities/provider_entity.dart';

class ProviderCard extends StatelessWidget {
  final ProviderEntity provider;
  final bool isFavourite;
  final VoidCallback onViewDetails;
  final VoidCallback onBookNow;
  final VoidCallback onFavourite;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.isFavourite,
    required this.onViewDetails,
    required this.onBookNow,
    required this.onFavourite,
  });

  String _resolveAvatarUrl(String? url) {
    if (url == null || url.trim().isEmpty) return "";

    final u = url.trim();
    final server = ApiEndpoints.mediaServerUrl;

    if (u.startsWith('http://') || u.startsWith('https://')) {
      return u
          .replaceFirst("http://10.0.2.2:5000", server)
          .replaceFirst("http://localhost:5000", server)
          .replaceFirst("http://127.0.0.1:5000", server);
    }

    if (u.startsWith('/')) {
      return '$server$u';
    }

    return '$server/$u';
  }

  @override
  Widget build(BuildContext context) {
    final initials = provider.fullName.trim().isEmpty
        ? "U"
        : provider.fullName
            .trim()
            .split(RegExp(r"\s+"))
            .take(2)
            .map((e) => e.isNotEmpty ? e[0] : "")
            .join()
            .toUpperCase();

    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final rating = provider.avgRating;
    final ratingCount = provider.ratingCount;
    final jobs = provider.completedJobs;
    final price = provider.startingPrice;

    final avatar = _resolveAvatarUrl(provider.avatarUrl);
    final hasAvatar = avatar.isNotEmpty;

    final cardBg = isDark ? const Color(0xFF161A22) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final avatarBg =
        isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final subColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        color: cardBg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarBg,
                child: ClipOval(
                  child: hasAvatar
                      ? Image.network(
                          avatar,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.profession,
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _StarRating(rating: rating),
                        const SizedBox(width: 6),
                        Text(
                          ratingCount > 0
                              ? "${rating.toStringAsFixed(1)} ($ratingCount)"
                              : "No ratings yet",
                          style: TextStyle(
                            color: subColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _Chip(
                          icon: Icons.work_outline_rounded,
                          label: "$jobs jobs",
                        ),
                        _Chip(
                          icon: Icons.payments_outlined,
                          label: "From Rs. $price",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavourite,
                icon: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: isFavourite ? const Color(0xFFE11D48) : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text("View Details"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.primary,
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onBookNow,
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: const Text("Book Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final iconColor =
        isDark ? const Color(0xFFD1D5DB) : Colors.black54;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;

  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starNumber = index + 1;

        if (rating >= starNumber) {
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (rating >= starNumber - 0.5) {
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 16, color: Colors.amber);
        }
      }),
    );
  }
}