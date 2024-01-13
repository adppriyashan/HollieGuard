import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:custom_radio_group_list/custom_radio_group_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validation/form_validation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:parkisense/Models/Strings/register_screen.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/FirebaseStructure.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Widgets/custom_text_area.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({Key? key}) : super(key: key);

  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double topSpace = displaySize.width * 0.4;

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  @override
  void initState() {
    getData();
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
                            "Recommendation",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 18.0, color: colorWhite),
                          ),
                          GestureDetector(
                            onTap: () async {
                              showEnrollment(null, null);
                            },
                            child: Icon(
                              Icons.add,
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
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (var rec in list)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        toBeginningOfSentenceCase(rec['key']
                                                .toString()
                                                .split('-')[0] +
                                            (rec['key']
                                                    .toString()
                                                    .contains('spiral')
                                                ? " (${toBeginningOfSentenceCase(rec['key'].toString().split('-')[2])})"
                                                : '')),
                                        style: GoogleFonts.nunitoSans(
                                            color: colorBlack, fontSize: 14.0),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                showEnrollment(rec['key'], rec),
                                            child:
                                                Icon(Icons.edit, color: color1),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _databaseReference
                                                    .child(FirebaseStructure
                                                        .RECOMMENDATIONS)
                                                    .child(rec['key'])
                                                    .remove()
                                                    .then((value) => getData());
                                              },
                                              child: Icon(Icons.delete,
                                                  color: color13),
                                            ),
                                          )
                                        ],
                                      ),
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
        .child(FirebaseStructure.RECOMMENDATIONS)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        list.add({'key': element.key, 'value': element.value});
      }
      setState(() {});
    });
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Uint8List getImageString(String value) {
    return Uri.parse(value).data!.contentAsBytes();
  }

  final _formKey = GlobalKey<FormState>();

  void showEnrollment(key, dynamic savedRecord) {
    List<String> categoryList = ['brain', 'spiral', 'tabular', 'voice'];
    List<String> spiralList = ['High', 'Low', 'Mid'];

    String? category = categoryList.first;
    String? subcategorySpiral = spiralList.first;

    TextEditingController _recommendation = TextEditingController();
    if (savedRecord != null) {
      category = savedRecord.values.first.toString().split('-')[0];
      _recommendation.text = savedRecord['value'];
      if (category == 'spiral') {
        subcategorySpiral = toBeginningOfSentenceCase(
            savedRecord.values.first.toString().split('-')[2]);
      }
    }

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contextModalSheet) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  width: displaySize.width,
                  height: displaySize.height * 0.7,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(color: colorPrimary),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 18.0,
                                  bottom: 18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: colorPrimary,
                                  ),
                                  Text(
                                    "Enrollment",
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
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      child: Text(
                                        "Category",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: 14.0, color: colorBlack),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5.0),
                                    child: RadioGroup(
                                      items: categoryList,
                                      onChanged: (value) {
                                        setState(() {
                                          category = value;
                                        });
                                      },
                                      selectedItem: (category != null)
                                          ? category
                                          : categoryList.first,
                                      shrinkWrap: true,
                                      activeColor: colorPrimary,
                                      fillColor: colorPrimary,
                                      labelBuilder: (ctx, index) {
                                        return Text(toBeginningOfSentenceCase(
                                            categoryList[index]));
                                      },
                                    ),
                                  ),
                                  Visibility(
                                      visible:
                                          ((category ?? 'brain') == 'spiral'),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                          child: Text(
                                            "Spiral Level",
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 14.0,
                                                color: colorBlack),
                                          ))),
                                  Visibility(
                                      visible: (category == 'spiral'),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35.0, vertical: 5.0),
                                        child: RadioGroup(
                                          items: spiralList,
                                          onChanged: (value) {
                                            setState(() {
                                              subcategorySpiral = value;
                                            });
                                          },
                                          selectedItem:
                                              (subcategorySpiral != null)
                                                  ? subcategorySpiral
                                                  : spiralList.first,
                                          shrinkWrap: true,
                                          activeColor: colorPrimary,
                                          fillColor: colorPrimary,
                                          labelBuilder: (ctx, index) {
                                            return Text(spiralList[index]);
                                          },
                                        ),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      child: Text(
                                        "Recommondation",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: 14.0, color: colorBlack),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: CustomTextAreaFormField(
                                        height: 5.0,
                                        controller: _recommendation,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'Enter your recommendation ..',
                                        icon: Icons.map_outlined,
                                        textInputType: TextInputType.multiline,
                                        validation: (value) {
                                          final validator = Validator(
                                            validators: [
                                              const RequiredValidator()
                                            ],
                                          );
                                          return validator.validate(
                                            label: invalid_recommendation,
                                            value: value,
                                          );
                                        },
                                        obscureText: false),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
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
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              category != null) {
                                            FocusScope.of(context).unfocus();
                                            CustomUtils.showLoader(context);
                                            DatabaseReference ref =
                                                _databaseReference
                                                    .child(FirebaseStructure
                                                        .RECOMMENDATIONS)
                                                    .child(
                                                        "${category!}-analysis${(category == 'spiral') ? "-${subcategorySpiral!.toLowerCase()}" : ''}");

                                            ref
                                                .set(_recommendation.text)
                                                .then((value) {
                                              getData();
                                              CustomUtils.hideLoader(context);
                                              Navigator.pop(context);
                                            });
                                          }
                                        },
                                        child: Text(
                                          (savedRecord != null)
                                              ? "Update"
                                              : "Save",
                                          style: GoogleFonts.nunitoSans(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ))
                    ],
                  ));
            }),
          );
        });
  }
}
