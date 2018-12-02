import 'package:flutter/material.dart';
import 'contact_list.dart';
import 'login_screen.dart';
import 'login_email.dart';
import 'create_user.dart';

class Routes {
  var _routes;
  Map<String, WidgetBuilder> get routes => _routes;
  Routes(BuildContext context) {
    _routes = <String, WidgetBuilder>{
      "/" : (context) => LoginScreen(),
      "/contacts" : (context) => MyHomePage(),
      "/login_email" : (context) => LoginEmailScreen(),
      "/create_user" : (context) => CreateUserScreen()
    };
  }
}