import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/FirebaseStructure.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Widgets/custom_text_datetime_chooser.dart';
import 'package:parkisense/Views/Widgets/graph_view.dart';

class TabularAnalysis extends StatefulWidget {
  TabularAnalysis({Key? key}) : super(key: key);

  @override
  _TabularAnalysisState createState() => _TabularAnalysisState();
}

class _TabularAnalysisState extends State<TabularAnalysis> {
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
                            "Finger Analysis",
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
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SizedBox(
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
                                      ),
                                    )),
                              )),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: SizedBox(
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
                                        viewGraph();
                                      },
                                      child: const Text(
                                        "Graph View",
                                      ),
                                    )),
                              ))
                        ],
                      )
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
                              for (var rec in list)
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
                                          child: ExpansionTile(
                                            expandedCrossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            title: Text(
                                              rec['status'],
                                              style: TextStyle(
                                                  color: (rec['status']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains("no"))
                                                      ? color14
                                                      : color13,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18.0),
                                            ),
                                            subtitle: Text(
                                              getDateTime(int.parse(
                                                  rec['timestamp'].toString())),
                                              style:
                                                  TextStyle(color: colorBlack),
                                            ),
                                            children: [
                                              getFactor(rec, "ForeFingerForce"),
                                              getFactor(
                                                  rec, "MiddleFingerForce"),
                                              getFactor(rec, "PalmForce"),
                                              getFactor(rec, "RingFingerForce"),
                                              (rec['status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'parkinson')
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .only(left: 20.0),
                                                      child: Text(
                                                        "Recommendation : ${recommendationObject[
                                                                'tabular-analysis'] ??
                                                            ''}",
                                                        style: TextStyle(
                                                            color: colorBlack,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14.0),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink()
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

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.TABULARANALYSIS)
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
          print(dataRecord);
          list.add(dataRecord);
        }
      }
      setState(() {
        useFilters = false;
      });
    });
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Uint8List getImageString(String value) {
    return Uri.parse(value).data!.contentAsBytes();
  }

  getFactor(rec, key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 20.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                key.toString().toUpperCase(),
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
                  "${(rec[key] ?? '').toString().toUpperCase()}${(key != "status") ? " %" : ""}",
                  style: TextStyle(
                      color: (rec['status']
                              .toString()
                              .toLowerCase()
                              .contains("no"))
                          ? color14
                          : color13,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0),
                ),
              ))
        ],
      ),
    );
  }

  Future<void> viewGraph() async {
    if (list.isNotEmpty) {
      final List<ChartData> chartData1 = [];
      final List<ChartData> chartData2 = [];
      final List<ChartData> chartData3 = [];
      final List<ChartData> chartData4 = [];
      for (var element in list) {
        int timeDate = int.parse(element['timestamp'].toString());

        chartData1.add(ChartData(getDateTime(timeDate),
            double.parse(element['ForeFingerForce'].toString())));
        chartData2.add(ChartData(getDateTime(timeDate),
            double.parse(element['MiddleFingerForce'].toString())));
        chartData3.add(ChartData(getDateTime(timeDate),
            double.parse(element['PalmForce'].toString())));
        chartData4.add(ChartData(getDateTime(timeDate),
            double.parse(element['RingFingerForce'].toString())));
      }

      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return GraphView(
              chartData1: chartData1,
              chartData2: chartData2,
              chartData3: chartData3,
              chartData4: chartData4,
              label1: "ForeFingerForce",
              label2: "MiddleFingerForce",
              label3: "PalmForce",
              label4: "RingFingerForce",
            );
          });
    } else {
      CustomUtils.showToast("No data found to create graph");
    }
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
}
