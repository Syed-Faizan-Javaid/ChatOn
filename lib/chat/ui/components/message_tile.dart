import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/color.dart';
import '../../../models/message.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.isSender,
    required this.message,
  });

  final bool isSender;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          isSender ? MediaQuery.of(context).size.width * .70 : 5, 10, isSender ? 10 : MediaQuery.of(context).size.width * .70, 10),
      child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: isSender ? primaryColor : Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(15),
                  topLeft: const Radius.circular(15),
                  bottomRight: isSender ? Radius.zero : const Radius.circular(15),
                  bottomLeft: isSender ? const Radius.circular(15) : Radius.zero)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content ?? "No Message",
                style: TextStyle(color: isSender ? Colors.white : Colors.black, fontSize: 16),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                DateFormat('yyyy-MM-dd – kk:mm').format(message.messageSendingTime!),
                style: TextStyle(color: isSender ? Colors.white : Colors.black, fontSize: 9),
              ),
            ],
          )),
    );
  }
}
