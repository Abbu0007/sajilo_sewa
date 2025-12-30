import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Quicksand Bold',
    fontSize: 20,
    color: Color(0xFF111827), // almost black
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: 'Quicksand Semibold',
    fontSize: 15,
    color: Color(0xFF111827), // DARK
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Quicksand Regular',
    fontSize: 13,
    color: Color(0xFF374151), // readable grey
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Quicksand Regular',
    fontSize: 12,
    color: Color(0xFF6B7280),
  );

  static const TextStyle price = TextStyle(
    fontFamily: 'Quicksand Medium',
    fontSize: 13,
    color: Color(0xFF2563EB), // primary blue
  );
}
