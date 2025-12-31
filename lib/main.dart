import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'features/auth/data/datasources/service_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await ServiceLocalDatasource().seedServices();

  runApp(const MyApp());
}
