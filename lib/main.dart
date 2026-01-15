import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/hive/hive_service.dart';
import 'core/services/storage/user_session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserSessionService.instance.init();

  final hiveRes = await HiveService.instance.init();
  hiveRes.fold((f) => debugPrint('Hive init failed: ${f.message}'), (_) {});

  runApp(const ProviderScope(child: MyApp()));
}
