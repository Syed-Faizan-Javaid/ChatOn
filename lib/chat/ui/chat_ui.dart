import 'dart:io';

import 'package:chat_app/chat/ui/components/messages_list.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utils/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/color.dart';
import '../../repositories/user_repository.dart';
import '../cubit/chat_cubit.dart';

class ChatUI extends StatefulWidget {
  final UserDetail messageReceiverUserDetail;
  const ChatUI({super.key, required this.messageReceiverUserDetail});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  late ChatCubit _chatCubit;
  late UserDetail _messageSenderUserDetail;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedFile;

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _messageSenderUserDetail = context.read<UserRepository>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f8f9),
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: primaryColor,
          toolbarHeight: 80,
          centerTitle: true,
          title: Text(
            widget.messageReceiverUserDetail.email.toUpperCase(),
            style: const TextStyle(fontSize: 16),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
          )),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                MessagesList(
                  messageReceiverUserDetail: widget.messageReceiverUserDetail,
                  scrollController: _scrollController,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey.shade300, spreadRadius: 1)]),
            child: Stack(
              children: [
                Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Send Message",
                              hintStyle: const TextStyle(fontSize: 14),
                              fillColor: const Color(0xFFf8f8f9),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        MessageModel messageModel = MessageModel();
                        messageModel.messageSenderId = _messageSenderUserDetail.id;
                        messageModel.messageReceiverId = widget.messageReceiverUserDetail.id;
                        messageModel.content = _messageController.text;
                        messageModel.messageSendingTime = DateTime.now();
                        _chatCubit.sendMessage(messageModel, selectedFile: _selectedFile ?? File(""));
                        _messageController.clear();
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.send,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .70, top: 15),
                  child: InkWell(
                      onTap: () async {
                        _selectedFile = await filePicker();
                        if (_selectedFile != null) {
                          MessageModel messageModel = MessageModel();
                          messageModel.messageSenderId = _messageSenderUserDetail.id;
                          messageModel.messageReceiverId = widget.messageReceiverUserDetail.id;
                          messageModel.messageSendingTime = DateTime.now();
                          messageModel.contentType = 1;
                          _chatCubit.sendMessage(messageModel, selectedFile: _selectedFile ?? File(""));
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          }
                        }
                      },
                      child: const Icon(Icons.attach_file)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
