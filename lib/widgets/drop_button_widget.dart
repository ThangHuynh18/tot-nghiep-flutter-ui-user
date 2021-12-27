import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/styles/detail_screen_stylies.dart';
class DropButton extends StatefulWidget {
  final String hintText;
  String? ratringController;
  final List<String> items;
  DropButton({required this.hintText, required this.ratringController, required this.items});

  @override
  _DropButtonState createState() => _DropButtonState();
}

class _DropButtonState extends State<DropButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          fillColor: AppColors.baseWhiteColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0)
          )
        ),
        hint: Text(widget.hintText, style: DetailScreenStylies.productDropDownValueStyle,),
        value: widget.ratringController,
        items: widget.items.map((e) => DropdownMenuItem(child: Text(e), value: e,)).toList(),
        onChanged: (value) {
          setState(() {
            widget.ratringController = value;
          });
        },
      ),
    );
  }
}
