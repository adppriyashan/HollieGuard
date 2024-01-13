import 'package:flutter/material.dart';
import 'package:hollieguard/Models/Utils/Common.dart';

class CustomButton extends StatelessWidget {
  String buttonText;
  var textColor;
  var backgroundColor;
  bool isBorder;
  var borderColor;
  var onclickFunction;

  CustomButton(
      {Key? key,
      required this.buttonText,
      required this.textColor,
      required this.backgroundColor,
      required this.isBorder,
      required this.borderColor,
      required this.onclickFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: displaySize.width * 0.85,
      child: TextButton(
        onPressed: onclickFunction,
        style: (isBorder == true)
            ? TextButton.styleFrom(
                backgroundColor: backgroundColor,
                side: BorderSide(color: borderColor, width: 1),
              )
            : TextButton.styleFrom(
                backgroundColor: backgroundColor,
              ),
        child: Text(
          buttonText,
          style: TextStyle(color: textColor, fontFamily: 'Raleway-SemiBold'),
        ),
      ),
    );
  }
}
