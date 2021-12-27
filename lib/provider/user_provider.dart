import 'package:flutter/material.dart';
import 'package:flutter_t_watch/models/UserModel.dart';

class UserProvider extends ChangeNotifier{

  late User _user;

  User get user => _user;

  void setUser (User user){
    _user = user;
    notifyListeners();
  }
}