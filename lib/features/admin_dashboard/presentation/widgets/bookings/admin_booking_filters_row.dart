import 'package:flutter/material.dart';

class AdminBookingFiltersRow extends StatelessWidget {
  final String status;
  final ValueChanged<String> onStatusChanged;

  final TextEditingController queryController;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const AdminBookingFiltersRow({
    super.key,
    required this.status,
    required this.onStatusChanged,
    required this.queryController,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final s = status.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Chip(label: 'All', active: s == 'all', onTap: () => onStatusChanged('all')),
            _Chip(label: 'Pending', active: s == 'pending', onTap: () => onStatusChanged('pending')),
            _Chip(label: 'Confirmed', active: s == 'confirmed', onTap: () => onStatusChanged('confirmed')),
            _Chip(label: 'In Progress', active: s == 'in_progress', onTap: () => onStatusChanged('in_progress')),
            _Chip(label: 'Completed', active: s == 'completed', onTap: () => onStatusChanged('completed')),
            _Chip(label: 'Cancelled', active: s == 'cancelled', onTap: () => onStatusChanged('cancelled')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: TextField(
                  controller: queryController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => onSearch(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search name, phone, service, status...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: onClear,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: active ? Colors.white : Colors.white.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(active ? 0.6 : 0.18)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black87 : Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}