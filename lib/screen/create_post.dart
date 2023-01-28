import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:convert' as convert;


Future<PostModel> createPost(int? postId, String message, String user, String createdAt) async {
  final response = await http.post(
    Uri.parse("https://63cb9d8cea85515415128b2b.mockapi.io/api/posts"),
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

  getPosts() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/posts';
    var response = await http.get(Uri.parse(url));

    setState( () {
      posts = convert.jsonDecode(response.body) as List<dynamic>;
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Post"),
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              TextFormField(
                controller: userController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "Alias",
                  hintText: "Ex. The Ecologist",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Post Here",
                  hintText: "How was your day?",
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      createPost(
                          posts.lastIndexOf('postId', 0),
                          messageController.text,
                          userController.text,
                          formattedDate
                      );
                    });
                    messageController.clear();
                    userController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent
                  ),
                  child: const Text("POST", style: TextStyle(color: Colors.black, fontSize: 17))
              ),
            ],
          )
      ),
    );
  }
}
