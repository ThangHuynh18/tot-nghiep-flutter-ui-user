import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/styles/detail_screen_stylies.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  String? genderController;
  String? categoryController;

  RangeValues currentRangeValues = const RangeValues(30, 100);

  AppBar buildAppBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text("Filter",
      style: TextStyle(
        color: AppColors.baseBlackColor
      ),),
    );
  }


  Widget buildListTile({required String title}){
    return ListTile(
      title: Text(title,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.baseBlackColor
        ),),
    );
  }


  Widget buildExpansionTile({required List<String> items, required String title, required String hint, required String? boxValue}){
    return ExpansionTile(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    fillColor: AppColors.basewhite60Color,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0)
                    )
                ),
                iconSize: 30,
                hint: Text(
                  hint,
                  style: DetailScreenStylies.productDropDownValueStyle,
                ),
                value: boxValue,
                items: items.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                onChanged: (String? value){
                  setState(() {
                    boxValue = value;
                  });
                },
              )
            ],
          ),
        )
      ],
      title: Text(title,
          style: TextStyle(
              fontSize: 16,
              color: AppColors.baseBlackColor,
              fontWeight: FontWeight.bold
          )),

    );
  }


  Widget buildPriceExpansionTile(){
    return ExpansionTile(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              RangeSlider(
                values: currentRangeValues,
                min: 0,
                max: 1000,
                labels: RangeLabels(
                    currentRangeValues.start.round().toString(),
                    currentRangeValues.end.round().toString()
                ),
                onChanged: (RangeValues values){
                  setState(() {
                    currentRangeValues = values;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$${currentRangeValues.start.toInt()}",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.baseBlackColor
                  ),),
                  Text("\$${currentRangeValues.end.toInt()}",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.baseBlackColor
                    ),),
                ],
              )
            ],
          ),
        )
      ],
      title: Text("Price", style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.baseBlackColor
      ),),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          buildListTile(title: "Most popular"),
          Divider(),
          buildListTile(title: "New Items"),
          Divider(),
          buildListTile(title: "Price: High - Low"),
          Divider(),
          buildListTile(title: "Price: Low - High"),
          Divider(),
          buildExpansionTile(items: ["woman", "men","kids"], title: "Gender", hint: "Gender", boxValue: genderController),
          Divider(),
          buildExpansionTile(items: ["T-shirt", "Jacket","Sneaker"], title: "Category", hint: "Category", boxValue: categoryController),
          Divider(),
          
          buildPriceExpansionTile(),

          Container(
            margin: EdgeInsets.all(20.0),
            width: double.infinity,
            child: MaterialButton(
              color: Colors.black,
              height: 45,
              elevation: 0,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              onPressed:(){

              },
              child: Text(
                "View more item",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
