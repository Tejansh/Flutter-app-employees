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
  final String deleteUserURI = "/deleteUser?id=";
  HttpClient httpClient = new HttpClient();



  Future<List> _getAllUsers() async {
    print("Requesting...");

    //Uri.parse(this.URL + this.getAllUsersURI);
    var request = await httpClient.getUrl(
        Uri.parse(this.URL + this.getAllUsersURI));
    var response = await request.close();
    users = await response.transform(UTF8.decoder).transform(JSON.decoder).toList();
    print(users);
    //print(responseString.toString());
    return users;
  }

Future<Null> _deleteUser(String id) async{
    print("Requesting to delete user with id " + id);

    var request = await httpClient.deleteUrl(Uri.parse(this.URL + this.deleteUserURI + id));
    var response = await request.close();

    print("Successfully deleted user");

    return null;
  }

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
        onTap: (){Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ViewUserDetails(user["id"].toString())));},
        leading: new Text(user["id"].toString()),

        trailing: new IconButton(
            icon: new Icon(
              Icons.delete,
              color: Colors.grey[500],
            ),
            onPressed: (){
              return showDialog(
                  context: context,
                  barrierDismissible: true,
                  child: new AlertDialog(
                    content: new Text("Are you sure you want to delete this user?"),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: new Text("Cancel")),
                      new FlatButton(
                          onPressed: () async
              {
              this._deleteUser(user["id"]
                  .toString());
              await setState((){
                this._getAllUsers();
                Navigator.pop(context);
              });

              },
              child: new Text("Yes, delete this user."))
                    ],

                  ),


              );

            }),
      ));}

    }
  return list;
  }





}

class ViewUserDetails extends StatefulWidget{

  String id;
  ViewUserDetails(String id){
    this.id=id;
  }

  @override
  createState() => new ViewUserDetailsState(id);

}
class ViewUserDetailsState extends State<ViewUserDetails>{


  String id;
  ViewUserDetailsState(String id){
    print(id);
   this.id=id;
  }




  List<Map<dynamic, dynamic>> userDetails=[];

  final String URL = "http://192.168.99.100:8080";
  final String getUserDetailsURI = "/getUser?id=";

  Future<List> getUserDetails() async {
   print("Requesting with id " + this.id);
    HttpClient httpClient = new HttpClient();
   // Uri.parse(this.URL + this.getUserDetailsURI + this.id);
    var request = await httpClient.getUrl(
        Uri.parse(this.URL + this.getUserDetailsURI + this.id));
    var response = await request.close();
    userDetails = await response.transform(UTF8.decoder).transform(JSON.decoder).toList();
    print(userDetails);
    //print(responseString.toString());
    return userDetails;
  }


  @override
  
  void initState() {

    super.initState();
    print("Calling getUserDetails with id: " + this.id);
    this.getUserDetails();
  }


  @override
  Widget build(BuildContext context){
  return new Scaffold(
  appBar: new AppBar(
  title: new Text("User Details",),
  centerTitle: true,
  ),
  body:
    new Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: this._constructTile()



  ),


  );


  }

  List<ListTile> _constructTile(){
    List<ListTile> list= [];
        if (this.userDetails.length != 0)
          {
            list.add(
                new ListTile(
                  title: new Text("ID: " + userDetails[0]["id"].toString()),
                  leading: new Icon(Icons.work, color: Colors.grey[600],),
                )
            );
            list.add( new ListTile(
              title: new Text("Name: " + userDetails[0]["name"]),
              leading: new Icon(Icons.person, color: Colors.grey[600],),
            )
            );
            list.add(
                new ListTile(
                  title: new Text("Date of Birth: " + userDetails[0]["dob"].toString()),
                  leading: new Icon(Icons.cake, color: Colors.grey[600],),
                )
            );
            list.add(
                new ListTile(
                  title: new Text("Age: " + userDetails[0]["age"].toString()),
                  leading: new Icon(Icons.perm_identity, color: Colors.grey[600],),
                )
            );
          }
        return list;

  }


}



