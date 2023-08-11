import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthenticationService {
  static const loginUrl = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool responseResult = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  String? googleAccessToken;
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Users');

  Future<DocumentSnapshot?> checkingUser(String userDetailID) async {
    DocumentSnapshot? documentSnapshot = await _collectionRef.doc(userDetailID).get();

    if (documentSnapshot.exists) {
      return documentSnapshot;
    } else {
      print('Document with ID $userDetailID not found in database');
      return null;
    }
  }

  saveUserDetail(UserDetail userDetail) async {
    try {
      var giftDoc = _collectionRef.doc(userDetail.id);
      await giftDoc.set(userDetail.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  User? getUser() {
    User? user = _firebaseAuth.currentUser;
    if (user?.email != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<User?> googleSignUp() async {
    User? user;

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (kDebugMode) {
        print("${googleAuth.accessToken}: access token of google sign in");
      }
      googleAccessToken = googleAuth.accessToken;
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      if (kDebugMode) {
        print("signed in $user");
      }

      return user!;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      if (googleAccessToken != null) {
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
