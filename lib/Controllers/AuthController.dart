import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hollieguard/Models/DB/User.dart';
import 'package:hollieguard/Models/Utils/FirebaseStructure.dart';
import 'package:hollieguard/Models/Utils/Utils.dart';
import 'package:hollieguard/Views/Auth/Login.dart';
import 'package:flutter/material.dart';

class AuthController {
  static late FirebaseAuth _auth;
  late DatabaseReference _databaseRef;

  AuthController() {
    _auth = FirebaseAuth.instance;
    _databaseRef = FirebaseDatabase.instance.ref();
  }

  Future<bool> doRegistration(data) async {
    bool check = true;

    await _auth
        .createUserWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    )
        .then((value) async {
      data.remove('password');

      await _databaseRef
          .child(FirebaseStructure.USERS)
          .child(value.user!.uid)
          .set(data);

      CustomUtils.showToast('Successfully Registered. Please Login Now.');
    }).catchError((e) {
      check = false;
      CustomUtils.showToast(e.toString());
    });

    return check;
  }

  Future<bool> doLogin(data) async {
    bool check = true;

    await _auth
        .signInWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    )
        .catchError((e) {
      check = false;

      late String errorMessage;

      switch (e.code) {
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'Invalid credentails.';
          break;
        case 'user-disabled':
          errorMessage = 'Account has been disabled.';
          break;
        default:
          errorMessage = 'Something wrong.';
      }

      CustomUtils.showToast(errorMessage);
    }).then((value) async {
      CustomUtils.loggedInUser = await getUserData();
    });

    return check;
  }

  Future<void> logout(context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Login()));
  }

  Future<LoggedUser> getUserData() async {
    late LoggedUser user;
    await _databaseRef
        .child(FirebaseStructure.USERS)
        .child(_auth.currentUser!.uid)
        .once()
        .then((DatabaseEvent event) async {
      Map<dynamic, dynamic> profileUserData = event.snapshot.value as Map;
      if (event.snapshot.value != null) {
        user = LoggedUser(
            name: profileUserData['name'],
            address: profileUserData['address'],
            age: profileUserData['age'],
            email: _auth.currentUser!.email,
            mobile: profileUserData['mobile'],
            type: profileUserData['type'],
            province: profileUserData['province'],
            uid: _auth.currentUser!.uid);
      }
    });

    return user;
  }

  Future<bool> doLoginCheck() async {
    bool check = false;
    return check;
  }

  Future<dynamic> sendPasswordResetLink(context, email) async {
    dynamic check = false;
    _auth.sendPasswordResetEmail(email: email).then((value) => check = true);
    return check;
  }
}
