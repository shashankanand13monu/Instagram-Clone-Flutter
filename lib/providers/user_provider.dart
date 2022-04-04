import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';

import '../models/user.dart' as model;

class UserProvider with ChangeNotifier {
  model.User? _user;

  final AuthMethods _authMethods = AuthMethods();

  model.User get getUser => _user!;
  // User get getUser {
  //   // Future.delayed(Duration(seconds: 3));
  //    _user==false? Center(child: CircularProgressIndicator() ,) :  _user!;
  //    return _user!;
  // }

  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUsersDetails();
    if (user == null)
      Center(
        child: CircularProgressIndicator(),
      );

    _user = user;
    notifyListeners();
  }
}
