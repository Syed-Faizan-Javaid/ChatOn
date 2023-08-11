import 'package:chat_app/my_app.dart';
import 'package:chat_app/persistent_storage/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
