import 'dart:io';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/network_services/chat_service.dart';
import 'package:chat_app/response_models/api_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/message.dart';

class ChatRepository {
  final _chatService = ChatService();

  Future<ApiResponse<List<UserDetail>>> getMembers() async {
    ApiResponse<List<UserDetail>> apiResponse = ApiResponse<List<UserDetail>>();
    try {
      apiResponse.data = await _chatService.getMembers();
      apiResponse.success = true;
    } on FirebaseException catch (e) {
      apiResponse.error = e.message!;
      if (kDebugMode) {
        print("${e.message} :Firebase Error");
      }
    } catch (e) {
      apiResponse.error = e.toString();
      if (kDebugMode) {
        print("$e :Response Error");
      }
    }
    return apiResponse;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String messageSenderId, String messageReceiverId) {
    return _chatService.getMessages(messageSenderId, messageReceiverId);
  }

  Future<ApiResponse> sendMessage(MessageModel messageModel, File? selectedFile) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse.success = await _chatService.sendMessage(messageModel, selectedFile);
    } on FirebaseException catch (e) {
      apiResponse.error = e.message!;
      if (kDebugMode) {
        print("${e.message} :Firebase Error");
      }
    } catch (e) {
      apiResponse.error = e.toString();
      if (kDebugMode) {
        print("$e :Response Error");
      }
    }
    return apiResponse;
  }
}
