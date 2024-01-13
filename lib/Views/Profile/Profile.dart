import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkisense/Models/DB/User.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/Images.dart';
import 'package:parkisense/Models/Utils/Utils.dart';

class Profile extends StatefulWidget {
  LoggedUser? loggedUser;

  Profile({Key? key, this.loggedUser}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState(loggedUser: loggedUser);
}

class _ProfileState extends State<Profile> {
  LoggedUser? loggedUser;

  _ProfileState({required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorWhite,
      body: SizedBox(
          width: displaySize.width,
          height: displaySize.height,
          child: Column(
            children: [
              Container(
                color: colorPrimary,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: colorWhite,
                        ),
                      ),
                      Text(
                        "Profile",
                        style: GoogleFonts.openSans(
                            fontSize: 18.0, color: colorWhite),
                      ),
                      const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          height: displaySize.width * 0.3,
                          width: displaySize.width * 0.3,
                          child: Stack(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  user,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ClipOval(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorBlack.withOpacity(0.5),
                                  ),
                                  height: displaySize.width * 0.3,
                                  width: displaySize.width * 0.3,
                                  child: Icon(
                                    Icons.image,
                                    color: colorWhite,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              (loggedUser != null)
                                  ? loggedUser!.name
                                  : CustomUtils.loggedInUser!.name,
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0, color: colorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email Address",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              (loggedUser != null)
                                  ? loggedUser!.email
                                  : CustomUtils.loggedInUser!.email,
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0, color: colorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Contact",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              (loggedUser != null)
                                  ? loggedUser!.mobile
                                  : CustomUtils.loggedInUser!.mobile,
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0, color: colorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lives In ",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              (loggedUser != null)
                                  ? loggedUser!.address
                                  : CustomUtils.loggedInUser!.address,
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0, color: colorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Province",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              (loggedUser != null)
                                  ? loggedUser!.province
                                  : CustomUtils.loggedInUser!.province,
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0, color: colorBlack),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Age",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              ":",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "${(loggedUser != null) ? loggedUser!.age : CustomUtils.loggedInUser!.age} years old",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.0, color: colorBlack),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
