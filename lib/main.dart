import 'package:flutter/material.dart';
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
                //TODO: Add onPressed action to navigate to "ViewEmployees" widget
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ViewEmployees()),
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
                  //TODO: Add onPressed action to navigate to "Add Employees" widget
                  onPressed: (){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new CreateEmployee()),
                    );


                  }),
            )
          ],
        ),
      ),
    );
  }
}

class ViewEmployees extends StatefulWidget {
  @override
  ViewEmployeesState createState() => new ViewEmployeesState();
}

class ViewEmployeesState extends State<ViewEmployees> {
  List<List<Map<dynamic, dynamic>>> employees = [];

  final String URL = "http://192.168.99.100:8080";

  //final int port = 8080;
  final String getAllEmployeesURI = "/getAllUsers";
  final String deleteEmployeeURI = "/deleteUser?id=";
  HttpClient httpClient = new HttpClient();



  Future<List> _getAllEmployees() async {
    print("Requesting...");

    //Uri.parse(this.URL + this.getAllEmployeesURI);
    var request = await httpClient.getUrl(
        Uri.parse(this.URL + this.getAllEmployeesURI));
    var response = await request.close();
    employees = await response.transform(UTF8.decoder).transform(JSON.decoder).toList();
    print(employees);
    //print(responseString.toString());
    return employees;
  }

Future<Null> _deleteEmployee(String id) async{
    print("Requesting to delete employee with id " + id);

    var request = await httpClient.deleteUrl(Uri.parse(this.URL + this.deleteEmployeeURI + id));
    var response = await request.close();

    print("Successfully deleted employee");

    return null;
  }

  @override
  void initState() {
    super.initState();
    this._getAllEmployees();
 }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('List of Employees'),
        centerTitle: true,
      ),

      body:
          new Card(
          child: new ListView(
            scrollDirection: Axis.vertical,
           children: this._constructTile(),
    )));
  }


  List<ListTile>  _constructTile() {
    List<ListTile> list = [];
    //var formatter =

    for (var employeelist in employees){
      for (var employee in employeelist){
      list.add(new ListTile(
        title: new Text(employee["name"]),
        onTap: (){Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ViewEmployeeDetails(employee["id"].toString())));},
        leading: new Text(employee["id"].toString()),

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
                    content: new Text("Are you sure you want to delete this employee?"),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: new Text("Cancel")),
                      new FlatButton(
                          onPressed: () async
              {
              this._deleteEmployee(employee["id"]
                  .toString());
              await setState((){
                this._getAllEmployees();
                Navigator.pop(context);
              });

              },
              child: new Text("Yes, delete this employee."))
                    ],

                  ),


              );

            }),
      ));}

    }
  return list;
  }





}

class ViewEmployeeDetails extends StatefulWidget{

  String id;
  ViewEmployeeDetails(String id){
    this.id=id;
  }

  @override
  createState() => new ViewEmployeeDetailsState(id);

}
class ViewEmployeeDetailsState extends State<ViewEmployeeDetails>{


  String id;
  ViewEmployeeDetailsState(String id){
    print(id);
   this.id=id;
  }




  List<Map<dynamic, dynamic>> employeeDetails=[];

  final String URL = "http://192.168.99.100:8080";
  final String getEmployeeDetailsURI = "/getUser?id=";

  Future<List> getEmployeeDetails() async {
   print("Requesting with id " + this.id);
    HttpClient httpClient = new HttpClient();
   // Uri.parse(this.URL + this.getEmployeeDetailsURI + this.id);
    var request = await httpClient.getUrl(
        Uri.parse(this.URL + this.getEmployeeDetailsURI + this.id));
    var response = await request.close();
    employeeDetails = await response.transform(UTF8.decoder).transform(JSON.decoder).toList();
    print(employeeDetails);
    //print(responseString.toString());
    return employeeDetails;
  }


  @override
  
  void initState() {

    super.initState();
    print("Calling getEmployeeDetails with id: " + this.id);
    this.getEmployeeDetails();
  }


  @override
  Widget build(BuildContext context){
  return new Scaffold(
  appBar: new AppBar(
  title: new Text("Employee Details",),
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
        if (this.employeeDetails.length != 0)
          {
            list.add(
                new ListTile(
                  title: new Text("ID: " + employeeDetails[0]["id"].toString()),
                  leading: new Icon(Icons.work, color: Colors.grey[600],),
                )
            );
            list.add( new ListTile(
              title: new Text("Name: " + employeeDetails[0]["name"]),
              leading: new Icon(Icons.person, color: Colors.grey[600],),
            )
            );
            list.add(
                new ListTile(
                  title: new Text("Date of Birth: " + employeeDetails[0]["dob"].toString()),
                  leading: new Icon(Icons.cake, color: Colors.grey[600],),
                )
            );
            list.add(
                new ListTile(
                  title: new Text("Age: " + employeeDetails[0]["age"].toString()),
                  leading: new Icon(Icons.perm_identity, color: Colors.grey[600],),
                )
            );
          }
        return list;

  }


}

class CreateEmployee extends StatefulWidget{

  @override
  createState()=> new CreateEmployeeState();
}


class CreateEmployeeState extends State<CreateEmployee>{

  String _employeename;
  int _age;
  DateTime _dob;
  final TextEditingController controller = new TextEditingController();

  final String URL = "http://192.168.99.100:8080";

  //final int port = 8080;
  final String createEmployeeURI = "/addUser";

  HttpClient httpClient = new HttpClient();

  var created = false;


  selectDate(DateTime date){

    this._dob = date;

    _age =  ((new DateTime.now().difference(_dob)).inHours/8760).ceil();
    print(_dob);

  }


  Future<Null> _selectDate() async{

    final DateTime dob = await showDatePicker(
        context: context,
        initialDate: new DateTime(1992,5),
        firstDate: new DateTime(1900,1),
        lastDate: new DateTime(2018,1)
    );
    if (dob != null){
       selectDate(dob);
    }
    return null;

  }

  Future<Null> _saveEmployee() async{

   var requestBodyMap = {"name":_employeename,"dob":_dob.toIso8601String(),"age":_age};

    var requestBodyJson = JSON.encode( requestBodyMap);
    print(requestBodyJson);

    var request = await httpClient.postUrl(Uri.parse(URL+createEmployeeURI))
        ..headers.add(HttpHeaders.ACCEPT, ContentType.JSON)
        ..headers.contentType=ContentType.JSON;
    
    request.write(requestBodyJson);
    HttpClientResponse response = await request.close();

    setState(() =>
    response.statusCode==HttpStatus.OK?
              created=true:created=false);









  }



  @override
  Widget build(BuildContext context){
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("Add a new Employee"),
      centerTitle: true,
      actions: <Widget>[
        new IconButton(icon: new Icon(Icons.save,), onPressed: () async {
          var response = await _saveEmployee();
         created? new SimpleDialog(
          title: new Text("Employee created!"),
          children: <Widget>[
            new FlatButton(onPressed: ()=>Navigator.pop(context), child: new Text("Okay"),)
          ],
          ):new SimpleDialog(
            title: new Text("Employee could not be created!"),
            children: <Widget>[
              new FlatButton(onPressed: ()=>Navigator.pop(context), child: new Text("Okay"),)
            ],
          );
        })
      ],
    ),

    body: new Column(
      children: <Widget>[

        new ListTile(
          leading: new Icon(Icons.person),
          title: new TextField(
              controller: controller,
              decoration: new InputDecoration(
              hintText: "Name",
            ),
           autocorrect: false,
           onChanged: (String name){

              this._employeename=name;
           },

          ),
        ),
        new ListTile(
          leading: new Icon(Icons.today),
          title: new Text("Select date of birth"),
          onTap: (){
            _selectDate();
             },

          )

      ],
    ),

  );




  }


}

