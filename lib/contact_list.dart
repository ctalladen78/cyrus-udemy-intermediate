import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_forms/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:io';
import 'package:firebase_forms/login_service.dart';
// import 'login_screen.dart';
import 'routes.dart';
import 'main.dart';

class ContactListScreen extends StatefulWidget {
  final String currentUserId ;
  ContactListScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  // _MyHomePageState createState() => _MyHomePageState(currentUserId);
  _MyHomePageState createState() => _MyHomePageState(currentUserId);
}

class _MyHomePageState extends State<ContactListScreen> {

  String _currentUserId;
  _MyHomePageState(String currentUserId){
    _currentUserId = currentUserId;
  }
  // final GlobalKey<ScaffoldKey> _scaffoldKey = new GlobalKey<ScaffoldKey>()
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _voteController = new TextEditingController();
  // keys and controllers must be declared outside the build method otherwise they wont work well
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final LoginService loginService = LoginService();

  void _sendEmail() async {
    // TODO form input with email details
    dynamic resp = await CloudFunctions.instance.call(functionName: 'sendGridExample');
  }

  void _makePayment() async {
    // TODO stripe payment cloud function 
    //  param: form input with card details
    // dynamic response = await CloudFunctions.instance.call(functionName: 'stripePayment');
  }

  void testDb() async{
    String uid = await loginService.getUID();
    // await loginService.checkSignedIn().then((data){ uid = data.uid;});
    final QuerySnapshot queryResult = await Firestore.instance.collection('connections')
      .where('owner_id', isEqualTo: uid)
      .getDocuments();
    
    final List<DocumentSnapshot> docList = queryResult.documents;
    if(docList.length == 0){
      docList.forEach((item){
        print('FIRESTORE DOCUMENTS');
        print(item);
      });
    }
  }

  // https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
  // https://www.raywenderlich.com/110-flutter-navigation-tutorial
  void logout() {
    WidgetBuilder homePage = Routes(context).routes["/"];
    loginService.logout(); 
    // Navigator.popUntil(context, ModalRoute.withName("/"));
    Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
  }


  @override
  void initState() {
      super.initState();
      testDb();
    }

  @override
  void dispose() {
      _nameController.dispose();
      _voteController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    
            // _sendEmail();
    return Scaffold(
          appBar: AppBar(
            // title: Text(_currentUserId),
            title: Text('test'),
            actions: <Widget>[ IconButton(
                icon: Icon(Icons.cancel),
                onPressed: (){ 
                  logout();
                },
                )
            ],
          ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildForm(context, _formKey),
          );
          // Perform some action
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _submitForm(Map<dynamic, dynamic> data, GlobalKey<FormState> key) {
    final FormState formData = key.currentState;
    // print("submitted old $data");
    // formData.validate();
    formData.save();
    print("CREATED new $data");
    _create(data);
    _voteController.clear();
    _nameController.clear();
  }

  // https://flutter.institute/firebase-firestore/
  // https://grokonez.com/flutter/flutter-firestore-example-firebase-firestore-crud-operations-with-listview
  // https://medium.com/flutter-community/building-a-chat-app-with-flutter-and-firebase-from-scratch-9eaa7f41782e
  void _create(Map<dynamic,dynamic> data) async {
    // firestore document keys are string types
    Map<String, dynamic> user = {};
    user.addAll({"name" : data["name"]});
    int votes = int.parse(data["votes"]);
    user.addAll({"votes" : votes});
    // user.forEach((k,v){
    //   print("key $k , val $v");
    // });
    // keys must correspond to firestore document keys
    //  this is not using stream. 
    CollectionReference collection = Firestore.instance.collection('baby');
    DocumentReference newDoc = await collection.add(user);
    String docId = newDoc.documentID;
    print("new document created : $docId");

  }

  // TODO navigate to chat conversation screen
  // add to votes count
  void _update(Record record){
    // TODO Navigate to chat screen passing uid
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(record.reference);
      final fresh = Record.fromSnapshot(freshSnapshot);

      await transaction.update(record.reference, {'votes' : fresh.votes + 1});
      });
  }


  void _deleteItem(Record record) {
    Firestore.instance.runTransaction((tx) async {
      String docId = record.reference.documentID;
      final freshSnapshot = await tx.get(record.reference);
      final current = Record.fromSnapshot(freshSnapshot);
      
      await tx.delete(record.reference);

    });

  }

  // TODO add to contacts
  // TODO firebase collection of related user id
  void _addToContacts(Record record) {

  }
  // https://marcinszalek.pl/flutter/flutter-fullscreendialog-tutorial-weighttracker-ii/
  _buildForm(BuildContext context, GlobalKey<FormState> key) {
    var data = {};

    return Container(
      // width: MediaQuery.of(context).size.width,
      child: new AlertDialog(
      title: new Text("hello"),
      content: new Form(
        key: key,
        child: new Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "name"
              ),
              onSaved: (name) => data.addAll({"name": name}), 
              // need to follow database convention
            ),
            // https://github.com/ctalladen78/flutter_form_app/blob/master/lib/main.dart
            // https://www.developerlibs.com/2018/06/flutter-event-alert-with-pop-up.html
            TextFormField(
              controller: _voteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "how many votes"
              ),
              onSaved: (votes) => data.addAll({"votes": votes}),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          // width: MediaQuery.of(context).size.width, 
          child: RaisedButton(
            child: Row( 
              children: <Widget>[
            IconButton(icon: Icon(Icons.send), onPressed: (){
              // print("test ${_nameController.text}");
              _submitForm(data, key);
              Navigator.of(context).pop(); // close alert
            }),
            Text("Submit",
              style: TextStyle()
            )
            ]
          )
             )
          ),
      ],
      )
    );

  }

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('baby').snapshots(),
    builder: (context, snapshot){
      if(!snapshot.hasData){ return LinearProgressIndicator();}

      var documents = snapshot.data.documents;
      return _buildList(context, documents);
    },
  );
}
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data){return _buildListItem(context, data);}).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  // https://codelabs.developers.google.com/codelabs/flutter-firebase/#10
  final record = Record.fromSnapshot(data);

  return Padding(
    // key: ValueKey(record.reference.documentID), 
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
    child: Container(
      // constraints: ,
      height: 70.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        // leading: CircleAvatar(backgroundImage: Image.network(src)),
        leading: ApiService().getUserImage(),
        title: Row(
                children: <Widget>[
                  new Expanded(child: new Text(record.name)),
                  new Expanded(child: Text(record.votes.toString())),
                  new IconButton(
                    onPressed: (){_deleteItem(record);},
                    icon: new Icon(Icons.delete))
                  ]),
        // title: Text(record.name),
        // trailing: Text(record.votes.toString()),
        // onTap: () {_addToContacts(record)},
        onTap: () {_update(record);}, // NOTE: this nested event listener seems unintuitive but here it works 
      ),
    ),
  );
}

}

class Record {
  final String name;
  final int votes;
  final DocumentReference reference; // reference to firestore document 

  Record.fromMap(Map<String, dynamic> map, {this.reference})
    : assert(map["name"] != null),
      assert(map["votes"] != null),
      name = map["name"],
      votes = map["votes"];
  
  Record.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record < $name : $votes >";
}