import 'package:image_picker/image_picker.dart';

class CreateUserFormResult {
  final String fullName;
  final String email;
  final String phone;
  final String role; // client | provider
  final String? profession;
  final String password;
  final XFile? avatarFile;

  const CreateUserFormResult({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.password,
    this.profession,
    this.avatarFile,
  });
}
