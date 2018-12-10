import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {


  // TODO get tripId
  Future<String> checkSignedIn() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

  }
}