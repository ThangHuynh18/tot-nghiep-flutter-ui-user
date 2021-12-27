import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('_id',user.sId);
    prefs.setString('name',user.name);
    prefs.setString('email',user.email);
    prefs.setString('phone',user.phone);
    prefs.setString('token',user.token);
    prefs.setStringList("wishListItems", user.wishListItems as List<String>);

    return prefs.commit();

  }

  Future<User> getUser ()  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString("_id");
    String name = prefs.getString("name");
    String email = prefs.getString("email");
    String phone = prefs.getString("phone");
    List<String> wishList = prefs.getStringList("wishListItems");
    String token = prefs.getString("token");
    //String renewalToken = prefs.getString("renewalToken");


    return User.forLogin(sId: userId, name: name, email: email, phone: phone, token: token, wishListItems: wishList);

  }

  void removeUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('_id');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('phone');
    prefs.remove('token');
    prefs.remove('wishListItems');

  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }

}