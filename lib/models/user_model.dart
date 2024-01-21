import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String userId;
  String phoneNo;
  String password;
  String sessionToken;
  User({
    required this.userId,
    required this.phoneNo,
    required this.password,
    required this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'phoneNo':phoneNo,
      'password': password,
      'sessionToken': sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] as String,
      phoneNo: map['phoneNo'] as String,
      password: map['password'] as String,
      sessionToken: map['sessionToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? userId,
    String? phoneNo,
    String? password,
    String? sessionToken,
  }) {
    return User(
      userId: userId ?? this.userId,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }
}
