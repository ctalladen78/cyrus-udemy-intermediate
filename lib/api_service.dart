import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<String> _getUri(http.Client client) async {
    var response = await client.get('https://randomuser.me/api');
    if(response.statusCode == 200){
      Map<String, dynamic> parsed = json.decode(response.body);
      var uri = parsed["results"][0]["picture"]["large"];
      return uri;
    }
    return ""; // if response fail
  }

  Widget getUserImage() {
    return FutureBuilder(
      future: _getUri(http.Client()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return new CircleAvatar(
            radius: 32.0,
            backgroundColor: Colors.white,
            child: new CircleAvatar(
              radius: 30.0,
              backgroundImage: new NetworkImage(snapshot.data),
            ), 
          );
        }
        return new Center(child: new CircularProgressIndicator());
      },
    );
  }
}