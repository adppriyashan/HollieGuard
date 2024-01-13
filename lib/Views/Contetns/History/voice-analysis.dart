import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/FirebaseStructure.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Widgets/custom_text_datetime_chooser.dart';

class VoiceAnalysis extends StatefulWidget {
  VoiceAnalysis({Key? key}) : super(key: key);

  @override
  _VoiceAnalysisState createState() => _VoiceAnalysisState();
}

class _VoiceAnalysisState extends State<VoiceAnalysis> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double topSpace = displaySize.width * 0.4;

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  bool useFilters = false;

  dynamic recommendationObject;

  @override
  void initState() {
    loadRecommendations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorWhite,
      body: SizedBox(
          width: displaySize.width,
          height: displaySize.height,
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
                    decoration: BoxDecoration(color: colorPrimary),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: colorWhite,
                            ),
                          ),
                          Text(
                            "Voice Analysis",
                            style: TextStyle(fontSize: 18.0, color: colorWhite),
                          ),
                          GestureDetector(
                            onTap: () async {
                              start.text = "";
                              end.text = "";
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
              const SizedBox(
                height: 10.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(fontSize: 16.0, color: colorBlack),
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
                      SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(colorWhite),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  colorPrimary),
                            ),
                            onPressed: () async {
                              useFilters = true;
                              getData();
                            },
                            child: const Text(
                              "Filter Records",
                            ),
                          ))
                    ],
                  ),
                ),
              ),
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
                              for (Map<dynamic, dynamic> rec in list)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      color: colorWhite,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 10.0),
                                          child: IgnorePointer(
                                            ignoring: rec['status']
                                                    .toString()
                                                    .toLowerCase() !=
                                                'parkinson',
                                            child: ExpansionTile(
                                                expandedCrossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                expandedAlignment:
                                                    Alignment.centerLeft,
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15.0),
                                                      child: Text(
                                                        rec['status'],
                                                        style: TextStyle(
                                                            color: color14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    for (MapEntry record
                                                        in rec.entries)
                                                      getFactor(record),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Text(
                                                        getDateTime(int.parse(
                                                            rec['timestamp']
                                                                .toString())),
                                                        style: TextStyle(
                                                            color: colorBlack),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                children: [
                                                  (rec['status']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'parkinson')
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      20.0,
                                                                  horizontal:
                                                                      18.0),
                                                          child: Text(
                                                            "Recommendation : ${recommendationObject['voice-analysis'] ?? ''}",
                                                            style: TextStyle(
                                                                color:
                                                                    colorBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14.0),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink()
                                                ]),
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

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.VOICEANALYSIS)
        .child(CustomUtils.loggedInUser!.type == 1
            ? CustomUtils.selectedUserForDoctor
            : CustomUtils.loggedInUser!.uid)
        .once()
        .then((DatabaseEvent data) {
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

  void loadRecommendations() {
    _databaseReference
        .child(FirebaseStructure.RECOMMENDATIONS)
        .once()
        .then((DatabaseEvent value) {
      recommendationObject = value.snapshot.value;
      getData();
    });
  }

  getFactor(MapEntry record) {
    if (record.key.toString().contains("status") ||
        record.key.toString().contains("timestamp")) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                record.key.toString(),
                style: TextStyle(
                    color: colorBlack,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              )),
          Expanded(
              flex: 0,
              child: Text(
                ":",
                style: TextStyle(
                    color: colorBlack,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              )),
          Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  record.value.toString(),
                  style: TextStyle(
                      color: color14,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0),
                ),
              ))
        ],
      ),
    );
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Uint8List getImageString(String value) {
    return Uri.parse(value).data!.contentAsBytes();
  }
}
