import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key, this.size = 60});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.home, color: Colors.white, size: 32),
    );
  }
}
