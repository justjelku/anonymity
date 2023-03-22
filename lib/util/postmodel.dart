import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<PostModel> createPost(int? postId, String message, String user, String createdAt) async {
  final response = await http.post(
    Uri.parse("https://640dc456b07afc3b0db58266.mockapi.io/posts"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{
      "postId": postId,
      "message": message,
      "user": user,
      "createdAt": createdAt,
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
      postId: json['postId'], message: json["message"], user: json["user"], createdAt: json["createdAt"],);

  Map<String, dynamic> toMap() => {
    "postId": postId,
    "message": message,
    "user": user,
    "createdAt": createdAt,
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