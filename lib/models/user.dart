import '../utils/helpers.dart';

class BasicUser {
  const BasicUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  factory BasicUser.fromJson(Map<String, dynamic> json) {
    return BasicUser(
      id: asInt(json['id']),
      firstName: asString(json['firstName']),
      lastName: asString(json['lastName']),
      email: asString(json['email']),
      role: asString(json['role']),
    );
  }
}
