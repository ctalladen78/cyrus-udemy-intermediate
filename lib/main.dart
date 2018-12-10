// import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_forms/api_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'dart:io';
// import 'contact_list.dart';
// import 'login_screen.dart';
import 'routes.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purpleAccent[300],
      ),
      // home: MyHomePage(title: "User Contacts"),
      routes: Routes(context).routes,
    );
  }
}
