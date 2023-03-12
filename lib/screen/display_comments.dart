import 'dart:convert';
import 'package:finalproject/constant.dart';
import 'package:finalproject/likebutton.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DisplayComments extends StatelessWidget {

  final List data;
  const DisplayComments({
    required this.data,
    Key? key}) : super(key: key);

  Future<List<dynamic>> getComments() async {
    String apiUrl = 'https://640d2439b07afc3b0da82c47.mockapi.io/posts/1/comments';
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> comments = jsonDecode(response.body);
      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      appBar: AppBar(
        backgroundColor: primaryBGColor,
        title: const Text("Comments"),
      ),
      body: FutureBuilder<List<dynamic>>(
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: LikeButton(),
                        ),
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
    );
  }
}
