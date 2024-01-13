import 'package:flutter/material.dart';
import 'package:parkisense/Models/Utils/Colors.dart';

class CustomDropDown extends StatelessWidget {
  String dropdown_value;
  String leading_image;
  var leading_icon;
  var leading_icon_color;
  Color action_icon_color;
  Color text_color;
  Color background_color;
  Color underline_color;
  var function;
  var items;
  var label = null;

  CustomDropDown({
    required this.dropdown_value,
    this.label,
    this.leading_image = '',
    this.leading_icon,
    this.leading_icon_color,
    required this.action_icon_color,
    required this.text_color,
    required this.background_color,
    required this.underline_color,
    required this.function,
    required this.items,
  });

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
                color: background_color,
                borderRadius: BorderRadius.circular(5.0)),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              children: [
                (leading_image != '')
                    ? Expanded(flex: 0, child: Image.asset(leading_image))
                    : const SizedBox.shrink(),
                (leading_icon != null)
                    ? Expanded(
                        flex: 0,
                        child: Icon(
                          leading_icon,
                          color: leading_icon_color,
                        ))
                    : const SizedBox.shrink(),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdown_value,
                        dropdownColor: color6,
                        elevation: 5,
                        style: TextStyle(color: color8),
                        underline: Container(
                          height: 2,
                          color: underline_color,
                        ),
                        onChanged: function,
                        items: items),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
