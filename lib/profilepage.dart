import 'dart:convert';

import 'package:anonymity/csidebar/settings.dart';
import 'package:anonymity/screen/auth/login_page.dart';
import 'package:anonymity/util/constant.dart';
import 'package:anonymity/util/data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:themed/themed.dart';

class UserProfile extends StatefulWidget {
  final List data;
  const UserProfile({
    required this.data,
    Key? key}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _error;
  List users = <dynamic>[];
  List user = <dynamic>[];
  int userId = 0;

  void initState() {
    getUsers();
    super.initState();

  }

  Future<List<dynamic>> getUsers() async {
    var url = 'https://640d7547b07afc3b0dadbf4d.mockapi.io/users';
    var response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }),
    );
    _showMsg('Logout Success');
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


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStartColor, gradientEndColor],
          ),
        ),
      child: Scaffold(
        backgroundColor: gradientEndColor,
        appBar: AppBar(
          backgroundColor: gradientStartColor,
          title: Text('${widget.data[0]['username']}'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ChangeColors(
                        hue: 0.55,
                        brightness: 0.2,
                        saturation: 0.1,
                        child: Image.asset("assets/logo.png",
                            width: 300,
                            height: 300)
                    ),
                    Text(
                      'Welcome, ${widget.data[0]['firstname']} ${widget.data[0]['lastname']}!',
                      style: const TextStyle(fontSize: 24.0),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Username: ${widget.data[0]['username']}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Email: ${widget.data[0]['email']}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                        onPressed: (){
                          userId = int.parse(widget.data[0]['userId']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings(
                                    data: userId,
                                  )
                              ));
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
                        icon: SizedBox(
                          height: 20,
                          child: Icon(Icons.edit, color: mainTextColor,),
                        ),
                        label: Text("Edit Profile", style: TextStyle(color: mainTextColor),)
                    ),
                    TextButton.icon(
                        onPressed: (){
                          _logOut();
                        },
                        icon: SizedBox(
                          height: 30,
                          child: Icon(Icons.login_outlined, color: secondaryTextColor,),
                        ),
                        label: Text("Log Out", style: TextStyle(color: secondaryTextColor),)
                    ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                _error ?? 'Error retrieving user data.',
                style: const TextStyle(fontSize: 18.0),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }
}
