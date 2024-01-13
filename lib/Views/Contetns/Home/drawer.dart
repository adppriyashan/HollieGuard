import 'package:flutter/material.dart';
import 'package:parkisense/Controllers/AuthController.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/Images.dart';
import 'package:parkisense/Models/Utils/Routes.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Contetns/History/brain_analysis.dart';
import 'package:parkisense/Views/Contetns/History/sprial_analysis.dart';
import 'package:parkisense/Views/Contetns/History/tabular_analysis.dart';
import 'package:parkisense/Views/Contetns/History/voice-analysis.dart';
import 'package:parkisense/Views/Contetns/Prediction/prediction.dart';
import 'package:parkisense/Views/Contetns/Recommandation/recommandation.dart';
import 'package:parkisense/Views/Profile/Profile.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  AuthController _authController = AuthController();

  List<Widget> userMenus = [];

  @override
  Widget build(BuildContext context) {
    if (CustomUtils.loggedInUser!.type == 2) {
      userMenus = [
        ListTile(
          onTap: () => Routes(context: context).navigate(TabularAnalysis()),
          tileColor: color6,
          leading: Icon(
            Icons.fingerprint,
            color: color15,
          ),
          title: Text(
            'Finger Analysis',
            style: TextStyle(color: color15, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color15,
            size: 15.0,
          ),
        ),
         ListTile(
          onTap: () => Routes(context: context).navigate(SpiralAnalysis()),
          tileColor: color6,
          leading: Icon(
            Icons.spatial_tracking,
            color: color15,
          ),
          title: Text(
            'Spiral Analysis',
            style: TextStyle(color: color15, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color15,
            size: 15.0,
          ),
        ),
        
        ListTile(
          onTap: () => Routes(context: context).navigate(BrainAnalysis()),
          tileColor: color6,
          leading: Icon(
            Icons.scanner,
            color: color15,
          ),
          title: Text(
            'Brain Analysis',
            style: TextStyle(color: color15, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color15,
            size: 15.0,
          ),
        ),
        ListTile(
          onTap: () => Routes(context: context).navigate(VoiceAnalysis()),
          tileColor: color6,
          leading: Icon(
            Icons.voice_chat,
            color: color15,
          ),
          title: Text(
            'Voice Analysis',
            style: TextStyle(color: color15, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color15,
            size: 15.0,
          ),
        ),
       
        ListTile(
          onTap: () => Routes(context: context).navigate(Prediction()),
          tileColor: color6,
          leading: Icon(
            Icons.upload_outlined,
            color: color15,
          ),
          title: Text(
            'Prediction',
            style: TextStyle(color: color15, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color15,
            size: 15.0,
          ),
        ),
      ];
    } else {
      userMenus = [
        ListTile(
          onTap: () =>
              Routes(context: context).navigate(const Recommendation()),
          tileColor: color6,
          leading: Icon(
            Icons.recommend_outlined,
            color: color15,
          ),
          title: Text(
            'Recommendation',
            style: TextStyle(color: color15, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color15,
            size: 15.0,
          ),
        )
      ];
    }

    return Container(
      width: displaySize.width * 0.8,
      decoration: BoxDecoration(color: color6),
      child: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: displaySize.height * 0.15,
            child: Container(
                decoration: BoxDecoration(color: colorPrimary),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 12.0, left: 15.0, right: 15.0),
                  child: GestureDetector(
                    onTap: () =>
                        Routes(context: context).navigate(Profile()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: ClipOval(
                            child: Image.asset(
                              user,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CustomUtils.loggedInUser!.name,
                                  style: TextStyle(
                                      color: color6,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  CustomUtils.loggedInUser!.email,
                                  style: TextStyle(
                                      color: color6,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  CustomUtils.loggedInUser!.mobile,
                                  style: TextStyle(
                                      color: color6,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
          ),
          ListTile(
            onTap: () => Navigator.pop(context),
            tileColor: color6,
            leading: Icon(
              Icons.home_outlined,
              color: color15,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: color15, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color15,
              size: 15.0,
            ),
          ),
          for (Widget menu in userMenus) menu,
          ListTile(
            onTap: () => _authController.logout(context),
            tileColor: color6,
            leading: Icon(
              Icons.logout_outlined,
              color: color15,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: color15, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color15,
              size: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
