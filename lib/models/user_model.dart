import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String userId;
  String password;
  String sessionToken;
  User({
    required this.userId,
    required this.password,
    required this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'password': password,
      'sessionToken': sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] as String,
      password: map['password'] as String,
      sessionToken: map['sessionToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
