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

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Date & Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now,
                        lastDate: DateTime(now.year + 1),
                        initialDate: selectedDate ?? now,
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                    child: Text(
                      selectedDate == null ? "Pick Date" : _prettyDate(selectedDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: selectedDate == null
                        ? null
                        : () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) setState(() => selectedTime = picked);
                          },
                    child: Text(
                      selectedTime == null ? "Pick Time" : _prettyTime(selectedTime!),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (dt != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Scheduled: ${_prettyDate(dt)} ${_prettyTime(selectedTime!)}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ),

            const SizedBox(height: 12),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 12),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Note (optional)",
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}