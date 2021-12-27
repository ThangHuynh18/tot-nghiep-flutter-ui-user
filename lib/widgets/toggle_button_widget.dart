import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
class ToggleButtonWidget extends StatefulWidget {
  const ToggleButtonWidget({Key? key}) : super(key: key);

  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {

  List<bool> isSelected = [true, false, false];
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  List<FocusNode> focusToggle = [];

  @override
  void initState() {
    // TODO: implement initState
    focusToggle = [
      focusNode1,
      focusNode2,
      focusNode3
    ];
    super.initState();
  }

  @override
  void dispose() {

    // TODO: implement dispose
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        borderWidth: 0,
        focusColor: null,
        fillColor: Colors.transparent,
        selectedColor: AppColors.baseDarkPinkColor,
        disabledColor: AppColors.baseBlackColor,
        selectedBorderColor: Colors.transparent,
        borderColor: Colors.transparent,
        focusNodes: focusToggle,

        children: [
          Icon(
            Icons.grid_view,
            size: 25,
          ),
          Icon(
            Icons.view_agenda_outlined,
            size: 25,
          ),
          Icon(
            Icons.crop_landscape_sharp,
            size: 25,
          ),
        ],
        onPressed: (int index){
          setState(() {
            for(int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++){
              if(buttonIndex == index){
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          });
        },
        isSelected: isSelected);
  }
}
