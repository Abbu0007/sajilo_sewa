import 'package:flutter/material.dart';

class BookingSheet extends StatefulWidget {
  final Future<void> Function(
      String scheduledAt,
      String? address,
      String? note) onConfirm;

  const BookingSheet({super.key, required this.onConfirm});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  DateTime? selectedDate;
  final addressController = TextEditingController();
  final noteController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select Date & Time",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: now,
                  lastDate: DateTime(now.year + 1),
                  initialDate: now,
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Text(
                selectedDate == null
                    ? "Pick Date"
                    : selectedDate.toString(),
              ),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration:
                  const InputDecoration(labelText: "Address"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration:
                  const InputDecoration(labelText: "Note"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: selectedDate == null || loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      await widget.onConfirm(
                        selectedDate!.toIso8601String(),
                        addressController.text,
                        noteController.text,
                      );
                      if (mounted) Navigator.pop(context);
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}