import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:parkisense/Models/Utils/Colors.dart';

// ignore: must_be_immutable
class CustomRichText extends StatelessWidget {
  double height = 5.0;
  Color backgroundColor;
  HtmlEditorController controller;
  var label;

  CustomRichText(
      {Key? key,
      this.label,
      required this.height,
      required this.backgroundColor,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        (label != null)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: color11),
                ),
              )
            : const SizedBox.shrink(),
        Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5.0)),
            padding: EdgeInsets.symmetric(vertical: height, horizontal: 5.0),
            child: HtmlEditor(
              controller: controller,
              htmlEditorOptions: const HtmlEditorOptions(
                hint: "Your text here...",
              ),
              otherOptions: const OtherOptions(
                height: 200,
              ),
            ))
      ],
    );
  }
}
