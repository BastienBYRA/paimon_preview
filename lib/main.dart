import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:paimon_preview/firebase.dart';
import 'package:paimon_preview/pages/home.dart';

void main() async {
  try {
    if (!Platform.isWindows) {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
    }
  } catch (e) {
    print("failed to connect to the firebase database");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        backgroundColor: Colors.grey[100],
      ),
      home: Home(),
    );
  }
}
