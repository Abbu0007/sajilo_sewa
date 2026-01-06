import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final result = await HiveService.instance.init();
  result.fold((failure) {
    debugPrint('Hive init failed: ${failure.message}');
  }, (_) {});

  runApp(const ProviderScope(child: MyApp()));
}
