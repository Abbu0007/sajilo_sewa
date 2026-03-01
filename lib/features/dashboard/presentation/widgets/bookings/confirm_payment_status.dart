import 'package:flutter/material.dart';

class ConfirmPaymentSheet extends StatefulWidget {
  final int amount;
  final Future<void> Function() onConfirmPaid;

  const ConfirmPaymentSheet({
    super.key,
    required this.amount,
    required this.onConfirmPaid,
  });

  @override
  State<ConfirmPaymentSheet> createState() => _ConfirmPaymentSheetState();
}

class _ConfirmPaymentSheetState extends State<ConfirmPaymentSheet> {
  String method = "cash";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Confirm Payment",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: loading ? null : () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Amount: Rs ${widget.amount}",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _MethodTile(
              selected: method == "cash",
              title: "Cash",
              subtitle: "Pay in cash after service. Tap confirm to mark as paid.",
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => setState(() => method = "cash"),
            ),
            const SizedBox(height: 10),
            _MethodTile(
              selected: method == "qr",
              title: "QR (eSewa / Khalti later)",
              subtitle: "For now this confirms payment. Later we’ll show real QR + gateway verification.",
              icon: Icons.qr_code_rounded,
              onTap: () => setState(() => method = "qr"),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: loading ? null : () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () async {
                            setState(() => loading = true);
                            try {
                              await widget.onConfirmPaid();
                              if (!mounted) return;
                              Navigator.pop(context, true);
                            } catch (_) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Payment confirmation failed.")),
                              );
                              setState(() => loading = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Confirm paid"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MethodTile({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = selected ? const Color(0xFF86EFAC) : const Color(0xFFE5E7EB);
    final bg = selected ? const Color(0xFFECFDF5) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 1.2),
          color: bg,
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: selected ? const Color(0xFF059669) : const Color(0xFFF3F4F6),
              ),
              child: Icon(icon, color: selected ? Colors.white : Colors.black54),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}