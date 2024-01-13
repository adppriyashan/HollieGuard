import 'package:flutter/material.dart';

class CustomeSeperator extends StatefulWidget {
  Color color;
  double horizontal = 20.0;

  CustomeSeperator({Key? key, required this.color, required this.horizontal})
      : super(key: key);

  @override
  State<CustomeSeperator> createState() => _CustomeSeperatorState(
        color: color,
        horizontal: horizontal,
      );
}

class _CustomeSeperatorState extends State<CustomeSeperator> {
  Color color;
  double horizontal;

  _CustomeSeperatorState({required this.color, required this.horizontal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 5.0),
      child: Divider(
        height: 5,
        thickness: 1,
        indent: 0,
        endIndent: 0,
        color: color,
      ),
    );
  }
}
