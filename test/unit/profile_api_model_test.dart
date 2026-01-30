import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/profile/data/models/profile_api_model.dart';

void main() {
  test('ProfileApiModel parses JSON and maps to entity', () {
    final json = {
      "id": "1",
      "firstName": "Abhi",
      "lastName": "Dhamala",
      "email": "a@test.com",
      "phone": "9800",
      "role": "client",
      "avatarUrl": "http://localhost:5000/uploads/avatars/a.png",
    };

    final model = ProfileApiModel.fromJson(json);

    expect(model.id, "1");
    expect(model.firstName, "Abhi");
    expect(model.lastName, "Dhamala");
    expect(model.fullName, "Abhi Dhamala");

    final entity = model.toEntity();
    expect(entity.fullName, "Abhi Dhamala");
    expect(entity.avatarUrl != null && entity.avatarUrl!.isNotEmpty, true);
  });
}
