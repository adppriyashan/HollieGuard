import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/FirebaseStructure.dart';
import 'package:parkisense/Models/Utils/Images.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Widgets/custom_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class Prediction extends StatefulWidget {
  Prediction({Key? key}) : super(key: key);

  @override
  _PredictionState createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  FilePickerResult? _filePicker;
  File? selectedFile;

  Map<String, String> categoryLinkList = {
    "brain-analysis": "Brain Analysis",
    "sprial-analysis": "Sprial Analysis",
    "voice-analysis": "Voice Analysis"
  };
  List<DropdownMenuItem<String>> _categoryList = [];
  String? category;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      loadCategories();
    });
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
                            "Analysis Prediction",
                            style: TextStyle(fontSize: 18.0, color: colorWhite),
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedFile=null;
                              });
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
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: (_categoryList.isNotEmpty)
                            ? CustomDropDown(
                                dropdown_value: category != null
                                    ? category!
                                    : _categoryList.first.toString(),
                                action_icon_color: color8,
                                text_color: colorDarkBg,
                                background_color: color7,
                                underline_color: color6,
                                leading_icon: Icons.category,
                                leading_icon_color: colorPrimary,
                                function: (value) {
                                  setState(() {
                                    selectedFile = null;
                                    category = value;
                                  });
                                },
                                items: _categoryList)
                            : const SizedBox.shrink(),
                      ),
                      (selectedFile != null)
                          ? GestureDetector(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: displaySize.width * 0.8,
                                      child: category != null &&
                                              category!.contains('voice')
                                          ? Image.asset(
                                              defaultJson,
                                              fit: BoxFit.cover,
                                            )
                                          : FutureBuilder<Uint8List>(
                                              future:
                                                  selectedFile!.readAsBytes(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState.done &&
                                                    snapshot.hasData) {
                                                  return Image.memory(
                                                    snapshot.data!,
                                                    fit: BoxFit.cover,
                                                  );
                                                } else {
                                                  return CircularProgressIndicator(
                                                    color: colorPrimary,
                                                  );
                                                }
                                              }),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: GestureDetector(
                                      onTap: () => uploadImage(),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              color: colorPrimary),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.upload_outlined,
                                                  color: colorWhite
                                                      .withOpacity(0.9),
                                                  size:
                                                      displaySize.width * 0.08,
                                                ),
                                                Text(
                                                  "Click to upload"
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: colorWhite),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () => showChooserType(),
                              child: Align(
                                child: Container(
                                  width: displaySize.width * 0.9,
                                  height: displaySize.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: colorBlack,
                                        style: BorderStyle.solid,
                                      )),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 10.0),
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        direction: Axis.vertical,
                                        children: [
                                          Icon(
                                              category != null &&
                                                      category!
                                                          .contains('voice')
                                                  ? Icons.file_copy_outlined
                                                  : Icons.photo_outlined,
                                              color: colorBlack,
                                              size: displaySize.width * 0.4),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              "Click to choose".toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: colorBlack),
                                            ),
                                          ),
                                          Text(
                                            "You can choose images for prediction uploads"
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: colorBlack),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  )),
              const SizedBox(
                height: 10.0,
              ),
            ],
          )),
    ));
  }

  uploadImage() async {
    CustomUtils.showLoader(context);
    final firebaseStorage = FirebaseStorage.instance;
    await Permission.photos.request();
    if (category != null && selectedFile != null) {
      var snapshot = await firebaseStorage
          .ref()
          .child(
              "${const Uuid().v1()}.${(category!.contains("voice")) ? "json" : "png"}")
          .putFile(selectedFile!);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      await _databaseReference
          .child(FirebaseStructure.LIVEDATA)
          .child(category!)
          .set({
        'isNew': true,
        'image': downloadUrl,
        'user': CustomUtils.loggedInUser!.uid,
      });
      CustomUtils.hideLoader(context);
      CustomUtils.showToast('Upload successfully.');
      setState(() {
        selectedFile = null;
      });
    }
  }

  Future<void> showChooserType() async {
    _filePicker = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions:
            (category!.contains('voice')) ? ['json'] : ['png', 'jpg', 'jepg']);
    setState(() {
      if (_filePicker != null) {
        if (((category!.contains('voice')) ? ['json'] : ['png', 'jpg', 'jepg'])
            .contains(_filePicker!.files.single.extension)) {
          selectedFile = File(_filePicker!.files.single.path!);
        } else {
          CustomUtils.showSnackBar(
              context,
              "Please select correct file type according to the category",
              CustomUtils.ERROR_SNACKBAR);
        }
      } else {
        selectedFile = null;
      }
    });
  }

  loadCategories() async {
    setState(() {
      categoryLinkList.forEach((key, category) {
        _categoryList.add(DropdownMenuItem(
            value: key,
            alignment: Alignment.centerLeft,
            enabled: true,
            child: Text(category)));
      });

      category = _categoryList.first.value;
    });
  }
}
