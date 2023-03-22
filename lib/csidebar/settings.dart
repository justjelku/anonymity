import 'package:anonymity/util/constant.dart';
import 'package:anonymity/screen/auth/login_page.dart';
import 'package:flutter/material.dart';
import '../util/data_model.dart';
import '../util/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';


Future<DataModel> updateAccount(int userId, String firstname, String lastname, String username, String password, String email) async {
  final response = await http.put(
    Uri.parse("https://640d7547b07afc3b0dadbf4d.mockapi.io/users/$userId"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userId': userId,
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUser();
    db = DB();
  }

  Future<DataModel> getUser() async {
    final response = await http.get(
      Uri.parse("https://640d7547b07afc3b0dadbf4d.mockapi.io/users/"),
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
    var url = 'https://640d7547b07afc3b0dadbf4d.mockapi.io/users/$id';
    var response = await http.get(Uri.parse(url));

    setState( () {
      users = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
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

  deleteUser(int userId) async {
    var response = await http.delete(Uri.parse('https://640d7547b07afc3b0dadbf4d.mockapi.io/users/$userId'));

    if (response.statusCode == 200) {
      //print (response.statusCode); //to check if addTodo is success
    } else {
      throw Exception('${response.statusCode}: FAILED TO DELETE');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
        appBar: AppBar(
          backgroundColor: gradientStartColor,
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
                          // initialValue: users['firstname'],
                          decoration: InputDecoration(
                            labelText: "Firstname",
                            // hintText: '${widget.item.first?[0]["firstname"] ?? "Firstname"}',
                            labelStyle: TextStyle(color: mainTextColor),
                            hintStyle: TextStyle(color: mainTextColor),
                          ),

                          validator: (value){
                            return (value == '')? "Input First Name" : null;
                          },
                          // onSaved: (value) {
                          //   firstNameController.text = value!;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          // initialValue: userData['lastname'],
                          decoration: InputDecoration(
                            labelText: "Lastname",
                            // hintText: '${widget.item.first?[1]["lastname"] ?? "Lastname"}',
                            labelStyle: TextStyle(color: mainTextColor),
                            hintStyle: TextStyle(color: mainTextColor),
                          ),
                          validator: (value){
                            return (value == '')? "Input Last Name" : null;
                          },
                          // onSaved: (value) {
                          //   lastNameController.text = value!;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: userNameController,
                          keyboardType: TextInputType.name,
                          // initialValue: userData['username'],
                          decoration: InputDecoration(
                            labelText: "Username",
                            // hintText: '${widget.item.first?[2]["username"] ?? "Username"}',
                            labelStyle: TextStyle(color: mainTextColor),
                            hintStyle: TextStyle(color: mainTextColor),
                          ),
                          validator: (value){
                            return (value == '')? "Input Username" : null;
                          },
                          // onSaved: (value) {
                          //   userNameController.text = value!;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          // initialValue: userData['password'],
                          decoration: InputDecoration(
                            labelText: "Password",
                            // hintText: '${widget.item.first?[3]["password"] ?? "Password"}',
                            labelStyle: TextStyle(color: mainTextColor),
                            hintStyle: TextStyle(color: mainTextColor),
                          ),
                          validator: (value){
                            return (value == '')? "Input Password" : null;
                          },
                          // onSaved: (value) {
                          //   passwordController.text = value!;
                          // },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          // initialValue: userData['email'],
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            labelStyle: TextStyle(color: mainTextColor),
                            hintStyle: TextStyle(color: mainTextColor),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          // onSaved: (value) {
                          //   emailController.text = value!;
                          // },
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
                                  // _saveForm();
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
                                        backgroundColor: gradientStartColor,
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
  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    var url = 'https://640d7547b07afc3b0dadbf4d.mockapi.io/users';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as Map;
      final result = json['users'] as List;
      setState(() {
        users = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
