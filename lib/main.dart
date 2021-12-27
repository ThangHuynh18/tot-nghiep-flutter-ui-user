import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/bloc/cart/cart_bloc.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/provider/auth_provider.dart';
import 'package:flutter_t_watch/provider/user_provider.dart';
import 'package:flutter_t_watch/screens/home/home_screen.dart';
import 'package:flutter_t_watch/screens/login_screen.dart';
import 'package:flutter_t_watch/screens/signup_screen.dart';
import 'package:flutter_t_watch/util/user_preference.dart';
import 'package:flutter_t_watch/widgets/sign_in_form_widget.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final authController = AuthController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Future<User> getUserData () => UserPreferences().getUser();
    //
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_)=> AuthProvider()),
    //     ChangeNotifierProvider(create: (_)=>UserProvider())
    //   ],
    //   child:  MaterialApp(
    //     title: 'Login Registration',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: FutureBuilder(
    //         future: getUserData(),
    //         builder: (context, snapshot) {
    //           switch (snapshot.connectionState) {
    //             case ConnectionState.none:
    //             case ConnectionState.waiting:
    //               return CircularProgressIndicator();
    //             default:
    //               if (snapshot.hasError)
    //                 return Text('Error: ${snapshot.error}');
    //               else if (snapshot.data == null)
    //                 return LoginScreen();
    //               else
    //                 Provider.of<UserProvider>(context).setUser(snapshot.data as User);
    //               return LoginScreen();
    //
    //           }
    //         }),
    //     routes: {
    //       '/login':(context)=>LoginScreen(),
    //       '/register':(context)=>SignupScreen(),
    //       '/dashboard':(context)=>HomeScreen()
    //     },
    //   ),
    // );




    // return BlocProvider(
    //   create: (context) => CartBloc(),
    //   child: MaterialApp(
    //     title: 'Flutter T Watch',
    //     theme: ThemeData(
    //       appBarTheme: AppBarTheme(
    //           iconTheme: IconThemeData(
    //               color: AppColors.baseBlackColor
    //           )
    //       ),
    //       primarySwatch: Colors.blue,
    //     ),
    //     // home: BlocProvider(
    //     //   create: (context) => CartBloc(),
    //     //   child: ProductPage(),
    //     // ),
    //     home: const LoginScreen(),
    //     // home: const HomeScreen(),
    //   ),
    // );



    return MaterialApp(
      title: 'Flutter T Watch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
                color: AppColors.baseBlackColor
            )
        ),
        primarySwatch: Colors.blue,
      ),
      //home:  LoginScreen(),
      home:
      FutureBuilder(
          future: authController.tryAutoLogin(),
          builder: (contect, authResult) {
            if (authResult.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
              );
              
            }
            else{
              if(authResult.data == true){
                return MyBottomBar(selectIndex: 0);
              }
              return LoginScreen();
            }
          }),
      builder: EasyLoading.init(),
      //home: const HomeScreen(),
    );


  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

