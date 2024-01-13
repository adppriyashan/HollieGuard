import 'package:firebase_database/firebase_database.dart';
import 'package:hollieguard/Models/DB/MessageRequest.dart';
import 'package:hollieguard/Models/DB/User.dart';
import 'package:hollieguard/Models/Utils/FirebaseStructure.dart';
import 'package:hollieguard/Models/Utils/Utils.dart';

class MessageRequestController {
  late DatabaseReference _databaseReference;

  MessageRequestController() {
    _databaseReference = FirebaseDatabase.instance.ref();
  }

  Future<void> enrollment(context, dynamic doctor, date) async {
    CustomUtils.showLoader(context);
    String? key =
        _databaseReference.child(FirebaseStructure.REQUESTS).push().key;

    var _data = {
      'date': date,
      'doctor': doctor['key'],
      'doctorname': doctor['value']['name'],
      'doctorphone': doctor['value']['mobile'],
      'patient': CustomUtils.loggedInUser!.uid,
      'patientname': CustomUtils.loggedInUser!.name,
      'patientphone': CustomUtils.loggedInUser!.mobile,
      'status': 2
    };

    await _databaseReference
        .child(FirebaseStructure.REQUESTS)
        .child(key!)
        .set(_data);

    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(CustomUtils.loggedInUser!.uid)
        .child(FirebaseStructure.REQUESTS)
        .child(key)
        .set(_data);

    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(doctor['key'])
        .child(FirebaseStructure.REQUESTS)
        .child(key)
        .set(_data);

    CustomUtils.hideLoader(context);

    CustomUtils.showToast("Request Saved");
  }

  Future<List<Request>> getList(dynamic customUser) async {
    List<Request> _listData = [];
    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(customUser ?? CustomUtils.loggedInUser!.uid)
        .child(FirebaseStructure.REQUESTS)
        .once()
        .then((event) {
      for (DataSnapshot element in event.snapshot.children) {
        Map data = element.value as Map;
        _listData.add(Request(
            id: element.key,
            message: data['message'],
            date: data['date'],
            patient: data['patient'],
            patientname: data['patientname'],
            patientphone: data['patientphone'],
            status: data['status'],
            doctor: data['doctor'],
            doctorname: data['doctorname'],
            doctorphone: data['doctorphone']));
      }
    });

    return _listData;
  }

  Future<List<Request>> getPendingList() async {
    List<Request> _listData = [];
    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(CustomUtils.loggedInUser!.uid)
        .child(FirebaseStructure.REQUESTS)
        .orderByChild('status')
        .equalTo(2)
        .once()
        .then((event) {
      for (DataSnapshot element in event.snapshot.children) {
        Map data = element.value as Map;
        _listData.add(Request(
            id: element.key,
            message: data['message'],
            date: data['date'],
            patient: data['patient'],
            patientname: data['patientname'],
            patientphone: data['patientphone'],
            status: data['status'],
            doctor: data['doctor'],
            doctorname: data['doctorname'],
            doctorphone: data['doctorphone']));
      }
    });

    return _listData;
  }

  Future<void> approveOrReject(
      context, String user, String doctor, String key, int status) async {
    CustomUtils.showLoader(context);

    var _data = {'status': status};

    await _databaseReference
        .child(FirebaseStructure.REQUESTS)
        .child(key)
        .update(_data);

    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(CustomUtils.loggedInUser!.uid)
        .child(FirebaseStructure.REQUESTS)
        .child(key)
        .update(_data);

    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(user)
        .child(FirebaseStructure.REQUESTS)
        .child(key)
        .update(_data);

    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(doctor)
        .child(FirebaseStructure.REQUESTS)
        .child(key)
        .update(_data);

    CustomUtils.hideLoader(context);

    CustomUtils.showToast(
        (status == 1) ? "Request Approved" : "Request Declined");
  }
}
