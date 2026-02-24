import 'package:flutter/material.dart';

class RatingSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final Future<void> Function(int stars, String? comment) onSubmit;

  const RatingSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSubmit,
  });

  @override
  State<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<RatingSheet> {
  int stars = 5;
  final commentCtrl = TextEditingController();
  bool saving = false;
  String? error;

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: saving ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.subtitle,
                style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 14),

            // ⭐ stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final idx = i + 1;
                final filled = idx <= stars;
                return IconButton(
                  onPressed: saving ? null : () => setState(() => stars = idx),
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),
            TextField(
              controller: commentCtrl,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Comment (optional)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
              ),
            ),

            if (error != null) ...[
              const SizedBox(height: 10),
              Text(
                error!,
                style: const TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.w800),
              ),
            ],

            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving
                    ? null
                    : () async {
                        setState(() {
                          saving = true;
                          error = null;
                        });

                        try {
                          await widget.onSubmit(stars, commentCtrl.text.trim().isEmpty ? null : commentCtrl.text.trim());
                          if (!mounted) return;
                          Navigator.pop(context);
                        } catch (e) {
                          setState(() {
                            error = "Rating failed";
                          });
                        } finally {
                          if (mounted) {
                            setState(() => saving = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                child: Text(saving ? "Submitting..." : "Submit Rating",
                    style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}