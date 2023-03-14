import 'dart:convert';
import 'package:finalproject/constant.dart';
import 'package:finalproject/likebutton.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

class DisplayComments extends StatefulWidget {
  final List data;
  const DisplayComments({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<DisplayComments> createState() => _DisplayCommentsState();
}

class _DisplayCommentsState extends State<DisplayComments> {

  List comments = <dynamic>[];
  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  Future<List<dynamic>> getComments() async {
    String apiUrl = 'https://640dc456b07afc3b0db58266.mockapi.io/posts/1/comments';
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> comments = jsonDecode(response.body);
      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> deleteComment(String commentId) async {
    setState(() {
      isLoading = true;
    });

    var url = 'https://640dc456b07afc3b0db58266.mockapi.io/posts/1/comments/${int.parse(commentId)}';
    var response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        comments.removeWhere((comment) => comment['commentId'] == commentId);
        isLoading = false;
      });
      _showMsg('Comment successfully deleted!');
    } else {
      setState(() {
        isLoading = false;
      });
      _showMsg('Failed to delete comment.');
    }
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

  bool isLoading = true;

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    var url = 'https://640dc456b07afc3b0db58266.mockapi.io/posts/1/comments';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as Map;
      final result = json['comments'] as List;
      setState(() {
        comments = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      appBar: AppBar(
        backgroundColor: primaryBGColor,
        title: const Text("Comments"),
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: FutureBuilder<List<dynamic>>(
          future: getComments(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.0),
                      Text('Loading...'),
                    ],
                  ));
            }
            List<dynamic> postComment = snapshot.data!;
            return ListView.builder(
              itemCount: postComment.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          child: Image.network(
                            "${postComment[index]['avatar']}",
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(
                          "${postComment[index]['alias']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainTextColor,
                          ),
                        ),
                        trailing: Text(
                          "${postComment[index]['createdAt']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                            color: mainTextColor,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('${postComment[index]['comment']}',
                          style: TextStyle(
                            color: mainTextColor,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Center(
                            child: LikeButton(),
                          ),
                          IconButton(
                            onPressed: (){
                              showDialog(context: context,
                                  builder: (context){
                                    return AlertDialog(
                                        backgroundColor: gradientEndColor,
                                        title: Text("Delete Comment",
                                          style: TextStyle(
                                            color: mainTextColor,
                                          ),),
                                        content: Text("Are you sure you want to delete your comment?",
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
                                                color: mainTextColor,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteComment(comments[index]['commentId']);
                                              Navigator.pop(context);
                                            },
                                            child: Text("Yes",
                                              style: TextStyle(
                                                color: mainTextColor,
                                              ),
                                            ),
                                          ),
                                        ]
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                        indent: 5,
                        endIndent: 5,
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

