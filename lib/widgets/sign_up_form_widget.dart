import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/login_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/constants.dart';
import 'package:flutter_t_watch/util/default_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  late String name, email, password, phone, address, ward, district, city, urlAvatar;
  //final baseUrl = "https://graduate-flutter-api.herokuapp.com";
  bool firstSubmit = false;
  bool remember = false;

  final ImagePicker _picker = ImagePicker();
  PickedFile? image;
  List<UploadImage> uploadImages = [];


  void filePicker() async {
    final PickedFile? selectImage = (await _picker.getImage(source: ImageSource.gallery));
    // late File file;
    // if(selectImage != null){
    //   setState(() {
    //     file = selectImage as File;
    //   });
    // }
    // String base64Image = base64Encode(file.readAsBytesSync());
    // final response = await http.post(Uri.parse("https://graduate-flutter-api.herokuapp.com/api/upload"),
    //     body: {
    //       "image": base64Image
    //     });

    String fileName = selectImage!.path.split("/").last;
    var fileImage = await dio.MultipartFile.fromFile(selectImage.path, filename: fileName, contentType: MediaType("image", "png"));
    dio.FormData formData = new dio.FormData.fromMap({
      "image": fileImage,
      "type": "image/png"
    });
    var dioRequest = dio.Dio();
    var response = await dioRequest.post("https://graduate-flutter-api.herokuapp.com/api/upload",
    data: formData, options: dio.Options(
          headers: {
            //"Content-type": "multipart/form-data"
          }
        ));
    // http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse("https://graduate-flutter-api.herokuapp.com/api/upload"));
    //
    // // http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
    // //     'image', selectImage!.path);
    // print("FILE NAME: "+selectImage!.path.split("/").last.toString());
    // http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
    //     'image', selectImage.path);
    //
    // request.files.add(multipartFile);
    // request.headers.addAll({
    //   "Content-type": "multipart/form-data"
    // });
    //
    // http.StreamedResponse response = await request.send();
    print("STATUS CODE UPLOAD: "+response.statusCode.toString());
    if(response.statusCode == 200){

      setState(() {
        var upImg = UploadImage.fromJson(response.data);
        urlAvatar = upImg.fileLocation;
        print("URL IMAGE AFTER UPLOAD: "+urlAvatar);
      });
      // final data = jsonDecode("[${response.data}]");
      // print("data reason phrase : ${data}");
      //
      // setState(() {
      //   for (Map<String, dynamic> i in data) {
      //     uploadImages.add(UploadImage.fromJson(i));
      //
      //   }
      //   var result = uploadImages[0];
      //   urlAvatar = result.fileLocation;
      //   print("URL IMAGE: "+urlAvatar);
      // });
    }


   // print("IMAGE PATHl: "+selectImage.path.toString());
    setState(() {
      image = selectImage;
    });
  }


  Future<void> register(String name, String email, String password, String phone, String address, String ward, String district, String city, String avatar) async {
    if(email.isNotEmpty && password.isNotEmpty && name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty && ward.isNotEmpty && district.isNotEmpty && city.isNotEmpty){
      print("URL AVATAR IN REGISTER FUNC: "+avatar);
      var response = await http.post(Uri.parse("${AppUrl.baseUrl}/api/users"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "phone": phone,
            "password": password,
            "role": "",
            "avatar": avatar,
            "shippingAddress": {
              "address": address,
              "city": city,
              "district": district,
              "ward": ward
            }
          }
          ));

      if(response.statusCode == 201){
        final body = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Successfully"),));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
        //PageRouting.goToNextPage(context: context, navigateTo: LoginScreen());

      } else {
        print(response.body.toString()+"stt code======"+response.statusCode.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Failed"),));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Blank Field Not Allowed"),));

    }

  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            height: 150,
            margin: EdgeInsets.only(bottom: 5),
            color: AppColors.baseWhiteColor,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: image == null ? Text("No image chosen") : Image.file(File(image!.path), width: 80, height: 80, fit: BoxFit.cover,)
                    // CircleAvatar(
                    //   radius: 35,
                    //   backgroundColor: Colors.transparent,
                    //   backgroundImage: NetworkImage("https://scontent.fsgn13-2.fna.fbcdn.net/v/t31.18172-8/28238338_2013913362183592_2795599183800582728_o.jpg?_nc_cat=106&ccb=1-5&_nc_sid=174925&_nc_ohc=OA2gYExxnosAX-i4lob&_nc_ht=scontent.fsgn13-2.fna&oh=d55bba7b3490b1f16018c5aed7b3b30b&oe=617BC974"),
                    //
                    // ),
                  ),
                  OutlinedButton(
                      onPressed: (){filePicker();},
                      child: const Text("Select Image")),

                ],
              ),
            ),
          ),
          buildNameFormField(),
          buildEmailFormField(),
          //SizedBox(height: 30),
          buildPasswordFormField(),
          buildPhoneFormField(),
          buildAddressFormField(),
          buildWardFormField(),
          buildDistrictFormField(),
          buildCityFormField(),

          //SizedBox(height: 30),
          DefaultButton(
            text: "Register",
            press: () async{
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                //  String e = emailController.text;
                //  String p = passController.text;

                await register(name, email, password, phone, address, ward, district, city, urlAvatar);
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

  Container buildNameFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        onSaved: (newName) => this.name = newName!,
        onChanged: (name) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (name) {
          if (name!.isEmpty) {
            return kLastNamelNullError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Name",
          hintText: "Enter your name",
          suffixIcon: Icon(Icons.account_box_sharp),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.name,
      ),
    );
  }

  Container buildPhoneFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        onSaved: (newPhone) => this.phone = newPhone!,
        onChanged: (phone) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (phone) {
          if (phone!.isEmpty) {
            return kPhoneNumberNullError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Phone Number",
          hintText: "Enter your phone number",
          suffixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Container buildAddressFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        onSaved: (newAddress) => this.address = newAddress!,
        onChanged: (address) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (address) {
          if (address!.isEmpty) {
            return kAddressNullError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Address",
          hintText: "Eg: 123 Le Duan",
          suffixIcon: Icon(Icons.account_balance),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.streetAddress,
      ),
    );
  }

  Container buildWardFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        onSaved: (newAddress) => this.ward = newAddress!,
        onChanged: (address) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (address) {
          if (address!.isEmpty) {
            return kWardNullError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Ward",
          hintText: "Eg: Phuong Ben Nghe",
          suffixIcon: Icon(Icons.account_balance),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.streetAddress,
      ),
    );
  }

  Container buildDistrictFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        onSaved: (newAddress) => this.district = newAddress!,
        onChanged: (address) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (address) {
          if (address!.isEmpty) {
            return kDistrictNullError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "District",
          hintText: "Eg: Quan 1",
          suffixIcon: Icon(Icons.account_balance),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.streetAddress,
      ),
    );
  }

  Container buildCityFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        onSaved: (newAddress) => this.city = newAddress!,
        onChanged: (address) {
          if (firstSubmit) _formKey.currentState!.validate();
        },
        validator: (address) {
          if (address!.isEmpty) {
            return kAddressNullError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "City",
          hintText: "Eg: TPHCM",
          suffixIcon: Icon(Icons.account_balance),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.streetAddress,
      ),
    );
  }

}
