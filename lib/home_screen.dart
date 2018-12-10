import 'package:flutter/material.dart';
import 'package:firebase_forms/contact_list.dart';
import 'package:firebase_forms/profile_screen.dart';
import 'package:firebase_forms/new_trip_form.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  HomeScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  HomePageState createState() => new HomePageState(currentUserId);
}

class HomePageState extends State<HomeScreen>{
  final PageController controller = new PageController();
  int _selectedIndex = 0;
  HomePageState(String uid);

  BottomNavigationBar _buildFooter(){ 
      return new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            controller.animateToPage(
              _selectedIndex,
              duration: kTabScrollDuration,
              curve: Curves.fastOutSlowIn,
            );
          });
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.add),
            title: new Text('Book'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new PageView(
        controller: controller,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: <Widget>[
          ContactListScreen(currentUserId: widget.currentUserId),
          // TODO use tripId to reference messages
          // TODO CreateTripForm(),
          NewTripForm(),
          // TODO ContactsListScreen(),   // => TODO ChatListScreen()
          // TODO PublicProfileScreen(),  // => TODO PrivateProfileScreen()
          PublicProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildFooter(), 
    );
  }
}
