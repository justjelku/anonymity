import 'dart:io';
import 'package:finalproject/constant.dart';
import 'package:finalproject/screen/display_comments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<CommentModel> addComment(int commentId, int? postId, String comment, String alias, String createdAt) async {
  final response = await http.post(
    Uri.parse("https://640d2439b07afc3b0da82c47.mockapi.io/posts/1/comments"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{
      "commentId": commentId,
      "postId": postId,
      "comment": comment,
      "alias": alias,
      "createdAt": createdAt
    }),
  );

  if (response.statusCode == 201) {
    return CommentModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Add Post');
  }
}

class CommentModel {
  int? commentId;
  int postId;
  String comment;
  String alias;
  String createdAt;

  CommentModel({this.commentId, required this.postId, required this.comment, required this.alias, required this.createdAt});

  factory CommentModel.fromMap(Map<String, dynamic> json) => CommentModel(
      commentId: json['commentId'], postId: json['postId'], comment: json["comment"], alias: json["alias"], createdAt: json["createdAt"]);

  Map<String, dynamic> toMap() => {
    "commentId": commentId,
    "postId": postId,
    "comment": comment,
    "alias": alias,
    "createdAt": createdAt
  };


  factory CommentModel.fromJson(Map<dynamic, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'],
      postId: json['postId'],
      comment: json['comment'],
      alias: json['alias'],
      createdAt: json['createdAt'],
    );
  }
}

class Comments extends StatefulWidget {

  final int data;
  const Comments({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController aliasController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  File? file;
  ImagePicker image = ImagePicker();

  List post = <dynamic>[];
  List comments = <dynamic>[];
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy/HH:mm:ss').format(DateTime.now());
  List postComments = <dynamic>[];
  int currentIndex = 0;

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  getPosts() async {
    var url = 'https://640d2439b07afc3b0da82c47.mockapi.io/posts';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _showMsg(jsonData);
    } else {
      _showMsg('Failed to get post: ${response.statusCode}');
    }

    setState(() {
      post = jsonDecode(response.body) as List<dynamic>;
    });
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



  getComments(int data) async {
    var url = 'https://640d2439b07afc3b0da82c47.mockapi.io/posts/1/comments';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);

    setState( () {
      comments = convert.jsonDecode(response.body) as List<dynamic>;
      for(int i = 0; i < comments.length; i++){
        if(data == comments[comments.length]['postId']){
          postComments.add(comments[i]);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: gradientEndColor,
      appBar: AppBar(
        backgroundColor: primaryBGColor,
        title: const Text("Add Comment"),
      ),
      body: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(30),
                  children: [
                    TextFormField(
                      controller: aliasController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Alias",
                        hintText: "Ex. The Ecologist",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: commentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: "Write a comment",
                        hintText: "Comment here",
                        labelStyle: TextStyle(color: mainTextColor),
                        hintStyle: TextStyle(color: mainTextColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: gradientEndColor,
                                title:  Text("Please choose",
                                  style: TextStyle(
                                    color: mainTextColor,
                                  ),
                                ),
                                content: Text("From:",
                                  style: TextStyle(
                                    color: mainTextColor,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      // getCam();
                                      PermissionStatus cameraStatus = await Permission.camera.request();
                                      if (cameraStatus == PermissionStatus.granted) {
                                        getCam(ImageSource.camera);
                                      } else if (cameraStatus == PermissionStatus.denied) {
                                        return ;
                                      }

                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Text("Camera",
                                        style: TextStyle(
                                          color: mainTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // getGall();
                                      PermissionStatus cameraStatus = await Permission.storage.request();
                                      if (cameraStatus == PermissionStatus.granted) {
                                        getGall(ImageSource.gallery);
                                      } else if (cameraStatus == PermissionStatus.denied) {
                                        return;
                                      }

                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Text("Gallery",
                                        style: TextStyle(
                                          color: mainTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Text("Cancel",
                                        style: TextStyle(
                                          color: mainTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.image),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                          String commentText = commentController.text.trim();
                          String aliasText = aliasController.text.trim();
                          if (commentText.isNotEmpty && aliasText.isNotEmpty) {
                            setState(() {
                              addComment(
                                  comments.lastIndexOf('commentId', 0),
                                  widget.data,
                                  commentText,
                                  aliasText,
                                  formattedDate
                              );
                            });
                            commentController.clear();
                            aliasController.clear();
                          } else {
                            // Show an error message or toast to the user indicating that the fields cannot be empty
                            _showMsg("Comment and alias fields cannot be empty");
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
                        child: Text("Comment", style: TextStyle(color: mainTextColor, fontSize: 17))
                    ),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          getComments(widget.data);
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DisplayComments(data: postComments))
                        );
                      },
                      child: Text("See All Comments",
                      style: TextStyle(
                        color: primaryBGColor,
                      ),),
                    ),
                  ],
                )
            ),
    );
  }
  getCam(ImageSource source) async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.camera);
    setState(() {
      file = File(img!.path);
    });
  }

  getGall(ImageSource source) async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }
}
