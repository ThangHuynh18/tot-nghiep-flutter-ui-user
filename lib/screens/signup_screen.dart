import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/styles/signup_screen_stylies.dart';
import 'package:flutter_t_watch/util/default_button.dart';
import 'package:flutter_t_watch/widgets/my_textfromfield_widget.dart';
import 'package:flutter_t_watch/widgets/sign_up_form_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  // final ImagePicker _picker = ImagePicker();
  // PickedFile? image;
  // String urlAvatar = "";
  // List<UploadImage> uploadImages = [];
  //
  // void filePicker() async {
  //   final PickedFile? selectImage = (await _picker.getImage(source: ImageSource.gallery));
  //   //final response = await http.post(Uri.parse("https://graduate-flutter-api.herokuapp.com/api/upload"));
  //
  //   http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse("https://graduate-flutter-api.herokuapp.com/api/upload"));
  //
  //   http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //       'image', selectImage!.path);
  //
  //   request.files.add(multipartFile);
  //
  //   http.StreamedResponse response = await request.send();
  //   print("STATUS CODE UPLOAD: "+response.statusCode.toString());
  //   if(response.statusCode == 200){
  //     final data = jsonDecode("[${response.reasonPhrase}]");
  //       print("data reason phrase : ${data}");
  //
  //     setState(() {
  //       for (Map<String, dynamic> i in data) {
  //         uploadImages.add(UploadImage.fromJson(i));
  //
  //       }
  //       var result = uploadImages[0];
  //       urlAvatar = result.fileLocation;
  //       print("URL IMAGE: "+urlAvatar);
  //     });
  //   }
  //
  //
  //   print("IMAGE PATHl: "+selectImage!.path.toString());
  //   setState(() {
  //     image = selectImage;
  //   });
  // }


  Widget buildTopPart(){
    final _formKey = GlobalKey<FormState>();
    final List<String> errors = [];
    bool firstSubmit = false;

    return Column(
      children: [
        Image.asset("images/Logo.png", height: 150,),
        Container(
          margin: EdgeInsets.all(20.0),
          child:  Center(
              child: Text(
                "SIGN UP",
                style: SignupScreenStylies.signUpButtonTextStyle,
              ),
            ),
          ),
        // Container(
        //   height: 200,
        //   margin: EdgeInsets.only(bottom: 5),
        //   color: AppColors.baseWhiteColor,
        //   child: Padding(
        //     padding: EdgeInsets.all(10.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //       Center(
        //                 child: image == null ? Text("No image chosen") : Image.file(File(image!.path), width: 80, height: 80, fit: BoxFit.cover,)
        //                 // CircleAvatar(
        //                 //   radius: 35,
        //                 //   backgroundColor: Colors.transparent,
        //                 //   backgroundImage: NetworkImage("https://scontent.fsgn13-2.fna.fbcdn.net/v/t31.18172-8/28238338_2013913362183592_2795599183800582728_o.jpg?_nc_cat=106&ccb=1-5&_nc_sid=174925&_nc_ohc=OA2gYExxnosAX-i4lob&_nc_ht=scontent.fsgn13-2.fna&oh=d55bba7b3490b1f16018c5aed7b3b30b&oe=617BC974"),
        //                 //
        //                 // ),
        //               ),
        //               OutlinedButton(
        //                   onPressed: (){filePicker();},
        //                   child: const Text("Select Image")),
        //
        //       ],
        //     ),
        //   ),
        // ),

        SignUpWidget(),

      //   MyTextFromField(hintText: "Full name", obscureText: false),
      //   MyTextFromField(hintText: "Email", obscureText: false),
      //   MyTextFromField(hintText: "Password", obscureText: true),
      //   MyTextFromField(hintText: "Phone", obscureText: false),
      //   MyTextFromField(hintText: "Address", obscureText: false),
      //   MyTextFromField(hintText: "Ward", obscureText: false),
      //   MyTextFromField(hintText: "District", obscureText: false),
      //   MyTextFromField(hintText: "City", obscureText: false),
      //   Container(
      //     margin: EdgeInsets.symmetric(
      //       horizontal: 20,
      //       vertical: 10
      //     ),
      //     child:  DefaultButton(
      //       text: "Register",
      //       press: () async{
      //         if (_formKey.currentState!.validate()) {
      //           _formKey.currentState!.save();
      //
      //           //await login(email, password);
      //         }
      //         firstSubmit = true;
      //       },
      //     ),
      //
      // ),
      // SizedBox(height: 20),
        // RichText(
        //   text: TextSpan(
        //     text: "By signing up you agree to our\n\t",
        //     style: SignupScreenStylies.signUpAgreeStylies,
        //     children: <TextSpan>[
        //       TextSpan(
        //
        //       )
        //     ]
        //   ),
        // )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            buildTopPart(),
          ],
        ),
      ),
    );
  }
}
