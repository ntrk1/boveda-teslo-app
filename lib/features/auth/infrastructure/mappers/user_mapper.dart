




import 'package:teslo_shop/features/auth/auth.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    roles: List<String>.from(json['roles'].map((role) => role)),
    token: json['token'] ?? '',
    fullName: json['fullName']
  );
}