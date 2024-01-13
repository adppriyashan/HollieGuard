import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphView extends StatefulWidget {
  dynamic chartData1 = [];
  dynamic chartData2 = [];
  dynamic chartData3 = [];
  dynamic chartData4 = [];
  dynamic label1, label2, label3, label4;

  GraphView(
      {Key? key,
      this.chartData1,
      this.chartData2,
      this.chartData3,
      this.chartData4,
      this.label1,
      this.label2,
      this.label3,
      this.label4})
      : super(key: key);

  @override
  _GraphViewState createState() => _GraphViewState(
      chartData1: this.chartData1,
      chartData2: (this.chartData2 != null) ? this.chartData2 : [],
      chartData3: (this.chartData3 != null) ? this.chartData3 : [],
      chartData4: (this.chartData4 != null) ? this.chartData4 : [],
      label1: this.label1,
      label2: this.label2,
      label3: this.label3,
      label4: this.label4);
}

class _GraphViewState extends State<GraphView> {
  List<ChartData> chartData1 = [];
  List<ChartData> chartData2 = [];
  List<ChartData> chartData3 = [];
  List<ChartData> chartData4 = [];
  dynamic label1, label2, label3, label4;
  final List<ChartSeries> chartSeries = [];
  final List <double> maxList=[];

  _GraphViewState(
      {required this.chartData1,
      required this.chartData2,
      required this.chartData3,
      required this.chartData4,
      required this.label1,
      required this.label2,
      required this.label3,
      required this.label4});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double topSpace = displaySize.width * 0.4;

  @override
  void initState() {
    finializeData();
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
                          Icon(
                            Icons.refresh,
                            color: colorPrimary,
                          ),
                          Text(
                            "Graph View",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 18.0, color: colorWhite),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  child: (chartSeries.isNotEmpty)
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: SfCartesianChart(
                           enableAxisAnimation: true,
                           
                              primaryXAxis: CategoryAxis(),
                              series: chartSeries),
                        )
                      : const SizedBox.shrink()),
              (label1 != null)
                  ? Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  color: color4,
                                  height: 10.0,
                                  width: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    label1,
                                    style: GoogleFonts.nunitoSans(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              (label2 != null)
                  ? Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  color: color12,
                                  height: 10.0,
                                  width: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    label2,
                                    style: GoogleFonts.nunitoSans(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              (label3 != null)
                  ? Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  color: color13,
                                  height: 10.0,
                                  width: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    label3,
                                    style: GoogleFonts.nunitoSans(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              (label4 != null)
                  ? Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  color: color14,
                                  height: 10.0,
                                  width: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    label4,
                                    style: GoogleFonts.nunitoSans(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          )),
    ));
  }

  void finializeData() {
    setState(() {
      if (chartData1.isNotEmpty) {
        chartSeries.add(SplineSeries<ChartData, String>(
            dataSource: chartData1,
            color: color4,
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y));
      }
      if (chartData2.isNotEmpty) {
        chartSeries.add(SplineSeries<ChartData, String>(
            dataSource: chartData2,
            color: color12,
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y));
      }
      if (chartData3.isNotEmpty) {
        chartSeries.add(SplineSeries<ChartData, String>(
            dataSource: chartData3,
            color: color13,
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y));
      }
      if (chartData4.isNotEmpty) {
        chartSeries.add(SplineSeries<ChartData, String>(
            dataSource: chartData4,
            color: color14,
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y));
      }
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
