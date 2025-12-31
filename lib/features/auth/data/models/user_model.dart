import '../../domain/entities/user_entity.dart';

class UserModel {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String userType;
  final String? service;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.userType,
    this.service,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      userType: map['userType'],
      service: map['service'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'userType': userType,
      'service': service,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
      userType: entity.userType,
      service: entity.service,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      userType: userType,
      service: service,
    );
  }
}
