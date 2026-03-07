import 'package:flutter/material.dart';

class BookingSheet extends StatefulWidget {
  final Future<void> Function(
    String scheduledAt,
    String? address,
    String? note,
  ) onConfirm;

  const BookingSheet({super.key, required this.onConfirm});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final addressController = TextEditingController();
  final noteController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }

  DateTime? get combinedDateTime {
    if (selectedDate == null || selectedTime == null) return null;
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  String _prettyDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _prettyTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    final dt = combinedDateTime;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final handleColor =
        isDark ? const Color(0xFF4B5563) : Colors.grey.shade300;
    final cardBg = isDark ? const Color(0xFF161A22) : Colors.white;
    final mutedBg = isDark ? const Color(0xFF1B2230) : const Color(0xFFF8FAFC);
    final borderColor =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final subtitleColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 44,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Book Service",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: loading ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose your preferred date and time, then add your address and note.",
                  style: TextStyle(
                    color: subtitleColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _PickerCard(
                      title: "Date",
                      value: selectedDate == null
                          ? "Pick Date"
                          : _prettyDate(selectedDate!),
                      icon: Icons.calendar_month_rounded,
                      onTap: loading
                          ? null
                          : () async {
                              final now = DateTime.now();
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: now,
                                lastDate: DateTime(now.year + 1),
                                initialDate: selectedDate ?? now,
                              );
                              if (picked != null) {
                                setState(() => selectedDate = picked);
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PickerCard(
                      title: "Time",
                      value: selectedTime == null
                          ? "Pick Time"
                          : _prettyTime(selectedTime!),
                      icon: Icons.access_time_rounded,
                      onTap: (selectedDate == null || loading)
                          ? null
                          : () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime ?? TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() => selectedTime = picked);
                              }
                            },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (dt != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: mutedBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.event_available_rounded,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Scheduled for ${_prettyDate(dt)} at ${_prettyTime(selectedTime!)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: "Note (optional)",
                        prefixIcon: const Icon(Icons.notes_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (dt == null || loading)
                      ? null
                      : () async {
                          setState(() => loading = true);
                          try {
                            await widget.onConfirm(
                              dt.toIso8601String(),
                              addressController.text.trim().isEmpty
                                  ? null
                                  : addressController.text.trim(),
                              noteController.text.trim().isEmpty
                                  ? null
                                  : noteController.text.trim(),
                            );
                            if (mounted) Navigator.pop(context);
                          } finally {
                            if (mounted) setState(() => loading = false);
                          }
                        },
                  icon: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(
                    loading ? "Confirming..." : "Confirm Booking",
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const _PickerCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF161A22) : Colors.white;
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final iconBg = isDark ? const Color(0xFF1B2230) : const Color(0xFFF8FAFC);
    final subtitleColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: subtitleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w900),
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