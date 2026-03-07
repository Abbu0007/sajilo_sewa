import 'package:flutter/material.dart';

class RateUserSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool busy;
  final Future<void> Function(int stars, String comment) onSubmit;

  const RateUserSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.busy,
    required this.onSubmit,
  });

  @override
  State<RateUserSheet> createState() => _RateUserSheetState();
}

class _RateUserSheetState extends State<RateUserSheet> {
  int _stars = 5;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final handleColor = isDark ? const Color(0xFF4B5563) : Colors.grey.shade300;
    final subtitleColor = isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;
    final inputFill = isDark ? const Color(0xFF161A22) : const Color(0xFFF9FAFB);
    final inputBorder = isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final unfilledStar = isDark ? const Color(0xFF6B7280) : Colors.grey.shade400;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: widget.busy ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final idx = i + 1;
                final filled = idx <= _stars;
                return IconButton(
                  onPressed: widget.busy ? null : () => setState(() => _stars = idx),
                  icon: Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 34,
                    color: filled ? scheme.primary : unfilledStar,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _comment,
              enabled: !widget.busy,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write a short comment (optional)",
                filled: true,
                fillColor: inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: scheme.primary, width: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.busy
                    ? null
                    : () async {
                        await widget.onSubmit(_stars, _comment.text);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: widget.busy
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Submit Rating",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}