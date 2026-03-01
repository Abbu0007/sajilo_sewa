import 'package:flutter/material.dart';

class ProviderBookingDialogs {
  ProviderBookingDialogs._();

  static Future<String?> askReason(
    BuildContext context, {
    required String title,
    required String hint,
  }) async {
    final ctrl = TextEditingController();

    return showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, ctrl.text), child: const Text("Submit")),
        ],
      ),
    );
  }

  static Future<PriceReasonResult?> askPriceAndReason(
    BuildContext context, {
    required String title,
    required String priceHint,
    required String reasonHint,
  }) async {
    final priceCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    return showDialog<PriceReasonResult?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: priceHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: reasonHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final p = priceCtrl.text.trim();
              if (p.isEmpty) return;
              Navigator.pop(
                ctx,
                PriceReasonResult(
                  price: p,
                  reason: reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim(),
                ),
              );
            },
            child: const Text("Request"),
          ),
        ],
      ),
    );
  }
}

class PriceReasonResult {
  final String price;
  final String? reason;

  const PriceReasonResult({required this.price, this.reason});
}