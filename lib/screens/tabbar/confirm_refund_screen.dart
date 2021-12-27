import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/OrderModel.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/screens/my_order_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/constants.dart';
import 'package:flutter_t_watch/util/default_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/src/widgets/image.dart' as img;

class RefundScreen extends StatefulWidget {
  final Order data;
  RefundScreen({required this.data});

  @override
  _RefundScreenState createState() => _RefundScreenState();
}

class _RefundScreenState extends State<RefundScreen> {

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  late String email;
  String token = "";
  bool firstSubmit = false;
  bool remember = false;


  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login")!;

    });
  }


  final ImagePicker _picker = ImagePicker();
  PickedFile? image;
  List<UploadImage> uploadImages = [];
  List<PickedFile> imageList = [];
  late String oneImage;
  //List<String> url = [];
  List<ImageForUpload> urlUploads = [];

  void filePicker() async {
    final PickedFile? selectImage = (await _picker.getImage(source: ImageSource.gallery));
    if(selectImage!.path.isNotEmpty){
      imageList.add(selectImage);
    }
    setState(() {

    });

    String fileName = selectImage.path.split("/").last;
    var fileImage = await dio.MultipartFile.fromFile(selectImage.path, filename: fileName, contentType: MediaType("image", "png"));

    try {
      dio.FormData formData = new dio.FormData.fromMap({
        "image": fileImage,
        "type": "image/png"
      });
      await EasyLoading.show(
        status: 'Uploading...',
        maskType: EasyLoadingMaskType.black,
      );

      var dioRequest = dio.Dio();
      var response = await dioRequest.post("https://graduate-flutter-api.herokuapp.com/api/upload",
          data: formData, options: dio.Options(
              headers: {
                //"Content-type": "multipart/form-data"
              }
          ));

      if(response.statusCode == 200){

        setState(() {
          var upImg = UploadImage.fromJson(response.data);
          oneImage = upImg.fileLocation;
          print("URL IMAGE AFTER UPLOAD: "+oneImage);
          // url.add(oneImage);
          // print("LENGTH OF URL ARRAY: "+url.length.toString());
          var value = ImageForUpload(url: oneImage);
          urlUploads.add(value);
        });

      }
      await EasyLoading.dismiss();

      // print("IMAGE PATHl: "+selectImage.path.toString());
      setState(() {
        image = selectImage;
      });
    } catch (Exception) {
      await EasyLoading.dismiss();
    }

  }


  Future<void> createRefund(String orderId, String reason, List urlUploaded) async {
    print("ORDER ID ngoai if: "+orderId);
    print("url upload length: "+urlUploaded.length.toString());
    print("reason: "+reason);
    print("date: "+DateTime.now().toString());
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    if(orderId.isNotEmpty && reason.isNotEmpty && urlUploaded.isNotEmpty){
      print("ORDER ID: "+orderId);
      print("REASON: "+reason);
      print("URL UPLOADED LENGTH: "+urlUploaded.length.toString());
      var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/orders/$orderId/refund"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "refund": {
              "reason": reason,
              "refundAt": DateTime.now().toString(),
              "images": urlUploaded
            }
          }
          ));

      if(response.statusCode == 200){

        var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/orders/${orderId}/status?stt=REFUNDING"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },);
        if(response.statusCode == 200) {
          await EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: "Refunding",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyOrderScreen()), (route) => false);
        }
        else {
          print(response.body.toString()+"stt code======"+response.statusCode.toString());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Refund Order Fail"),));
        }

      } else {
        await EasyLoading.dismiss();
        print(response.body.toString()+"stt code======"+response.statusCode.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create Refund Failed"),));
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

  }


  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text("Confirm Refund",
        style: TextStyle(
            fontSize: 18,
            color: AppColors.baseBlackColor,
            fontWeight: FontWeight.bold
        ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: AppColors.baseGrey10Color,
        body: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 10.0),
                color: AppColors.baseWhiteColor,
                //height: 1060,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildFormField(),

                      Container(
                        height: 150,
                        margin: EdgeInsets.only(bottom: 5),
                        //color: AppColors.baseWhiteColor,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                  child: image == null ? Text("No image chosen", style: TextStyle(color: Colors.white)) : img.Image.file(File(image!.path), width: 80, height: 80, fit: BoxFit.cover,)

                              ),
                              OutlinedButton(
                                  onPressed: (){
                                      filePicker();
                                    },
                                  child: const Text("Select Image")),

                            ],
                          ),
                        ),
                      ),

                      GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          shrinkWrap: true,
                          itemCount: imageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    img.Image.file(File(imageList[index].path), fit: BoxFit.cover,),
                                    Positioned(
                                        right: -84,
                                        left: -4,
                                        child: Container(
                                          height: 30,
                                          color: Color.fromRGBO(255, 255, 244, 0.7),
                                          child: IconButton(
                                            onPressed: (){
                                              imageList.removeAt(index);
                                              print("url updloads before remove: "+urlUploads.length.toString());
                                              urlUploads.removeAt(index);
                                              print("url updloads after removed: "+urlUploads.length.toString());
                                              setState(() {

                                              });
                                            },
                                            icon: Icon(Icons.delete),
                                            color: Colors.red[500],
                                          ),
                                        ))
                                  ]),
                            );
                          }),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 6,
                        width: double.infinity,
                        color: AppColors.placeholderBg,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          child:
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: DefaultButton(
                                    text: "Refund",
                                    press: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }

                                        await createRefund(widget.data.sId, email, urlUploads);
                                      }
                                      firstSubmit = true;
                                      //await updateStatus("CANCEL");
                                      //showAlertDialogRefund(context);


                                    }
                                ),
                              )
                            ],
                          )
                      )

                    ],
                  ),
                )
            )
          ],
        )
    );
  }


  Container buildFormField() {
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
            return kReasonNullError;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: "Reason",
          hintText: "Type reason you want to refund",
          suffixIcon: Icon(Icons.account_balance_wallet_outlined),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }


  showAlertDialogRefund(BuildContext context) {
    // Create button
    Widget okButton = Row(
      children: [
        TextButton(
          child: Text("Yes"),
          onPressed: () async{
            Navigator.pop(context);
            //PageRouting.goToNextPage(context: context, navigateTo: DetailOrderScreen(data: data));
            await createRefund(widget.data.sId, email, urlUploads);
          },
        ),
        TextButton(
          child: Text("No"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Refund Order"),
      content: Text("Are you sure you want to refund?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

