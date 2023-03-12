import 'package:finalproject/constant.dart';
import 'package:finalproject/screen/auth/login_page.dart';
import 'package:flutter/material.dart';
import '../util/data_model.dart';
import '../util/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';


Future<DataModel> updateAccount(int id, String firstname, String lastname, String username, String password, String email) async {
  final response = await http.put(
    Uri.parse("https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users/$id"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
      'email': email
    }),
  );

  if (response.statusCode == 200) {
    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.statusCode);
  }
}

class Settings extends StatefulWidget {

  final int data;
  const Settings({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<DataModel> data = [];
  var formKey = GlobalKey<FormState>();
  List users = <dynamic>[];
  int idNum = 0;
  late DB db;
  late String username;
  List user = <dynamic>[];
  int userId = 0;

  @override
  void initState() {
    super.initState();
    getUser();
    db = DB();
  }

  Future<DataModel> getUser() async {
    final response = await http.get(
      Uri.parse("https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return DataModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }


  getUsers(int id) async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users/$id';
    var response = await http.get(Uri.parse(url));

    setState( () {
      users = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
        backgroundColor: primaryBGColor,
        content: Text(msg),
        action: SnackBarAction(
          label: 'Close',
          textColor: mainTextColor,
          onPressed: () {},
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  deleteUser(int id) async {
    var response = await http.delete(Uri.parse('https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users/$id'));

    if (response.statusCode == 200) {
      //print (response.statusCode); //to check if addTodo is success
    } else {
      throw Exception('${response.statusCode}: FAILED TO DELETED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
        appBar: AppBar(
          backgroundColor: primaryBGColor,
          centerTitle: true,
          title: const Text("Settings"),
        ),
        body: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text("Modify Account", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
                  TextFormField(
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Firstname",
                      // hintText: '${widget.item.first?[0]["firstname"] ?? "Firstname"}',
                      labelStyle: TextStyle(color: mainTextColor),
                      hintStyle: TextStyle(color: mainTextColor),
                    ),

                    validator: (value){
                      return (value == '')? "Input First Name" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: "Lastname",
                      // hintText: '${widget.item.first?[1]["lastname"] ?? "Lastname"}',
                      labelStyle: TextStyle(color: mainTextColor),
                      hintStyle: TextStyle(color: mainTextColor),
                    ),
                    validator: (value){
                      return (value == '')? "Input Last Name" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: "Username",
                      // hintText: '${widget.item.first?[2]["username"] ?? "Username"}',
                      labelStyle: TextStyle(color: mainTextColor),
                      hintStyle: TextStyle(color: mainTextColor),
                    ),
                    validator: (value){
                      return (value == '')? "Input Username" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Password",
                      // hintText: '${widget.item.first?[3]["password"] ?? "Password"}',
                      labelStyle: TextStyle(color: mainTextColor),
                      hintStyle: TextStyle(color: mainTextColor),
                    ),
                    validator: (value){
                      return (value == '')? "Input Password" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email Address",
                      // hintText: '${widget.item.first?[4]["email"] ?? "Email Address"}',
                      labelStyle: TextStyle(color: mainTextColor),
                      hintStyle: TextStyle(color: mainTextColor),
                    ),
                    validator: (value){
                      return (value == '')? "Input Email Address" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String firstName = firstNameController.text.trim();
                          String lastName = lastNameController.text.trim();
                          String userName = userNameController.text.trim();
                          String password = passwordController.text.trim();
                          String email = emailController.text.trim();

                          if (firstName.isNotEmpty && lastName.isNotEmpty && userName.isNotEmpty && password.isNotEmpty && email.isNotEmpty) {
                            setState(() {
                              updateAccount(
                                  widget.data,
                                  firstName,
                                  lastName,
                                  userName,
                                  password,
                                  email
                              );
                            });
                            Navigator.pop(context);
                          } else {
                            // Show an error message or toast to the user indicating that the fields cannot be empty
                            _showMsg("All fields are required");
                          }
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
                      child: const Text("Update", style: TextStyle(color: Colors.white, fontSize: 17))
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: (){
                        showDialog(context: context,
                            builder: (context){
                              return AlertDialog(
                                backgroundColor: primaryBGColor,
                                title: Text("Delete Account",
                                style: TextStyle(
                                  color: mainTextColor,
                                ),),
                                content: Text("Are you sure you want to delete your account?",
                                  style: TextStyle(
                                    color: mainTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text("No",
                                      style: TextStyle(
                                        color: secondaryBtnColor,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      idNum = widget.data;
                                      setState(() {
                                        deleteUser(idNum);
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LoginPage())
                                      );
                                    },
                                    child: Text("Yes",
                                      style: TextStyle(
                                        color: primaryBtnColor
                                      ),
                                    ),
                                ),
                              ]
                          );
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(secondaryBtnColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: Text("Delete Account",
                          style: TextStyle(color: mainTextColor)
                      )
                    ),
                  ]
              )
          )
    );
  }
}
