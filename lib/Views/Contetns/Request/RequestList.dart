import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:parkisense/Controllers/MessageRequestController.dart';
import 'package:parkisense/Models/DB/MessageRequest.dart';
import 'package:parkisense/Models/DB/User.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/FirebaseStructure.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Contetns/Chat/Chat.dart';
import 'package:parkisense/Views/Contetns/History/brain_analysis.dart';
import 'package:parkisense/Views/Contetns/History/sprial_analysis.dart';
import 'package:parkisense/Views/Contetns/History/tabular_analysis.dart';
import 'package:parkisense/Views/Contetns/History/voice-analysis.dart';
import 'package:parkisense/Views/Profile/Profile.dart';

class RequestList extends StatefulWidget {
  dynamic requestDoctor;

  RequestList({Key? key, this.requestDoctor}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState(requestDoctor);
}

class _RequestListState extends State<RequestList> {
  dynamic? requestDoctor;

  _RequestListState(this.requestDoctor);

  final MessageRequestController _controller = MessageRequestController();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
          width: displaySize.width,
          height: displaySize.height,
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
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
                            "Chat Request",
                            style: GoogleFonts.openSans(
                                fontSize: 18.0, color: colorWhite),
                          ),
                          Visibility(
                              visible: (CustomUtils.loggedInUser!.type == 2),
                              child: GestureDetector(
                                onTap: () => enrollment(true, null),
                                child: Icon(
                                  Icons.add,
                                  color: colorWhite,
                                ),
                              ))
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FutureBuilder<List<Request>>(
                        future: _controller.getList(requestDoctor != null
                            ? requestDoctor['uid']
                            : null),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data!.isNotEmpty) {
                              return ListView(
                                children: snapshot.data!
                                    .map((Request _record) => Card(
                                          child: ListTile(
                                              style: ListTileStyle.list,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 15.0),
                                              tileColor: [
                                                colorGreen,
                                                color12,
                                                colorRed,
                                                color2
                                              ][_record.status - 1],
                                              title: Text(
                                                (CustomUtils.loggedInUser!
                                                            .type ==
                                                        1)
                                                    ? _record.patientname
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    : 'Dr. ' +
                                                        _record.doctorname,
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: colorWhite),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getDateTime(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            _record.date
                                                                as int)),
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 12.0,
                                                        color: colorWhite),
                                                  ),
                                                ],
                                              ),
                                              trailing: (_record.status != 3 && (_record.status == 1 ||
                                                      CustomUtils.loggedInUser!
                                                              .type ==
                                                          1))
                                                  ? PopupMenuButton(
                                                      iconColor: colorWhite,
                                                      itemBuilder: (context) {
                                                        return getSubMenu(
                                                            _record);
                                                      },
                                                    )
                                                  : const SizedBox.shrink()),
                                        ))
                                    .toList(),
                              );
                            } else {
                              return CustomUtils.getEmptyList();
                            }
                          } else {
                            return CustomUtils.getListLoader();
                          }
                        }),
                  ))
            ],
          )),
    ));
  }

  getDateTime(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd kk:mm a').format(dateTime);
  }

  enrollment(bool isNew, medicalCategory) async {
    await _controller.enrollment(
        context, requestDoctor!, DateTime.now().millisecondsSinceEpoch);

    setState(() {});
  }

  List<PopupMenuItem> getSubMenu(record) {
    List<PopupMenuItem> menuList = [];

    if (CustomUtils.loggedInUser!.type == 1 && record.status == 2) {
      menuList.add(PopupMenuItem(
        onTap: () async => await _controller
            .approveOrReject(
                context, record.patient, record.doctor, record.id, 1)
            .then((value) => setState(() {})),
        child: const Text('Approve'),
      ));
      menuList.add(PopupMenuItem(
        onTap: () async => await _controller
            .approveOrReject(
                context, record.patient, record.doctor, record.id, 3)
            .then((value) => setState(() {})),
        child: const Text('Reject'),
      ));
    }

    if (record.status == 1) {
      menuList.add(PopupMenuItem(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => Chat(record))),
        child: const Text('Chat'),
      ));

      if (CustomUtils.loggedInUser!.type == 1) {
        menuList.add(PopupMenuItem(
          onTap: () {
            CustomUtils.selectedUserForDoctor = record.patient;
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => TabularAnalysis()));
          },
          child: const Text('Finger Analysis History'),
        ));
        menuList.add(PopupMenuItem(
          onTap: () {
            CustomUtils.selectedUserForDoctor = record.patient;
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SpiralAnalysis()));
          },
          child: const Text('Spiral Analysis History'),
        ));
        menuList.add(PopupMenuItem(
          onTap: () {
            CustomUtils.selectedUserForDoctor = record.patient;
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => BrainAnalysis()));
          },
          child: const Text('Brain Analysis History'),
        ));
        menuList.add(PopupMenuItem(
          onTap: () {
            CustomUtils.selectedUserForDoctor = record.patient;
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => VoiceAnalysis()));
          },
          child: const Text('Voice Analysis History'),
        ));
        menuList.add(PopupMenuItem(
          onTap: () {
            _databaseReference
                .child(FirebaseStructure.USERS)
                .child(record.patient)
                .once()
                .then((DatabaseEvent data) {
              Map<dynamic, dynamic> profileUserData =
                  data.snapshot.value as Map;
              if (data.snapshot.value != null) {}
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Profile(
                            loggedUser: LoggedUser(
                                name: profileUserData['name'],
                                address: profileUserData['address'],
                                age: profileUserData['age'],
                                email: profileUserData['email'],
                                mobile: profileUserData['mobile'],
                                type: profileUserData['type'],
                                province: profileUserData['province'],
                                uid: data.snapshot.key),
                          )));
            });
          },
          child: const Text('User Profile'),
        ));
      }
    }

    return menuList;
  }
}
