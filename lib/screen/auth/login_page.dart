import 'package:flutter/material.dart';
import 'package:finalproject/util/data_model.dart';
import 'package:finalproject/util/database.dart';
import 'package:finalproject/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert' as convert;
import 'package:themed/themed.dart';

Future<DataModel> postAccount(int? id, String firstname, String lastname, String username, String password, String email) async {
  final response = await http.post(
    Uri.parse("https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
      'email': email
    }),
  );

  if (response.statusCode == 201) {
    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Add Todo');
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List accounts = <dynamic>[];
  List account = <dynamic>[];
  var formKey = GlobalKey<FormState>();
  List<DataModel> data = [];
  late int currentIndex;
  late DB db;
  String? displayUser;


  @override
  void initState() {
    db = DB();
    db.initDB();
    checkPermission();
    getUsers();
    getUsername();
    super.initState();
  }


  checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();
    statuses[Permission.storage];
  }


  getUsers() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users';
    var response = await http.get(Uri.parse(url));

    setState( () {
      accounts = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }

  Future loginData() async {
    var username = userNameController.text;
    var password = passwordController.text;

    for (var i = 0; i <= accounts.length; i++) {
      if (username == accounts[i]['username'] &&
          password == accounts[i]['password']) {
        _showMsg('Login Success');
        account.add(accounts[i]);
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(data: account))
        );
        break;
      }
    }

  }
  _showMsg(msg) {
    final snackBar = SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getUsername() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      displayUser = pref.getString('displayUser')!;
    });
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formKey,
            child: ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  ChangeColors(
                      hue: 0.55,
                      brightness: 0.2,
                      saturation: 0.1,
                      child: Image.asset("assets/logo.png",
                          width: 300,
                          height: 300)
                  ),
                  const Text("ANONYMITY", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 25),
                  Text("Welcome $displayUser !", style: const TextStyle(fontSize: 15, color: Colors.white, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Username",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                    ),
                    validator: (value){
                      return (value == '')? "Input Name" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      )
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        loginData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent
                      ),
                      child: const Text("Sign In", style: TextStyle(color: Colors.black, fontSize: 17))
                  ),
                  TextButton(
                      onPressed: (){
                        showMyDialogue();
                      },
                      child: const Text("Create Account")
                  )
                ]
            )
        )
    );
  }

  void showMyDialogue() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Create Account'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "First Name"),
                      validator: (value){
                        return (value == '')? "Input First Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Last Name"),
                      validator: (value){
                        return (value == '')? "Input Last Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Username"),
                      validator: (value){
                        return (value == '')? "Input Username" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Password"),
                      validator: (value){
                        return (value == '')? "Input Password" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "Email Address"),
                      validator: (value){
                        return (value == '')? "Input Email Address" : null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    currentIndex = accounts.indexOf('id', 0);
                    DataModel dataLocal = DataModel(
                      firstname: firstNameController.text,
                      lastname: lastNameController.text,
                      username: userNameController.text,
                      password: passwordController.text,
                      email: emailController.text,
                    );
                    db.insertData(dataLocal);
                    setState(() {
                      postAccount(
                          currentIndex,
                          firstNameController.text,
                          lastNameController.text,
                          userNameController.text,
                          passwordController.text,
                          emailController.text
                      );
                    });
                    firstNameController.clear();
                    lastNameController.clear();
                    userNameController.clear();
                    passwordController.clear();
                    emailController.clear();
                  }
                },
                child: const Center(
                  child: Text("Sign Up"),
                ),
              ),
            ],
          );
        }
    );
  }
}