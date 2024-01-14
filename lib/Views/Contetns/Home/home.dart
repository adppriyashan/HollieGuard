import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hollieguard/Models/Strings/app.dart';
import 'package:hollieguard/Models/Utils/Colors.dart';
import 'package:hollieguard/Models/Utils/Common.dart';
import 'package:hollieguard/Models/Utils/FirebaseStructure.dart';
import 'package:hollieguard/Models/Utils/Images.dart';
import 'package:hollieguard/Views/Widgets/custom_dropdown.dart';
import 'package:intl/intl.dart';
import '../../Widgets/custom_text_datetime_chooser.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  bool useFilters = false;
  bool showFilters = false;

  String? authStatus;

  final List<DropdownMenuItem<String>> _authStatusList = [
    DropdownMenuItem(
        value: "Not Selected",
        alignment: Alignment.centerLeft,
        enabled: true,
        child: Text("Not Selected",
            style: TextStyle(color: colorBlack, fontSize: 15.0))),
    DropdownMenuItem(
        value: "Authorized User",
        alignment: Alignment.centerLeft,
        enabled: true,
        child: Text("Authorized User",
            style: TextStyle(color: colorBlack, fontSize: 15.0))),
    DropdownMenuItem(
        value: "Unauthorized User",
        alignment: Alignment.centerLeft,
        enabled: true,
        child: Text("Unauthorized User",
            style: TextStyle(color: colorBlack, fontSize: 15.0)))
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
      initNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
        body: SafeArea(
          child: SizedBox(
              width: displaySize.width,
              height: displaySize.height,
              child: Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showFilters = !showFilters;
                                  });
                                },
                                child: Icon(
                                  (showFilters) ? Icons.menu_open : Icons.menu,
                                  color: colorWhite,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: displaySize.width * 0.08,
                                    child: Image.asset(logo),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      app_name,
                                      style: TextStyle(
                                          fontSize: 16.0, color: color7),
                                    ),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  start.text = "";
                                  end.text = "";
                                  authStatus = _authStatusList.first.value;
                                  getData();
                                },
                                child: Icon(
                                  Icons.refresh,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  (showFilters)
                      ? AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontSize: 16.0, color: colorBlack),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CustomTextDateTimeChooser(
                                        height: 5.0,
                                        controller: start,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'Start',
                                        icon: Icons.calendar_month,
                                        textInputType: TextInputType.text,
                                        validation: (value) {
                                          return null;
                                        },
                                        obscureText: false),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CustomTextDateTimeChooser(
                                        height: 5.0,
                                        controller: end,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'End',
                                        icon: Icons.safety_check,
                                        textInputType: TextInputType.text,
                                        validation: (value) {
                                          return null;
                                        },
                                        obscureText: false),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  (_authStatusList.isNotEmpty)
                                      ? CustomDropDown(
                                          dropdown_value: authStatus ??
                                              (_authStatusList.first.value ??
                                                  'Not Selected'),
                                          action_icon_color: colorBlack,
                                          text_color: colorBlack,
                                          background_color: color7,
                                          underline_color: color6,
                                          leading_icon:
                                              Icons.maps_home_work_outlined,
                                          leading_icon_color: colorPrimary,
                                          function: (value) {
                                            setState(() {
                                              if (value != 'Not Selected') {
                                                useFilters = true;
                                              }
                                              authStatus = value;
                                            });
                                          },
                                          items: _authStatusList)
                                      : const SizedBox.shrink(),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorWhite),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorPrimary),
                                        ),
                                        onPressed: () async {
                                          useFilters = true;
                                          getData();
                                        },
                                        child: const Text(
                                          "Filter Records",
                                          style: TextStyle(),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: colorWhite,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 15.0, left: 5.0, right: 5.0),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var rec in list)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Card(
                                          color: colorWhite,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 10.0),
                                              child: ExpansionTile(
                                                expandedCrossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                leading: Icon(
                                                  Icons.history_sharp,
                                                  color: colorBlack,
                                                  size: 35.0,
                                                ),
                                                title: Text(
                                                  (rec['status'] ?? '')
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: colorBlack,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15.0),
                                                ),
                                                subtitle: Text(
                                                  getDateTime(int.parse(
                                                      rec['timestamp']
                                                          .toString())),
                                                  style: TextStyle(
                                                      color: colorBlack,
                                                      fontSize: 12.0),
                                                ),
                                                children: [
                                                  getCardRecord(
                                                      'Face ID',
                                                      rec['face_id']
                                                          .toString()),
                                                  getCardRecord(
                                                      'Finger ID',
                                                      rec['finger_id']
                                                          .toString()),
                                                  getCardRecord(
                                                      'Logged By Password',
                                                      rec['password_login']
                                                                  .toString() ==
                                                              'true'
                                                          ? 'YES'
                                                          : 'NO'),
                                                  getCardRecord(
                                                      'RFID', rec['rf_id']),
                                                  getCardRecord(
                                                      'Name of the user',
                                                      rec['u_name'])
                                                ],
                                              )),
                                        ),
                                      ),
                                    )
                                ]),
                          ),
                        ),
                      ))
                ],
              )),
        ));
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Future<void> getData() async {
    dynamic ref = _databaseReference.child(FirebaseStructure.HISTORY);

    if (authStatus != null && authStatus != '"Not Selected"') {
      ref = ref.orderByChild("status").equalTo(authStatus);
    }

    ref.once().then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        dynamic dataRecord = element.value;

        if (useFilters == true &&
            start.text.isNotEmpty &&
            end.text.isNotEmpty) {
          DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(dataRecord['timestamp'].toString()));
          if (currentDateTime.isAfter(
                  DateFormat("yyyy/MM/dd hh:mm a").parse(start.text)) &&
              currentDateTime
                  .isBefore(DateFormat("yyyy/MM/dd hh:mm a").parse(end.text))) {
            list.add(dataRecord);
          }
        } else {
          list.add(dataRecord);
        }
      }
      setState(() {
        useFilters = false;
      });
    });
  }

  void initNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        _databaseReference
            .child(FirebaseStructure.NOTIFICATIONS)
            .onValue
            .listen((DatabaseEvent data) async {
          dynamic noti = data.snapshot.value;
          if (noti['status'] == true) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: -1,
                    channelKey: 'emergency_hollieguard',
                    title: 'Emergency Notification',
                    body: noti['message'].toString()));

            await _databaseReference
                .child(FirebaseStructure.NOTIFICATIONS)
                .child('status')
                .set(false);
          }
        });
      }
    });
  }

  getCardRecord(title, rec) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: colorBlack),
          ),
          Text(
            rec,
            style: TextStyle(color: colorBlack),
          ),
        ],
      ),
    );
  }
}
