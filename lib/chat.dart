import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/*
https://pub.dartlang.org/packages/firebase_messaging#-readme-tab-

configuring FCM client
Next, you should probably request permissions for receiving Push Notifications. 
For this, call _firebaseMessaging.requestNotificationPermissions(). 
This will bring up a permissions dialog for the user to confirm on iOS. 
It's a no-op on Android. Last, but not least, register 
onMessage, 
onResume, 
 onLaunch callbacks via _firebaseMessaging.configure() 
 to listen for 
incoming messages (see table below for more information).

sending message:


receiving message:

TODO add a payment button in message object to send money to the message receive      routes: new Routes(context).routes,
r 

push notifications with one signal: 
https://github.com/OneSignal/OneSignal-Flutter-SDK/blob/master/example/lib/main.dart
*/
/**
 * // upload content to firebase storage 
  // reflect changes to chat area
      // type: 0 = text, 1 = image, 2 = sticker
  void onSendMessage(String content, int type) {
    // check empty string message
    if (content.trim() != '') {
      textEditingController.clear();

      // each message collection has a group chat collection of conversations
      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }
 */
class ChatScreen extends StatefulWidget {
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Container(),
    );
  }
}