import 'package:firebase_database/firebase_database.dart';
import 'package:hollieguard/Models/DB/Chat.dart';
import 'package:hollieguard/Models/DB/MessageRequest.dart';
import 'package:hollieguard/Models/Utils/FirebaseStructure.dart';
import 'package:hollieguard/Models/Utils/Utils.dart';

class ChatController {
  late DatabaseReference _databaseReference;

  ChatController() {
    _databaseReference = FirebaseDatabase.instance.ref();
  }

  Future<void> enrollment(context, ChatModel chatModel) async {
    String? key = _databaseReference.child(FirebaseStructure.CHAT).push().key;
    var _data = {
      'from': chatModel.from,
      'to': chatModel.to,
      'message': chatModel.message,
      'appointment': chatModel.request,
      'datetime': chatModel.datetime
    };
    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(chatModel.from)
        .child(FirebaseStructure.REQUESTS)
        .child(chatModel.request)
        .child(FirebaseStructure.CHAT)
        .child(key!)
        .set(_data);
    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(chatModel.to)
        .child(FirebaseStructure.REQUESTS)
        .child(chatModel.request)
        .child(FirebaseStructure.CHAT)
        .child(key)
        .set(_data);
  }

  Future<List<ChatModel>> getList(Request record) async {
    List<ChatModel> _listData = [];
    await _databaseReference
        .child(FirebaseStructure.USERS)
        .child(CustomUtils.loggedInUser!.uid)
        .child(FirebaseStructure.REQUESTS)
        .child(record.id)
        .child(FirebaseStructure.CHAT)
        .once()
        .then((event) {
      for (DataSnapshot element in event.snapshot.children) {
        Map data = element.value as Map;
        _listData.add(ChatModel(
            id: element.key,
            request: data['appointment'],
            datetime: data['datetime'],
            from: data['from'],
            to: data['to'],
            message: data['message']));
      }
    });

    return _listData;
  }
}