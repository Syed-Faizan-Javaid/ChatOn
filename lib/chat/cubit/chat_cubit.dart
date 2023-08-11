import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../repositories/chat_repositories.dart';
import '../../response_models/api_response.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  ChatCubit({required this.chatRepository}) : super(ChatInitial());

  getMembers() async {
    emit(ChatLoading());
    ApiResponse<List<UserDetail>> apiResponse = await chatRepository.getMembers();
    if (apiResponse.success == true) {
      emit(MembersFetched(members: apiResponse.data!));
    } else {
      emit(ErrorInServer(error: apiResponse.error));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(String messageSenderId, String messageReceiverId) {
    return chatRepository.getMessages(messageSenderId, messageReceiverId);
  }

  sendMessage(MessageModel messageModel, {File? selectedFile}) async {
    ApiResponse apiResponse = await chatRepository.sendMessage(messageModel, selectedFile);
    if (apiResponse.success == false) {
      emit(const ErrorInServer(error: "Message Cannot be sent"));
    }
  }
}
