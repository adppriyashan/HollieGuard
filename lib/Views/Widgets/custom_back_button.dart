import 'package:flutter/material.dart';
import 'package:hollieguard/Models/Utils/Colors.dart';

class CustomCustomBackButton extends StatefulWidget {
  var onclickFunction;

  CustomCustomBackButton({Key? key, required this.onclickFunction})
      : super(key: key);

  @override
  State<CustomCustomBackButton> createState() => _CustomCustomBackButtonState(
        onclickFunction: onclickFunction,
      );
}

class _CustomCustomBackButtonState extends State<CustomCustomBackButton> {
  var onclickFunction;

  _CustomCustomBackButtonState({required this.onclickFunction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        onPressed: onclickFunction,
        child:  Icon(Icons.arrow_back, color: color11),
      ),
    );
  }
}
