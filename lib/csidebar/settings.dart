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
  int currentIndex = 0;
  var formKey = GlobalKey<FormState>();
  List users = <dynamic>[];
  int idNum = 0;
  late DB db;

  @override
  void initState() {
    super.initState();
    db = DB();
    getUsers();
  }

  getUsers() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users';
    var response = await http.get(Uri.parse(url));

    setState( () {
      users = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
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
        appBar: AppBar(
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
                    decoration: const InputDecoration(
                      labelText: "First Name",
                    ),
                    validator: (value){
                      return (value == '')? "Input First Name" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Last Name"
                    ),
                    validator: (value){
                      return (value == '')? "Input Last Name" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Username"
                    ),
                    validator: (value){
                      return (value == '')? "Input Username" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Password"
                    ),
                    validator: (value){
                      return (value == '')? "Input Password" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Email Address"
                    ),
                    validator: (value){
                      return (value == '')? "Input Email Address" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            updateAccount(
                                widget.data,
                                firstNameController.text,
                                lastNameController.text,
                                userNameController.text,
                                passwordController.text,
                                emailController.text);
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent
                      ),
                      child: const Text("UPDATE", style: TextStyle(color: Colors.black, fontSize: 17))
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: (){
                        idNum = widget.data;
                        setState(() {
                          deleteUser(idNum);
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage())
                        );
                      },
                      child: const Text("Delete Account",
                          style: TextStyle(color: Colors.red)
                      )
                  ),
                ]
            )
        )
    );
  }
}
