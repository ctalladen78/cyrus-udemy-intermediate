import 'package:flutter/material.dart';
import 'contact_list.dart';
import 'login_screen.dart';
import 'login_email.dart';
import 'create_user.dart';
import 'home_screen.dart';

class Routes {
  var _routes;
  Map<String, WidgetBuilder> get routes => _routes;
  Routes(BuildContext context) {
    _routes = <String, WidgetBuilder>{
      "/" : (context) => LoginScreen(),
      // "/home" : (context) => HomeScreen(),
      "/contacts" : (context) => ContactListScreen(),
      "/login_email" : (context) => LoginEmailScreen(),
      "/create_user" : (context) => CreateUserScreen()
    };
  }
}