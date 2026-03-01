import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/bookings/admin_booking_filters_row.dart';

class AdminBookingsHeaderCard extends StatelessWidget {
  final String status;
  final TextEditingController queryController;
  final int total;
  final int showing;

  final ValueChanged<String> onStatusChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const AdminBookingsHeaderCard({
    super.key,
    required this.status,
    required this.queryController,
    required this.total,
    required this.showing,
    required this.onStatusChanged,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
            // ---------- TOP GRADIENT HEADER ----------
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1D4ED8),
                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sajilo Sewa • Admin',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bookings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Search, filter, view details, cancel, or delete bookings.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Use the extracted filter row
                  AdminBookingFiltersRow(
                    status: status,
                    onStatusChanged: onStatusChanged,
                    queryController: queryController,
                    onSearch: onSearch,
                    onClear: onClear,
                  ),
                ],
              ),
            ),

            // ---------- BOTTOM META STRIP ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing $showing of $total',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const Text(
                    'Actions are instant',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}