import 'package:flutter/material.dart';

class PageRouting {
  static goToNextPage({required BuildContext context, required Widget navigateTo}){
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => navigateTo)
    );
  }

  static goToNextPageReplace({required BuildContext context, required Widget navigateTo}){
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => navigateTo)
    );
  }
}