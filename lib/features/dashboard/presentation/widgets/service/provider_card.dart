import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final initials = provider.fullName.isEmpty
        ? "U"
        : provider.fullName
            .split(RegExp(r"\s+"))
            .take(2)
            .map((e) => e.isNotEmpty ? e[0] : "")
            .join()
            .toUpperCase();

    final scheme = Theme.of(context).colorScheme;

    final rating = provider.avgRating;
    final ratingCount = provider.ratingCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFF3F4F6),
                child: (provider.avatarUrl != null && provider.avatarUrl!.isNotEmpty)
                    ? const Icon(Icons.person, color: Colors.grey)
                    : Text(
                        initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider.fullName, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(
                      provider.profession ?? "Professional",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    ),

                    // ✅ NEW: Rating row
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _StarRating(rating: rating),
                        const SizedBox(width: 6),
                        Text(
                          ratingCount > 0 ? "${rating.toStringAsFixed(1)} ($ratingCount)" : "No ratings yet",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
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
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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