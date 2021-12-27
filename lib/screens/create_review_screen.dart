import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/widgets/star_rating_widget.dart';

class CreateReviewScreen extends StatefulWidget {
  final String id;
  CreateReviewScreen({required this.id});

  @override
  _CreateReviewScreenState createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {


  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text("WRITE REVIEW",
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),


              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:  Text(
                  "YOUR REVIEW",
                  // style: head36(context, textPrimary(context)),
                ),
              ),
              SizedBox(height:50),

              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                     color: AppColors.baseGrey40Color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write your review about our product...",
                      //hintStyle: body(context, textSecondary),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ StarRating(rating: 0, size: 12,)
              ]),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:   ElevatedButton(
                    onPressed: () {

                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: const [

                        SizedBox(width: 20),
                        Text("Create Review"),
                        SizedBox(width: 20),
                      ],
                    )),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
