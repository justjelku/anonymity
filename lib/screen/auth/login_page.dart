import 'package:anonymity/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:anonymity/util/data_model.dart';
import 'package:anonymity/util/database.dart';
import 'package:anonymity/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert' as convert;
import 'package:themed/themed.dart';

Future<DataModel> userModel(int? userId, String firstname, String lastname, String username, String password, String email) async {
  final response = await http.post(
    Uri.parse("https://640d7547b07afc3b0dadbf4d.mockapi.io/users"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{
      'userId': userId,
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
    throw Exception('Failed to Add User');
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
    var url = 'https://640d7547b07afc3b0dadbf4d.mockapi.io/users';
    var response = await http.get(Uri.parse(url));

    setState( () {
      accounts = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }

  Future loginData() async {
    var username = userNameController.text;
    var password = passwordController.text;

    for (var i = 0; i < accounts.length; i++) {
      if (username == accounts[i]['username'] &&
          password == accounts[i]['password']) {
        _showMsg('Login Success');
        account.add(accounts[i]);
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(data: account))
        );
        return;
      }
    }
    // Display error message
    _showMsg('Incorrect username or password');
  }


  _showMsg(msg) {
    final snackBar = SnackBar(
      backgroundColor: gradientStartColor,
        content: Text(msg),
        action: SnackBarAction(
          label: 'Close',
          textColor: mainTextColor,
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
        backgroundColor: gradientEndColor,
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
                  const Text("ANONYMITY 2.1",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 25),
                  Text("Welcome $displayUser !",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Username",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    validator: (value){
                      return (value == '')? "Username" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                      )
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        loginData();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(primaryBtnColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),

                      child: const Text("Sign In",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17
                          )
                      )
                  ),
                  TextButton(
                      onPressed: (){
                        showMyDialogue();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: const Text("Create Account",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      )
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: gradientEndColor,
            scrollable: true,
            title: Text('Create Account',
              style: TextStyle(
                color: mainTextColor,
              ),
            ),
            content: Container(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "First Name",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                      ),
                      validator: (value){
                        return (value == '')? "First Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "Last Name",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                      ),
                      validator: (value){
                        return (value == '')? "Last Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "Username",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                      ),
                      validator: (value){
                        return (value == '')? "Username" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                      ),
                      validator: (value){
                        return (value == '')? "Password" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email Address",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                      ),
                      validator: (value){
                        return (value == '')? "Email Address" : null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Validation passed, no blank fields found
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
                      userModel(
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
                  } else {
                    // Validation failed, at least one field is blank
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill out all fields.'),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(primaryBtnColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                child: Center(
                  child: Text("Sign Up",
                    style: TextStyle(
                      color: mainTextColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}