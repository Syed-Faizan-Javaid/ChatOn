import 'package:chat_app/response_models/api_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../network_services/authentication_service.dart';

class UserRepository {
  final authenticationService = AuthenticationService();

  UserDetail _userDetail = UserDetail();
  saveUser(UserDetail userDetail) {
    _userDetail = userDetail;
  }

  UserDetail getUser() {
    if (_userDetail.id.isEmpty) {}
    print(_userDetail.toJson());
    return _userDetail;
  }

  Future<UserDetail?> checkUser(String userDetailId) async {
    try {
      DocumentSnapshot? documentSnapshot = await authenticationService.checkingUser(userDetailId);
      if (documentSnapshot != null) {
        final jsonObj = documentSnapshot.data() as Map<String, dynamic>;
        saveUser(UserDetail.fromJson(jsonObj));
        return getUser();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveUserDetails(UserDetail userDetail) async {
    try {
      authenticationService.saveUserDetail(userDetail);
      User? user = authenticationService.getUser();
      if (user != null) {
        await checkUser(user.uid);
        if (kDebugMode) {
          print("${user.uid} :UID When Authenticating");
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResponse> logout() async {
    ApiResponse apiResponse = ApiResponse();

    try {
      await authenticationService.signOut();
      apiResponse.success = true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("${e.message} :Firebase Error");
      }
      apiResponse.error = e.message!;
    } catch (e) {
      if (kDebugMode) {
        print("$e :Response Error");
      }
      apiResponse.error = e.toString();
    }
    return apiResponse;
  }

  Future<ApiResponse<User>> authenticateWithGoogle() async {
    ApiResponse<User> apiResponse = ApiResponse<User>();

    try {
      apiResponse.data = await authenticationService.googleSignUp();
      if (apiResponse.data == null) {
        apiResponse.success = false;
      } else {
        apiResponse.success = true;
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("${e.message} :Firebase Error");
      }
      apiResponse.error = e.message!;
    } catch (e) {
      if (kDebugMode) {
        print("$e :Response Error");
      }
      apiResponse.error = e.toString();
    }
    return apiResponse;
  }

  Future<bool> authenticateUser() async {
    User? user = authenticationService.getUser();
    if (user != null) {
      await checkUser(user.uid);
      if (kDebugMode) {
        print("${user.uid} :UID When Authenticating");
      }
      return true;
    } else {
      return false;
    }
  }
}
