import 'dart:convert';

import 'package:nepali_date_picker/nepali_date_picker.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String userId;
  String? phoneNo;
  String? name;
  NepaliDateTime? subscriptionEndsAt;
  String? password;
  String? appVersion;
  String sessionToken;
  User({
    required this.userId,
    this.phoneNo,
    this.name,
    this.subscriptionEndsAt,
    this.password,
    this.appVersion,
    required this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'phone': phoneNo,
      'name': name,
      'ends_at': subscriptionEndsAt?.millisecondsSinceEpoch,
      'password': password,
      'app_version': appVersion,
      'sessionToken': sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'] as String,
      phoneNo: map['phone'] != null ? map['phone'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      subscriptionEndsAt: map['ends_at'] != null
          ? NepaliDateTime.tryParse(map['ends_at'])
          : null,
      password: map['password'] != null ? map['password'] as String : null,
      appVersion:
          map['app_version'] != null ? map['app_version'] as String : null,
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
    NepaliDateTime? subscriptionEndsAt,
    String? password,
    String? appVersion,
    String? sessionToken,
  }) {
    return User(
      userId: userId ?? this.userId,
      phoneNo: phoneNo ?? this.phoneNo,
      name: name ?? this.name,
      subscriptionEndsAt: subscriptionEndsAt ?? this.subscriptionEndsAt,
      password: password ?? this.password,
      appVersion: appVersion ?? this.appVersion,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }
}
