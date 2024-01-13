import 'package:flutter/material.dart';

class Routes {
  BuildContext context;
  var data;

  Routes({required this.context, this.data});

  Future<dynamic> navigate(Widget screen) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<dynamic> navigateReplace(Widget screen) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  back() {
    Navigator.pop(context);
  }
}
