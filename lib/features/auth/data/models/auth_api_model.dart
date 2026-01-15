import '../../domain/entities/auth_user_entity.dart';

class AuthApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String? profession;

  AuthApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.profession,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      profession: json['profession']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'profession': profession,
    };
  }

  AuthUserEntity toEntity() => AuthUserEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    role: role,
    profession: profession,
  );

  factory AuthApiModel.fromEntity(AuthUserEntity e) => AuthApiModel(
    id: e.id,
    firstName: e.firstName,
    lastName: e.lastName,
    email: e.email,
    phone: e.phone,
    role: e.role,
    profession: e.profession,
  );

  static List<AuthUserEntity> toEntityList(List<AuthApiModel> list) =>
      list.map((e) => e.toEntity()).toList();

  static List<AuthApiModel> fromEntityList(List<AuthUserEntity> list) =>
      list.map((e) => AuthApiModel.fromEntity(e)).toList();
}

class AuthResponseModel {
  final String token; 
  final AuthApiModel user;

  AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: (json['token'] ?? json['accessToken'] ?? '').toString(),
      user: AuthApiModel.fromJson((json['user'] ?? {}) as Map<String, dynamic>),
    );
  }
}

