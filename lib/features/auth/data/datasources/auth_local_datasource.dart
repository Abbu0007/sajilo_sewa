import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthLocalDatasource {
  static const boxName = 'authBox';

  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox(boxName);
    await box.put('user', user.toMap());
  }
}
