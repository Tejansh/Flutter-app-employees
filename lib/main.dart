import 'package:flutter/material.dart';
import 'package:intl/number_symbols_data.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(new MaterialApp(
    title: 'Employee Management',
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Employee Management'),
        centerTitle: true,
      ),
      body: new Card(
        child: new Column(
          children: [
            new ListTile(
              title: new Text(
                'View Employees',
                style: new TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: new IconButton(
                icon: new Icon(
                  Icons.view_list,
                  color: Colors.blue[600],
                ),
                //TODO: Add onPressed action to navigate to "ViewUsers" widget
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ViewUsers()),
                  );
                },
              ),
            ),
            new ListTile(
              title: new Text(
                'Add Employees',
                style: new TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: new IconButton(
                  icon: new Icon(
                    Icons.add,
                    color: Colors.blue[600],
                  ),
                  //TODO: Add onPressed action to navigate to "Add Users" widget
                  onPressed: null),
            )
          ],
        ),
      ),
    );
  }
}

class ViewUsers extends StatefulWidget {
  @override
  ViewUsersState createState() => new ViewUsersState();
}

class ViewUsersState extends State<ViewUsers> {
  List<List<Map<dynamic, dynamic>>> users = [];

  final String URL = "http://192.168.99.100:8080";

  //final int port = 8080;
  final String getAllUsersURI = "/getAllUsers";
  final String getUserDetailsURI = "/getUser?id=";

  Future<String> httpInteraction(String action) {
    switch (action) {
      case 'get':
    }

    return null;
  }

  Future<List> _getAllUsers() async {
    print("Requesting...");
    HttpClient httpClient = new HttpClient();
    Uri.parse(this.URL + this.getAllUsersURI);
    var request = await httpClient.getUrl(
        Uri.parse(this.URL + this.getAllUsersURI));
    var response = await request.close();
    users = await response.transform(UTF8.decoder).transform(JSON.decoder).toList();
    print(users);
    //print(responseString.toString());
    return users;
  }

/*
  Future<List> getUser(String id) async {
    var response = await http.get(Uri.encodeFull(URL + getUserDetailsURI + id),
        headers: {"Accept": "application/json"});

    print(response);
    return JSON.decode(response);
  }
*/

  @override
  void initState() {
    super.initState();
    this._getAllUsers();
 }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('List of Users'),
        centerTitle: true,
      ),

      body:
          new Card(
          child: new Column(
           children: this._constructTile(),
    )));
  }

  List<ListTile>  _constructTile() {
    List<ListTile> list = [];
    //var formatter =

    for (var userlist in users){
      for (var user in userlist){
      list.add(new ListTile(
        title: new Text(user["name"]),
       // leading: new Text(user["id"].toString()),
        trailing: new IconButton(
            icon: new Icon(
              Icons.delete,
              color: Colors.grey[500],
            ),
            onPressed: null),
      ));}

    }
  return list;
  }

}



