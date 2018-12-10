// TODO use google profile login
// TODO use facebook profile login

import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chat_demo/const.dart';
// import 'package:flutter_chat_demo/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_forms/home_screen.dart';
import 'package:firebase_forms/login_service.dart';
import 'package:firebase_forms/routes.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final LoginService loginService = new LoginService();
  bool isLoading = false;

  
  @override
  void initState() {
    super.initState();
    loginService.checkSignedIn().then((uid){
      print("login id $uid");
      if (uid.length > 0) {
        print("PRIOR login id ${uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // MainScreen(currentUserId: prefs.getString('id'))),
                  HomeScreen(currentUserId: uid)
          ),
          // (Route<dynamic> route) => false
        );
      }
    }).catchError((err){print("not prior login");});
  }

  // if user exists then save to prefs and import profile
  // if sign in fails then ask to make a profile
  Future<Null> handleSignIn() async {

    this.setState(() {
      isLoading = true;
    });
    bool signInSuccess = await loginService.handleSignIn();
    String uid = await loginService.getUID();
    print("SIGN in result : ${signInSuccess}");

    if(signInSuccess){
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      // redirect to main home page
      // pushReplacement : enter , popAndPushName : exit
      // Navigator.pushReplacementNamed(context, "/contacts");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // MainScreen(currentUserId: prefs.getString('id'))),
                  HomeScreen(currentUserId:uid)
          )
        );
    }else{
      Fluttertoast.showToast(msg: "Sign in fail"); // TODO ask to make a profile
      this.setState(() {
        isLoading = false;
      });
    }

  }

  void _showEmailLogin(BuildContext context){
    Navigator.pushNamed(context, "/login_email");
  }

  void _showSignUp(){
    Navigator.pushNamed(context, "/create_user");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      body: 
        Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FlatButton(
                    onPressed: handleSignIn,
                    child: Text(
                      'SIGN IN WITH GOOGLE',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: Color(0xffdd4b39),
                    highlightColor: Color(0xffff7f7f),
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)
                ),
                Divider(height: 20.0,),
                GestureDetector(
                  child: Text("Login using email"),
                  onTap: (){_showEmailLogin(context);}
                ),
                Divider(height: 20.0,),
                GestureDetector(
                  child: Text("Sign up"),
                  onTap: (){_showSignUp();}
                ),
              ]
            )
            ) 
            )
        );
  }
}
