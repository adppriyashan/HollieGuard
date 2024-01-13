import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:parkisense/Controllers/ChatController.dart';
import 'package:parkisense/Models/DB/Chat.dart';
import 'package:parkisense/Models/DB/MessageRequest.dart';
import 'package:parkisense/Models/Strings/register_screen.dart';
import 'package:parkisense/Models/Utils/Colors.dart';
import 'package:parkisense/Models/Utils/Common.dart';
import 'package:parkisense/Models/Utils/Utils.dart';
import 'package:parkisense/Views/Widgets/custom_text_area.dart';

class Chat extends StatefulWidget {
  Request request;
  Chat(this.request, {Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState(this.request);
}

class _ChatState extends State<Chat> {
  final double topSpace = displaySize.width * 0.4;
  Request request;

  bool isLoading = true;

  TextEditingController _messageController = TextEditingController();

  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  List<Widget> chatList = [];

  ChatController _chatController = ChatController();

  _ChatState(this.request);

  @override
  void initState() {
    super.initState();

    refreshChat();
  }

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
                            "Chat History",
                            style: GoogleFonts.openSans(
                                fontSize: 18.0, color: colorWhite),
                          ),
                          GestureDetector(
                            onTap: () => refreshChat(),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 1.0, vertical: 2.0),
                    child: (isLoading == false)
                        ? Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                    reverse:
                                        (chatList.isNotEmpty) ? true : false,
                                    controller: scrollController,
                                    child: Column(
                                      crossAxisAlignment: (chatList.isNotEmpty)
                                          ? CrossAxisAlignment.stretch
                                          : CrossAxisAlignment.center,
                                      children: (chatList.isNotEmpty)
                                          ? chatList
                                          : [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: Text(
                                                  'Start chat with doctor',
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 14.0,
                                                      color: colorGrey),
                                                ),
                                              )
                                            ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 5.0),
                                              child: CustomTextAreaFormField(
                                                  height: 5.0,
                                                  controller:
                                                      _messageController,
                                                  backgroundColor: color7,
                                                  iconColor: colorPrimary,
                                                  isIconAvailable: true,
                                                  hint: 'Your message',
                                                  icon: Icons.message_outlined,
                                                  textInputType:
                                                      TextInputType.multiline,
                                                  validation: (value) {
                                                    final validator = Validator(
                                                      validators: [
                                                        const RequiredValidator()
                                                      ],
                                                    );
                                                    return validator.validate(
                                                      label:
                                                          register_validation_invalid_message,
                                                      value: value,
                                                    );
                                                  },
                                                  obscureText: false),
                                            )),
                                        Expanded(
                                            flex: 0,
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (_messageController
                                                    .text.isNotEmpty) {
                                                  ChatModel chatModel = ChatModel(
                                                      id: 1,
                                                      from: CustomUtils
                                                          .loggedInUser!.uid,
                                                      to: (request.doctor ==
                                                              CustomUtils
                                                                  .loggedInUser!
                                                                  .uid)
                                                          ? request.patient
                                                          : request.doctor,
                                                      message:
                                                          _messageController
                                                              .text,
                                                      request: request.id,
                                                      datetime: DateTime.now()
                                                          .millisecondsSinceEpoch);

                                                  await _chatController
                                                      .enrollment(
                                                          context, chatModel)
                                                      .then((value) {
                                                    chatList.add(
                                                        getMessageBubble(
                                                            chatModel));
                                                    refreshChat();
                                                  });

                                                  _messageController.text = "";
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0),
                                                child: Icon(
                                                  Icons.send,
                                                  color: colorPrimary,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ))
                            ],
                          )
                        : Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(colorPrimary),
                              )
                            ],
                          ),
                  ))
            ],
          )),
    ));
  }

  Widget getMessageBubble(ChatModel chatRecord) {
    return Align(
      alignment: (CustomUtils.loggedInUser!.uid == chatRecord.from)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Wrap(
        children: [
          Container(
              constraints:  BoxConstraints(maxWidth: displaySize.width*0.8),
              margin: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: (CustomUtils.loggedInUser!.uid == chatRecord.from)
                      ? colorPrimary
                      : colorSecondary),
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                    (chatRecord.from == CustomUtils.loggedInUser!.uid)
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  Text(
                    chatRecord.message,
                    style:
                        GoogleFonts.openSans(fontSize: 14.0, color: colorWhite),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      getDateTime(DateTime.fromMillisecondsSinceEpoch(
                          chatRecord.datetime)),
                      style: GoogleFonts.openSans(
                          fontSize: 10.0, color: colorWhite),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  getDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  refreshChat() async {
    if (isLoading == false) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    } else {
      await _chatController.getList(request).then((value) {
        value.forEach((ChatModel element) {
          chatList.add(getMessageBubble(element));
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
