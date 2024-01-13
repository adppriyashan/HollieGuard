import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parkisense/Models/Strings/app.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/FirebaseStructure.dart';
import 'package:parkisense/Models/Utils/Images.dart';
import 'package:badges/badges.dart' as badges;
import 'package:parkisense/Models/Utils/Routes.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Contetns/Home/drawer.dart';
import 'package:parkisense/Views/Contetns/Request/RequestList.dart';
import 'package:parkisense/Views/Doctors/doctor.dart';
import 'package:parkisense/Views/Widgets/graph_view.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  ValueNotifier<double> param1 = ValueNotifier(0);
  ValueNotifier<double> param2 = ValueNotifier(0);
  ValueNotifier<double> param3 = ValueNotifier(0);
  ValueNotifier<double> param4 = ValueNotifier(0);

  List<String> provinceList = [
    'Western',
    'Uva',
    'Southern',
    'Sabaragamuwa',
    'North Western',
    'Northern',
    'North Central',
    'Eastern',
    'Central'
  ];

  int statusCount = 0;
  int hollieguardCount = 0;
  int userCount = 0;
  Map<String, int> hollieguardProvince = {};

  final List<ChartData> chartData = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (CustomUtils.loggedInUser!.type == 2) {
        getLiveData();
        getStatusCount();
      } else {
        loadStatistics();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(),
        resizeToAvoidBottomInset: false,
        backgroundColor: colorSecondary,
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
                                onTap: () => (_scaffoldKey
                                        .currentState!.isDrawerOpen)
                                    ? _scaffoldKey.currentState!.openEndDrawer()
                                    : _scaffoldKey.currentState!.openDrawer(),
                                child: Icon(
                                  Icons.menu_rounded,
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
                                onTap: () => Routes(context: context).navigate(
                                    (CustomUtils.loggedInUser!.type == 2)
                                        ? const Doctor()
                                        : RequestList()),
                                child: Icon(
                                  (CustomUtils.loggedInUser!.type == 2)
                                      ? Icons.medical_services_outlined
                                      : Icons.message_outlined,
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
                  (CustomUtils.loggedInUser!.type == 2)
                      ? Expanded(child: Image.asset(homeBg))
                      : Expanded(
                          flex: 0,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 15.0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 15.0),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: colorWhite),
                                            color: colorSecondary,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Total",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: colorWhite),
                                            ),
                                            Text(
                                              "User Count",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: colorWhite),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Text(
                                                userCount
                                                    .toString()
                                                    .padLeft(2, '0'),
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: colorWhite),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 15.0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 20.0),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: colorWhite),
                                            color: colorSecondary,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Total",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: colorWhite),
                                            ),
                                            Text(
                                              "hollieguard Count",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: colorWhite),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: Text(
                                                hollieguardCount
                                                    .toString()
                                                    .padLeft(2, '0'),
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: color13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          )),
                  (CustomUtils.loggedInUser!.type == 2)
                      ? Expanded(flex: 0, child: getLiveWidgets())
                      : Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              SfCircularChart(series: <CircularSeries>[
                                PieSeries<ChartData, String>(
                                    dataSource: chartData,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        showZeroValue: false,
                                        useSeriesColor: true,
                                        labelIntersectAction:
                                            LabelIntersectAction.shift,
                                        labelPosition:
                                            ChartDataLabelPosition.outside),
                                    xValueMapper: (ChartData data, _) => data.x,
                                    dataLabelMapper: (ChartData data, _) =>
                                        data.x,
                                    yValueMapper: (ChartData data, _) =>
                                        data.y),
                              ]),
                              Text(
                                "${app_name} according to the province",
                                style: TextStyle(
                                    fontSize: 14.0, color: colorWhite),
                              )
                            ],
                          ),
                        )
                ],
              )),
        ));
  }

  Widget getLiveWidgets() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: colorBlack.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              getGuage("Fore Finger Force", param1),
              getGuage("Middle Finger Force", param2),
              getGuage("Palm Force", param3),
              getGuage("Ring Finger Force", param4),
            ],
          )
        ],
      ),
    );
  }

  getGuage(String title, ValueNotifier<double> valueParam) {
    return SizedBox(
      height: displaySize.width * 0.55,
      width: displaySize.width * 0.45,
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            SimpleCircularProgressBar(
              backColor: colorBlack.withOpacity(0.9),
              progressColors: [
                color10,
                color14,
                colorPrimary,
                color2,
                color3,
                color3
              ],
              animationDuration: 1,
              valueNotifier: valueParam,
              maxValue: 100,
              size: displaySize.width * 0.35,
              mergeMode: true,
              onGetText: (double value) {
                return Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorWhite,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  color: colorWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getLiveData() {
    _databaseReference
        .child(FirebaseStructure.TABULARLIVE)
        .child(CustomUtils.loggedInUser!.uid)
        .onValue
        .listen((DatabaseEvent data) {
      dynamic mapData = data.snapshot.value;
      if (mapData != null) {
        setState(() {
          param1.value = double.parse(mapData['ForeFingerForce'].toString());
          param2.value = double.parse(mapData['MiddleFingerForce'].toString());
          param3.value = double.parse(mapData['PalmForce'].toString());
          param4.value = double.parse(mapData['RingFingerForce'].toString());
        });
      }
    });
  }

  void getStatusCount() {
    _databaseReference
        .child(FirebaseStructure.USERS)
        .orderByChild("type")
        .equalTo(1)
        .once()
        .then((DatabaseEvent data) {
      setState(() {
        statusCount = data.snapshot.children.length;
      });
    });
  }

  void loadStatistics() {
    provinceList.forEach((element) {
      hollieguardProvince[element] = 0;
    });

    _databaseReference
        .child(FirebaseStructure.USERS)
        .orderByChild("type")
        .equalTo(2)
        .once()
        .then((DatabaseEvent data) {
      setState(() {
        data.snapshot.children.forEach((DataSnapshot element) {
          dynamic dataRec = element.value;
          if (dataRec['hollieguard'] != null && dataRec['hollieguard']) {
            if (hollieguardProvince.containsKey(dataRec['province'])) {
              int? existing = hollieguardProvince[dataRec['province']];
              hollieguardProvince[dataRec['province']] = existing! + 1;
            }

            hollieguardCount++;
          }
        });

        chartData.clear();

        userCount = data.snapshot.children.length;

        hollieguardProvince.forEach((key, value) {
          chartData.add(ChartData(
              "$key (${((value / userCount) * 100).toInt()}%)",
              (value / userCount) * 100));
        });
      });
    });
  }
}
