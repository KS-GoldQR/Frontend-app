import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(userId: '', sessionToken: '');

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void removeUser() {
    _user = User(userId: "", password: null, sessionToken: "", phoneNo: null, name: null, subscriptionEndsAt: null);
    notifyListeners();
  }
}
