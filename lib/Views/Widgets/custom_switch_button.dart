import 'package:flutter/cupertino.dart';
import 'package:hollieguard/Models/Utils/Colors.dart';

class CustomSwitchButton extends StatefulWidget {
  CustomSwitchButton({Key? key}) : super(key: key);

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoSwitch(
            value: _switchValue,
            activeColor: color10,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
              });
            },
          )
          // Switch(
          //   value: isSwitched,
          //   activeColor: color10,
          //   onChanged: (value) {
          //     print("VALUE : $value");
          //     setState(() {
          //       isSwitched = value;
          //     });
          //   },
          // ),
        ]);
  }
}
