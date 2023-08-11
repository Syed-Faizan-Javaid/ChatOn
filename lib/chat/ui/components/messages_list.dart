import 'package:chat_app/chat/cubit/chat_cubit.dart';
import 'package:chat_app/constants/color.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import 'message_tile.dart';

class MessagesList extends StatefulWidget {
  final UserDetail messageReceiverUserDetail;
  final ScrollController scrollController;

  const MessagesList({super.key, required this.messageReceiverUserDetail, required this.scrollController});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late ChatCubit _chatCubit;
  late UserDetail _messageSenderUserDetail;
  List<MessageModel> messages = [];

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _messageSenderUserDetail = context.read<UserRepository>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatCubit.getMessage(_messageSenderUserDetail.id, widget.messageReceiverUserDetail.id),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>>? ds = snapshot.data?.docs;
          messages = ds!.map((message) => MessageModel.fromJson(message.data())).toList();
          messages = getConversation(messages);
        }
        return messages.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: widget.scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool isSender = _messageSenderUserDetail.id == messages[index].messageSenderId;
                      return messages[index].contentType == 0
                          ? MessageTile(isSender: isSender, message: messages[index])
                          : Padding(
                              padding: EdgeInsets.fromLTRB(isSender ? MediaQuery.of(context).size.width * .50 : 5, 10,
                                  isSender ? 10 : MediaQuery.of(context).size.width * .50, 10),
                              child: Image.network(
                                messages[index].content!,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ));
                                },
                              ),
                            );
                    }),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text("No Conversations with ${widget.messageReceiverUserDetail.email} yet"),
              );
      },
    );
  }

  List<MessageModel> getConversation(List<MessageModel> messages) {
    List<MessageModel> allConversation = [];
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].messageSenderId == _messageSenderUserDetail.id && messages[i].messageReceiverId == widget.messageReceiverUserDetail.id ||
          messages[i].messageSenderId == widget.messageReceiverUserDetail.id && messages[i].messageReceiverId == _messageSenderUserDetail.id) {
        allConversation.add(messages[i]);
      }
    }
    return allConversation;
  }
}
