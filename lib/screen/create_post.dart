import 'package:finalproject/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:convert' as convert;


Future<PostModel> createPost(int? postId, String message, String user, String createdAt) async {
  final response = await http.post(
    Uri.parse("https://640d2439b07afc3b0da82c47.mockapi.io/posts"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{
      "postId": postId,
      "message": message,
      "user": user,
      "createdAt": createdAt
    }),
  );

  if (response.statusCode == 201) {
    return PostModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Add Post');
  }
}

class PostModel {
  int? postId;
  String message;
  String user;
  String createdAt;

  PostModel({this.postId, required this.message, required this.user, required this.createdAt});

  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
      postId: json['postId'], message: json["message"], user: json["user"], createdAt: json["createdAt"]);

  Map<String, dynamic> toMap() => {
    "postId": postId,
    "message": message,
    "user": user,
    "createdAt": createdAt
  };


  factory PostModel.fromJson(Map<dynamic, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      message: json['message'],
      user: json['user'],
      createdAt: json['createdAt'],
    );
  }
}

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();

}


class _CreatePostState extends State<CreatePost> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  List posts = <dynamic>[];
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy/HH:mm:ss').format(DateTime.now());


  @override
  void initState() {
    super.initState();
    getPosts();
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

  getPosts() async {
    var url = 'https://640d2439b07afc3b0da82c47.mockapi.io/posts';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);

    setState( () {
      posts = convert.jsonDecode(response.body) as List<dynamic>;
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBGColor,
        title: const Text("Create a Post"),
      ),
        backgroundColor: gradientEndColor,
      body: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(30),
                  children: [
                    TextFormField(
                      controller: userController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Alias",
                        hintText: "Ex. The Ecologist",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: "Write here",
                        hintText: "How was your day?",
                        labelStyle: TextStyle(
                            color: mainTextColor,
                        ),
                        hintStyle: TextStyle(color: mainTextColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                          String messageText = messageController.text.trim();
                          String userText = userController.text.trim();
                          if (messageText.isNotEmpty && userText.isNotEmpty) {
                            setState(() {
                              createPost(
                                  posts.lastIndexOf('postId', 0),
                                  messageText,
                                  userText,
                                  formattedDate
                              );
                            });
                            messageController.clear();
                            userController.clear();
                          } else {
                            // Show an error message or toast to the user indicating that the fields cannot be empty
                            _showMsg("Message and user fields cannot be empty");
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
                        child: Text("Post", style: TextStyle(color: mainTextColor, fontSize: 17))
                    ),
                  ],
                )
            ),
    );
  }
}
