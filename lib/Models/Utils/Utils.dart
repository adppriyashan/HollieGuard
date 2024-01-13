import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:hollieguard/Models/DB/User.dart';
import 'package:hollieguard/Models/Strings/app.dart';
import 'package:hollieguard/Models/Utils/Colors.dart';
import 'package:hollieguard/Views/PopUps/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomUtils {
  static const int DEFAULT_SNACKBAR = 1;
  static const int SUCCESS_SNACKBAR = 2;
  static const int ERROR_SNACKBAR = 3;

  static String? loggedInToken;
  static late LoggedUser? loggedInUser;
  static late String selectedUserForDoctor;

  static SharedPreferences? _prefs;
  static String userAuthToken = 'auth';
  static String disasterTypesToken = 'types';

  static Color getStatusColor(int status) {
    return [color12, color14, color3, color15][status - 1];
  }

  static Widget getEmptyList() {
    return Center(
      child: Text(
        "No Data Found",
        style: TextStyle(fontSize: 15.0, color: colorBlack),
      ),
    );
  }

  static Widget getListLoader() {
    return const Wrap(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

  static String getCurrentDate() {
    return DateFormat("yyyy/MM/dd").format(DateTime.now());
  }

  static String formatDate(DateTime date) {
    return DateFormat("yyyy/MM/dd").format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat("hh:mm a").format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat("yyyy/MM/dd hh:mm a").format(date);
  }

  static String getAgeUsingBirthdate(String date) {
    DateTime birthdate = DateFormat("yyyy/MM/dd").parse(date);
    return (DateTime.now().year - birthdate.year).toString();
  }

  static String formatTimeAPI(DateTime date) {
    return DateFormat("hh:mm:ss").format(date);
  }

  static saveDisasterTypes(String jsonTypes) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(disasterTypesToken, jsonTypes);
  }

  static Future<dynamic> getDisasterTypes() async {
    _prefs ??= await SharedPreferences.getInstance();
    return (_prefs!.containsKey(disasterTypesToken))
        ? jsonDecode(_prefs!.getString(disasterTypesToken)!)
        : false;
  }

  static saveAuth(String token) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(userAuthToken, token);
    setLoggedToken(token);
  }

  static Future<String?> getAuth() async {
    _prefs ??= await SharedPreferences.getInstance();
    setLoggedToken(_prefs!.getString(userAuthToken));
    return (loggedInToken != null) ? getToken() : loggedInToken;
  }

  static clearToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.remove(userAuthToken);
  }

  static setLoggedToken(token) {
    if (token == null) {
      return;
    }
    loggedInToken = base64.encode(utf8.encode(token));
    return loggedInToken;
  }

  static getToken() {
    return utf8.decode(base64.decode(loggedInToken!));
  }

  static getUser() {
    return loggedInUser;
  }

  static Future showLoader(context, {String? message}) async {
    await showDialog(
      context: context,
      builder: (_) => Loading(message: message),
    );
  }

  static Future<void> openMap(
      context, double latitude, double longitude) async {
    if (await canLaunchUrlString(
        "google.navigation:q=$latitude,$longitude&mode=d")) {
      await launchUrlString("google.navigation:q=$latitude,$longitude&mode=d");
    } else {
      CustomUtils.showSnackBarMessage(
          context, app_something_wrong, CustomUtils.ERROR_SNACKBAR);
    }
  }

  static Future<void> call(context, String phoneNumber) async {
    if (await canLaunchUrlString("tel://$phoneNumber")) {
      await launchUrlString("tel://$phoneNumber");
    } else {
      CustomUtils.showSnackBarMessage(
          context, app_something_wrong, CustomUtils.ERROR_SNACKBAR);
    }
  }

  static Future hideLoader(context) async {
    Navigator.pop(context);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: color11,
        textColor: color6,
        fontSize: 14.0);
  }

  static showSnackBar(context, message, int type) {
    Color backgroundColor = color6;
    Color textColor = color8;
    print(type);
    switch (type) {
      case 1:
        backgroundColor = color6;
        textColor = color8;
        break;
      case 2:
        backgroundColor = color14;
        textColor = color6;
        break;
      case 3:
        backgroundColor = color3;
        textColor = color6;
        break;
      default:
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: TextStyle(fontFamily: 'Raleway-SemiBold', color: textColor),
      ),
    ));
  }

  static showSnackBarList(context, contents, int type) {
    Color backgroundColor = color6;
    Color textColor = color8;

    switch (type) {
      case 1:
        backgroundColor = color6;
        textColor = color8;
        break;
      case 2:
        backgroundColor = color3;
        textColor = color6;
        break;
      case 3:
        backgroundColor = color6;
        textColor = color8;
        break;
      default:
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Wrap(
        children: [
          for (String message in contents)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                message,
                style:
                    TextStyle(fontFamily: 'Raleway-SemiBold', color: textColor),
              ),
            ),
        ],
      ),
    ));
  }

  static showSnackBarMessage(context, contents, int type) {
    Color backgroundColor = color6;
    Color textColor = color8;
    switch (type) {
      case 1:
        backgroundColor = color6;
        textColor = color8;
        break;
      case 2:
        backgroundColor = color3;
        textColor = color6;
        break;
      case ERROR_SNACKBAR:
        backgroundColor = color3;
        textColor = color9;
        break;
      default:
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          contents,
          style: TextStyle(fontFamily: 'Raleway-SemiBold', color: textColor),
        ),
      ),
    ));
  }

  static Future<dynamic> readJson(String filePath) async {
    final String response = await rootBundle.loadString(filePath);
    return await json.decode(response);
  }

  static String? nicValidator(String value, {bool isOptional = false}) {
    int minval = 10;

    if (isOptional && value.isEmpty) {
      return null;
    }

    Pattern pattern = r'^(?:19|20)?\d{2}[0-9]{10}|[0-9]{9}[x|X|v|V]$';

    if (value.isEmpty) {
      return 'Field is empty';
    } else if (value.length < minval) {
      return 'Typed text is less than $minval digits. ';
    } else if (value.length == 10 || value.length == 12) {
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value)) {
        return 'Enter valid national identyt card number';
      } else {
        return null;
      }
    } else {
      return 'Typed text is invalid. ';
    }
  }
}
