import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  final _collectionRef = FirebaseFirestore.instance.collection('Users');
  final _messagesCollectionRef = FirebaseFirestore.instance.collection('Messages');

  Future<List<UserDetail>> getMembers() async {
    List<UserDetail> members = [];
    try {
      await _collectionRef.get().then((QuerySnapshot querySnapshot) {
        members = querySnapshot.docs.map((user) => UserDetail.fromJson(user.data() as Map<String, dynamic>)).toList();
      });
      return members;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String messageSenderId, String messageReceiverId) {
    try {
      return _messagesCollectionRef.orderBy("messageSendingTime", descending: true).snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendMessage(MessageModel messageModel, File? selectedFile) async {
    try {
      var messageDoc = _messagesCollectionRef.doc();
      messageModel.id = messageDoc.id;
      if (selectedFile!.path.isNotEmpty) {
        messageModel.content = await uploadImageAndGetUrl(selectedFile);
      }
      await messageDoc.set(messageModel.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImageAndGetUrl(File imageFile) async {
    String imageUrl;
    final ref = FirebaseStorage.instance.ref().child('chatImages').child("${DateTime.now()}.jpg");
    await ref.putFile(imageFile);
    imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }
}
