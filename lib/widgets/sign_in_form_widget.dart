import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/constants.dart';
import 'package:flutter_t_watch/util/default_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  late String email, password;
  //final baseUrl = "https://graduate-flutter-api.herokuapp.com";
  bool firstSubmit = false;
  bool remember = false;


  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();


  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("login");
    if(token != null){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0,)), (route) => false);
    }
  }


  Future<void> login(String email, String password) async {
    await EasyLoading.show(
      status: 'Logging...',
      maskType: EasyLoadingMaskType.black,
    );
    if(email.isNotEmpty && password.isNotEmpty){
      var response = await http.post(Uri.parse("${AppUrl.baseUrl}/api/users/login"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email": email, "password": password
          }
          ));

      if(response.statusCode == 200){
        final body = json.decode(response.body);
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfully"),));

        print("ADDRESS :"+body['shippingAddress'].toString());

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("login", body['token']);
        await pref.setString("address", body['shippingAddress']['address'].toString());
        await pref.setString("ward", body['shippingAddress']['ward'].toString());
        await pref.setString("district", body['shippingAddress']['district'].toString());
        await pref.setString("city", body['shippingAddress']['city'].toString());
        await pref.setString("phone", body['phone']);
        await pref.setString("name", body['name']);
        await pref.setString("avatar", body['avatar']);
        await pref.setString("email", body['email']);
        //await pref.setStringList("wishlist", body['wishListItems']);


        Fluttertoast.showToast(
            msg: "Login Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0,)), (route) => false);
        //print("LOGIN SUCCESSFULLY");
        await EasyLoading.dismiss();
      } else {
        print(response.body.toString()+"stt code======"+response.statusCode.toString());
        await EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials"),));
      }
    }
    else {
      await EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Blank Field Not Allowed"),));

    }

  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          //SizedBox(height: 30),
          buildPasswordFormField(),
          //SizedBox(height: 30),
          Row(
            children: [
              // Checkbox(
              //   value: remember,
              //   activeColor: kPrimaryColor,
              //   onChanged: (value) => setState(() => remember = value),
              // ),
              // Text("Remember me"),
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 5,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          DefaultButton(
            text: "Login",
            press: () async{
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
               // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
               //  String e = emailController.text;
               //  String p = passController.text;

                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }

                await login(email, password);
              }
              firstSubmit = true;
            },
          ),
        ],
      ),
    );
  }

  Container buildPasswordFormField() {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 20,
        ),
      child: TextFormField(
        onSaved: (newPassword) => this.password = newPassword!,
        onChanged: (password) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (password) {
          if (password!.isEmpty) {
            return kPassNullError;
          } else if (password.isNotEmpty && password.length <= 5) {
            return kShortPassError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: Icon(Icons.password),
          border: OutlineInputBorder(),
          // focusColor: Colors.deepOrange,
          // fillColor: Colors.deepOrange
        ),
        obscureText: true,
      ),
    );
  }

  Container buildEmailFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        onSaved: (newEmail) => this.email = newEmail!,
        onChanged: (email) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (email) {
          if (email!.isEmpty) {
            return kEmailNullError;
          } else if (email.isNotEmpty && !emailValidatorRegExp.hasMatch(email)) {
            return kInvalidEmailError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "Enter your email",
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}


class AuthController {
  Future<bool> tryAutoLogin() async {
    var any = await SharedPreferences.getInstance();
    if (!any.containsKey("login")) {
      return false;
    } else {

      return true;
    }
  }

}

