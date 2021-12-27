import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/provider/auth_provider.dart';
import 'package:flutter_t_watch/provider/user_provider.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/home_page.dart';
import 'package:flutter_t_watch/screens/signup_screen.dart';
import 'package:flutter_t_watch/styles/login_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/validator.dart';
import 'package:flutter_t_watch/widgets/my_button_widget.dart';
import 'package:flutter_t_watch/widgets/my_textfromfield_widget.dart';
import 'package:flutter_t_watch/widgets/sign_in_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = GlobalKey<FormState>();

  //late String email, password;

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
    if(passController.text.isNotEmpty && emailController.text.isNotEmpty){
     // print("Email======="+emailController.text+"++++++++++"+"Pass========="+passController.text);
     //  Map data = {
     //    "email": emailController.text,
     //    "password": passController.text
     //  };
     //  var body = json.encode(data);
     //  print("Body_______"+body);
      // headers: {"Accept": "application/json",
      //           'connection': 'keep-alive',
      //   "Access-Control-Allow-Origin": "*",
      //   "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      //   "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"},
      var response = await http.post(Uri.parse("http://localhost:3030/api/users/login"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
                "email": email, "password": password
          }
          ));
      //print("Body:"+response.body);
      // var response = await http.post(Uri.parse("https://mystore-backend.herokuapp.com/api/users/login"),
      //     body: (
      //         {
      //           "email": emailController.text,
      //           "password": passController.text
      //         }
      //     )
      // );
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfully"),));

        print("ADDRESS :"+body['shippingAddress'].toString());

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("login", body['token']);
        await pref.setString("address", body['shippingAddress']['address'].toString());
        await pref.setString("ward", body['shippingAddress']['ward'].toString());
        await pref.setString("district", body['shippingAddress']['district'].toString());
        await pref.setString("city", body['shippingAddress']['city'].toString());
        await pref.setString("phone", body['phone']);
        await pref.setString("name", body['name']);
        //await pref.setStringList("wishlist", body['wishListItems']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0,)), (route) => false);
        //print("LOGIN SUCCESSFULLY");
      } else {
        print(response.body.toString()+"stt code======"+response.statusCode.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials"),));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Blank Field Not Allowed"),));

    }

}



  Widget buildTopPart(){
    return Column(
      children: [
        Image.asset(
          "images/Logo.png",
          height: 150,
        ),
        // Container(
        //   margin: EdgeInsets.all(20.0),
        //   child:  Center(
        //     child: Text(
        //       "SIGN IN",
        //       style: LoginScreenStylies.signInButtonTextStyle,
        //     ),
        //   ),
        // ),
        // Column(
        //   children: [
        //     // MyTextFromField(hintText: "Email", obscureText: false),
        //     // MyTextFromField(hintText: "Password", obscureText: true),
        //
        //
        //     Container(
        //         margin: EdgeInsets.symmetric(
        //         horizontal: 20,
        //         vertical: 10,
        //         ),
        //         child:
        //             TextFormField(
        //               controller: emailController,
        //               decoration: InputDecoration(
        //                 labelText: "Email",
        //                 border: OutlineInputBorder(),
        //                 suffixIcon: Icon(Icons.email)
        //               ),
        //             ),
        //     ),
        //
        //     SizedBox(height: 15,),
        //
        //  Container(
        //     margin: EdgeInsets.symmetric(
        //     horizontal: 20,
        //     vertical: 10,
        //     ),
        //     child:
        //         TextFormField(
        //           controller: passController,
        //           obscureText: true,
        //           decoration: InputDecoration(
        //               labelText: "Password",
        //               border: OutlineInputBorder(),
        //               suffixIcon: Icon(Icons.password)
        //           ),
        //         ),
        // )
        //
        //
        //   ],
        // ),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 20),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Expanded(child: MaterialButton(
        //         color: Colors.blue,
        //         height: 45,
        //         elevation: 0,
        //         shape: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(5),
        //           borderSide: BorderSide.none,
        //         ),
        //         onPressed:() async{
        //           // PageRouting.goToNextPage(
        //           //   context: context,
        //           //   navigateTo: MyBottomBar(),
        //           // );
        //           String e = emailController.text;
        //           String p = passController.text;
        //
        //           await login(e, p);
        //
        //
        //         },
        //         child: Text(
        //           "Sign In",
        //           style: TextStyle(
        //             fontSize: 20,
        //             color: Colors.white,
        //           ),
        //         ),
        //       )),
        //       const SizedBox(
        //         width: 20,
        //       ),
        //       Expanded(child: MaterialButton(
        //         color: Colors.blueAccent,
        //         height: 45,
        //         elevation: 0,
        //         shape: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(5),
        //           borderSide: BorderSide.none,
        //         ),
        //         onPressed:(){
        //           PageRouting.goToNextPage(
        //             context: context,
        //             navigateTo: SignupScreen(),
        //           );
        //         },
        //         child: Text(
        //           "Sign Up",
        //           style: TextStyle(
        //             fontSize: 20,
        //             color: Colors.white,
        //           ),
        //         ),
        //       )),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: 20,
        // ),
        // const Text("Forgot Password?", style: LoginScreenStylies.forgotPasswordStylies,)






        Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "Sign in with your email and password\nor continue with social media",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30,),
        SignInWidget(),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? "),
            TextButton(
              child: Text(
                "Sign Up",
                style: TextStyle(color: Color(0xFF6776FF)),
              ),
              onPressed: () {
                PageRouting.goToNextPage(
                                context: context,
                                navigateTo: SignupScreen(),
                              );
              }
            ),
          ],
        )



      ],
    );
  }


  Widget buildBottomPart(){
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("or sign in with social network",
          style: LoginScreenStylies.signinSocialStylies,),
          SizedBox(height: 5,),
          Padding(padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                MaterialButton(onPressed: (){},
                shape: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5,
                    color: AppColors.baseGrey40Color
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SvgPicture.asset(
                  SvgImages.facebook,
                  color: AppColors.baseBlackColor,
                  width: 45,
                )),
                SizedBox(height: 5),
                MaterialButton(onPressed: (){},
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.baseGrey40Color
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SvgPicture.asset(
                    SvgImages.google,
                    color: AppColors.baseBlackColor,
                    width: 45,
                  )),
                SizedBox(height: 5),
                MaterialButton(onPressed: (){},
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.baseGrey40Color
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SvgPicture.asset(
                    SvgImages.twitter,
                    color: AppColors.baseBlackColor,
                    width: 45,
                  ),)
              ],),

          )

        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

//     AuthProvider auth = Provider.of<AuthProvider>(context);
//
//     var doLogin = (){
//
//       final form = formKey.currentState;
//
//       if(form!.validate()){
//
//         form.save();
//
//         final Future<Map<String,dynamic>> respose =  auth.login(email, password);
//
//         respose.then((response) {
//           if (response['status']) {
//
//             User user = response['user'];
//
//             Provider.of<UserProvider>(context, listen: false).setUser(user);
//
//             SchedulerBinding.instance!.addPostFrameCallback((_) {
//               Navigator.pushReplacementNamed(context, '/dashboard');
//             });
//
//           } else {
//             Flushbar(
//               title: "Failed Login",
//               message: response['message']['message'].toString(),
//               duration: Duration(seconds: 3),
//             ).show(context);
//           }
//         });
//
//
//       }else{
//         Flushbar(
//           title: 'Invalid form',
//           message: 'Please complete the form properly',
//           duration: Duration(seconds: 10),
//         ).show(context);
//       }
//
//     };
//
//
//     final loading = Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         CircularProgressIndicator(),
//         Text(" Login ... Please wait")
//       ],
//     );
//
//     final forgotLabel = Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         FlatButton(
//           padding: EdgeInsets.all(0.0),
//           child: Text("Forgot password?",
//               style: TextStyle(fontWeight: FontWeight.w300)),
//           onPressed: () {
// //            Navigator.pushReplacementNamed(context, '/reset-password');
//           },
//         ),
//         FlatButton(
//           padding: EdgeInsets.only(left: 0.0),
//           child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/register');
//           },
//         ),
//       ],
//     );
//
//
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: Text('Login'),),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(40.0),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 15.0,),
//                   Text("Email"),
//                   SizedBox(height: 5.0,),
//                   TextFormField(
//                     autofocus: false,
//                     // validator: validateEmail,
//                     onSaved: (String? value)=> email = value!,
//                     decoration: buildInputDecoration('Enter Email',Icons.email),
//                   ),
//                   SizedBox(height: 20.0,),
//                   Text("Password"),
//                   SizedBox(height: 5.0,),
//                   TextFormField(
//                     autofocus: false,
//                     obscureText: true,
//                     validator: (value)=> value!.isEmpty?"Please enter password":null,
//                     onSaved: (String? value)=> password = value!,
//                     decoration: buildInputDecoration('Enter Password',Icons.lock),
//                   ),
//                   SizedBox(height: 20.0,),
//                   auth.loggedInStatus == Status.Authenticating
//                       ?loading
//                       : longButtons('Login',doLogin),
//                   SizedBox(height: 8.0,),
//                   forgotLabel
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );




    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildTopPart(),
                  // buildBottomPart(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
