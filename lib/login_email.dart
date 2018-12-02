import 'package:flutter/material.dart';
import 'package:firebase_forms/login_service.dart';
// import 'package:firebase_forms/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginEmailScreen extends StatefulWidget {

  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmailScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _pwdController = new TextEditingController();
  final LoginService loginService = new LoginService();
  final FocusNode _focusNode = new FocusNode();

  @override
  final data = {};

  // TODO pop everything and replace with main screen
  Future<Null> submitForm(BuildContext context) async {
    String email = _emailController.text;
    String password = _pwdController.text;

    FirebaseUser user = await loginService.loginWithEmail(email: email, pwd: password);
    if(user.uid != null){
      Navigator.pushNamedAndRemoveUntil(context, "/contacts", 
        (Route<dynamic> route) => false
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            child: new Column(
              children: <Widget>[
                Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    // onSaved: (field) => data.addAll({"fieldkey": field}),
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _focusNode,
                  ),
                  IconButton(
                        onPressed: (){_emailController.clear();},
                        icon:Icon(Icons.cancel), 
                  ),
                ],),
                SizedBox(height: 50.0,),
                Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      // onSaved: (field) => data.addAll({"fieldkey": field}),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    IconButton(
                          onPressed: (){_pwdController.clear();},
                          icon:Icon(Icons.cancel), 
                    ),
                  ]
                ),
                // Padding(padding: EdgeInsets.only(top: 60.0),),
                SizedBox(height: 60.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  
                  children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.cancel,
                      size: 56.0, 
                      color: Colors.grey,
                    ),
                    onPressed: (){Navigator.pop(context);},
                  ),
                  SizedBox(width: 30.0,),
                  RaisedButton(
                    onPressed: (){submitForm(context);},
                    child: Text("Sign in"),
                    padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                    color: Color(0xffdd4b39),
                  )
                ],)
              ],
            ),
          ),
        ),
      )
    );
  }
}

