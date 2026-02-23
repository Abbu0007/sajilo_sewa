import 'package:flutter/material.dart';

class HomeLoadingBox extends StatelessWidget {
  final double height;
  const HomeLoadingBox({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFFF3F4F6)),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class HomeErrorBox extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const HomeErrorBox({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        color: const Color(0xFFFEF2F2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(onPressed: () => onRetry(), child: const Text("Retry")),
        ],
      ),
    );
  }
}

class HomeEmptyBox extends StatelessWidget {
  final String text;
  const HomeEmptyBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFFF3F4F6)),
      child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800))),
    );
  }
}