import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String userId;
  String? phoneNo;
  String? name;
  DateTime? subscriptionEndsAt;
  String? password;
  String sessionToken;
  User({
    required this.userId,
    this.phoneNo,
    this.name,
    this.subscriptionEndsAt,
    this.password,
    required this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'phone': phoneNo,
      'name': name,
      'ends_at': subscriptionEndsAt?.millisecondsSinceEpoch,
      'password': password,
      'sessionToken': sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'] as String,
      phoneNo: map['phone'] != null ? map['phone'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      subscriptionEndsAt: map['ends_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ends_at'] as int)
          : null,
      password: map['password'] != null ? map['password'] as String : null,
      sessionToken: map['sessionToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? userId,
    String? phoneNo,
    String? name,
    DateTime? subscriptionEndsAt,
    String? password,
    String? sessionToken,
  }) {
    return User(
      userId: userId ?? this.userId,
      phoneNo: phoneNo ?? this.phoneNo,
      name: name ?? this.name,
      subscriptionEndsAt: subscriptionEndsAt ?? this.subscriptionEndsAt,
      password: password ?? this.password,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }
}


