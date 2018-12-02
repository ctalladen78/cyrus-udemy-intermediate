
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_forms/contact_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

  class UserData {
    String displayName;
    String email;
    String uid;
    String password;

    UserData({this.displayName, this.email, this.uid, this.password});
  }

class LoginService {

  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  SharedPreferences prefs;
  Future<String> getUID() async {
    return await FirebaseAuth.instance.currentUser().then((data){return data.uid;}).catchError((err){return "";});
  } 



  // check if already logged in
  // return uid string if true
  Future<String> checkSignedIn() async {
    bool isSignedIn = await googleSignIn.isSignedIn();
    if(isSignedIn){
      // update current prefs
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      await prefs.setString('uid', currentUser.uid);
      print("SIGNED in ID ${currentUser.uid}");  
      return currentUser.uid;
    }
  }

  Future<Null> logout() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    currentUser = null;
  }

  // TODO implement on login screen
  Future<FirebaseUser> loginWithEmail({email: String , pwd: String }) async {
    print("LOGIN w EMAIL $email $pwd");
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(
      email: email, password: pwd
    );
    print("FIREBASE $user");
    return user;
  }

  // TODO implement create account on login screen
  Future<FirebaseUser> createUser({email: String , pwd: String}) async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: pwd
    );
    await user.sendEmailVerification();
    return user;
  }

  Future<bool> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    if (firebaseUser != null) {
      /*
      String idToken = await firebaseUser.getIdToken(); 
      firebaseUser.isEmailVerified;
      firebaseUser.sendEmailVerification();
      */
      print("FIREBASE USER");
      print(firebaseUser.uid);
      String _uid = firebaseUser.uid;

      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: _uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(_uid)
            .setData({
              'nickname': firebaseUser.displayName,
              'photoUrl': firebaseUser.photoUrl,
              'uid': _uid 
            });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('uid', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
        return true;
    } else {
      return false;
    }

  }
}