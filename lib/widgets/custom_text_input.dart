import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    required String hintText,
    EdgeInsets padding = const EdgeInsets.only(left: 40),

  })  : _hintText = hintText,
        _padding = padding;


  final String _hintText;
  final EdgeInsets _padding;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const ShapeDecoration(
        color: AppColors.placeholderBg,
        shape: StadiumBorder(),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _hintText,
          hintStyle: const TextStyle(
            color: AppColors.placeholder,
          ),
          contentPadding: _padding,
        ),
      ),
    );
  }
}


class CustomTextInputAddress extends StatelessWidget {
  const CustomTextInputAddress({
    required String hintText,
    required TextEditingController controller,
    EdgeInsets padding = const EdgeInsets.only(left: 40),

  })  : _hintText = hintText,
        _controller = controller,
        _padding = padding;


  final String _hintText;
  final EdgeInsets _padding;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const ShapeDecoration(
        color: AppColors.placeholderBg,
        shape: StadiumBorder(),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _hintText,
          hintStyle: const TextStyle(
            color: AppColors.placeholder,
          ),
          contentPadding: _padding,
        ),
      ),
    );
  }
}


class CustomTextInputQtyInCart extends StatelessWidget {
  const CustomTextInputQtyInCart({
    required String hintText,
    required TextEditingController controller,
    EdgeInsets padding = const EdgeInsets.only(left: 40),

  })  : _hintText = hintText,
        _controller = controller,
        _padding = padding;


  final String _hintText;
  final EdgeInsets _padding;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const ShapeDecoration(
        color: AppColors.placeholderBg,
        shape: StadiumBorder(),
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _hintText,
          hintStyle: const TextStyle(
            color: AppColors.placeholder,
          ),
          contentPadding: _padding,
        ),
      ),
    );
  }
}

class CustomTextInputQty extends StatelessWidget {
  const CustomTextInputQty({
    required String hintText,
    required String controller,
    EdgeInsets padding = const EdgeInsets.only(left: 40),

  })  : _hintText = hintText,
        _controller = controller,
        _padding = padding;


  final String _hintText;
  final EdgeInsets _padding;
  final String _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10,
      decoration: const ShapeDecoration(
        color: AppColors.placeholderBg,
        shape: StadiumBorder(),
      ),
      child: TextFormField(
        initialValue: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _hintText,
          hintStyle: const TextStyle(
            color: AppColors.placeholder,
          ),
          contentPadding: _padding,
        ),
      ),
    );
  }
}
