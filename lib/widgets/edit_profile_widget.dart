import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/profile_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/constants.dart';
import 'package:flutter_t_watch/util/default_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileWidget extends StatefulWidget {
  final Profile dataProfile;
  EditProfileWidget({required this.dataProfile});

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  String token = "";
  late String name, email, phone, address, ward, district, city, urlAvatar;

  bool firstSubmit = false;
  bool remember = false;

  final ImagePicker _picker = ImagePicker();
  PickedFile? image;
  List<UploadImage> uploadImages = [];


  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login")!;
      //userId = pref.getString("userId")!;
    });
  }

  void filePicker() async {
    final PickedFile? selectImage = (await _picker.getImage(source: ImageSource.gallery));

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

    print("STATUS CODE UPLOAD: "+response.statusCode.toString());
    if(response.statusCode == 200){

      setState(() {
        var upImg = UploadImage.fromJson(response.data);
        urlAvatar = upImg.fileLocation;
        print("URL IMAGE AFTER UPLOAD: "+urlAvatar);
      });

    }


    // print("IMAGE PATHl: "+selectImage.path.toString());
    setState(() {
      image = selectImage;
    });
  }


  Future<void> update(String name, String email, String phone, String address, String ward, String district, String city, String avatar) async {
    await EasyLoading.show(
      status: 'Updating...',
      maskType: EasyLoadingMaskType.black,
    );
    if(email.isNotEmpty  && name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty && ward.isNotEmpty && district.isNotEmpty && city.isNotEmpty){
      print("URL AVATAR IN REGISTER FUNC: "+avatar);
      var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/users/profile"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "phone": phone,
            "avatar": avatar,
            "shippingAddress": {
              "address": address,
              "city": city,
              "district": district,
              "ward": ward
            }
          }
          ));

      if(response.statusCode == 200){
       // final body = json.decode(response.body);
        Fluttertoast.showToast(
            msg: "Update Profile Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        await EasyLoading.dismiss();
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => ProfileScreen()), (route) => false);
        //PageRouting.goToNextPage(context: context, navigateTo: ProfileScreen());
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 3)), (Route<dynamic> route) => false);

      } else {
        await EasyLoading.dismiss();
        print(response.body.toString()+"stt code======"+response.statusCode.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update Failed"),));
      }
    }
    else {
      await EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Blank Field Not Allowed"),));

    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    name = widget.dataProfile.name;
    phone = widget.dataProfile.phone;
    email = widget.dataProfile.email;
    urlAvatar = widget.dataProfile.avatar;
    address = widget.dataProfile.shippingAddress.address;
    ward = widget.dataProfile.shippingAddress.ward;
    district = widget.dataProfile.shippingAddress.district;
    city = widget.dataProfile.shippingAddress.city;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          SizedBox(height: 8,),
          Container(
              width: 40 * 3,
              height: 40 * 3,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(urlAvatar),
                  ))),
          Container(
                height: 30,
                color: Color.fromRGBO(255, 255, 244, 0.7),
                child: IconButton(
                  onPressed: (){
                    filePicker();

                  },
                  icon: Icon(Icons.photo_camera),
                  color: Colors.blue[500],
                ),
              ),

          buildNameFormField(),
          buildEmailFormField(),
          //SizedBox(height: 30),
          //buildPasswordFormField(),
          buildPhoneFormField(),
          buildAddressFormField(),
          buildWardFormField(),
          buildDistrictFormField(),
          buildCityFormField(),

          //SizedBox(height: 30),
          DefaultButton(
            text: "Update",
            press: () async{
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                await update(name, email, phone, address, ward, district, city, urlAvatar);
              }
              firstSubmit = true;
            },
          ),
        ],
      ),
    );
  }

  //
  // Container buildPasswordFormField() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 40,
  //       vertical: 20,
  //     ),
  //     child: TextFormField(
  //       onSaved: (newPassword) => this.password = newPassword!,
  //       onChanged: (password) {
  //         if (firstSubmit) _formKey.currentState!.validate();
  //       },
  //       validator: (password) {
  //         if (password!.isEmpty) {
  //           return kPassNullError;
  //         } else if (password.isNotEmpty && password.length <= 5) {
  //           return kShortPassError;
  //         }
  //
  //         return null;
  //       },
  //       decoration: InputDecoration(
  //         labelText: "Password",
  //         hintText: "Enter your password",
  //         suffixIcon: Icon(Icons.password),
  //         border: OutlineInputBorder(),
  //       ),
  //       obscureText: true,
  //     ),
  //   );
  // }

  Container buildEmailFormField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: TextFormField(
        initialValue: email,
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
        initialValue: name,
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
        initialValue: phone,
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
        initialValue: address,
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
        initialValue: ward,
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
        initialValue: district,
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
        initialValue: city,
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
