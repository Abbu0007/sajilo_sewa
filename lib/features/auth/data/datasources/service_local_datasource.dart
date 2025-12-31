import 'package:hive/hive.dart';

class ServiceLocalDatasource {
  static const boxName = 'servicesBox';

  Future<void> seedServices() async {
    final box = await Hive.openBox(boxName);
    if (box.isEmpty) {
      await box.addAll([
        'Carpenter',
        'Plumber',
        'Electrician',
        'Cleaner',
        'Painter',
        'AC Technician',
      ]);
    }
  }

  Future<List<String>> getServices() async {
    final box = await Hive.openBox(boxName);
    return box.values.cast<String>().toList();
  }
}
