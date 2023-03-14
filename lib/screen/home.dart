import 'dart:convert';

import 'package:finalproject/constant.dart';
import 'package:finalproject/likebutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../csidebar/collapsible_sidebar.dart';
import 'add_comments.dart';
import 'create_post.dart';

class HomePage extends StatefulWidget {

  final List data;
  const HomePage({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading = true;
  List posts = <dynamic>[];
  List users = <dynamic>[];
  int postId = 0;
  int currentIndex = 0;
  List account = <dynamic>[];

  @override
  void initState() {
    fetchTodo();
    // getPosts();
    getUsers();
    getUser();
    setUser();
    super.initState();
  }

  setUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("displayUser", widget.data[0]['username']);
  }

  getUsers() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users';
    var response = await http.get(Uri.parse(url));

    setState(() {
      users = convert.jsonDecode(response.body) as List<dynamic>;
    });
  }

  getUser() async {
    for (int i = 0; i <= users.length; i++) {
      if (widget.data == users[i]['id']) {
        setState(() {
          currentIndex = i;
        });
        break;
      }
    }
  }

  Future<List<dynamic>> getPosts() async {
    var url = 'https://640dc456b07afc3b0db58266.mockapi.io/posts';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> posts = jsonDecode(response.body);
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> deletePost(String postId) async {
    setState(() {
      isLoading = true;
    });

    var url = 'https://640dc456b07afc3b0db58266.mockapi.io/posts/${int.parse(postId)}';
    var response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        posts.removeWhere((post) => post['postId'] == postId);
        isLoading = false;
      });
      _showMsg('Post successfully deleted!');
    } else {
      setState(() {
        isLoading = false;
      });
      _showMsg('Failed to delete post.');
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryBGColor,
            title: const Text("Anonymity",
            style: TextStyle(
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold
            )),
            centerTitle: true,
          ),
          drawer: NavBar(data: widget.data),
          backgroundColor: gradientEndColor,
          body: RefreshIndicator(
            onRefresh: fetchTodo,
            child: FutureBuilder<List<dynamic>>(
                future: getPosts(),
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
                  List<dynamic> posts = snapshot.data!;
                  return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        // final item = posts[index]['postId'] as String;
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
                          child: InkWell(
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    child: Image.network(
                                      "${posts[index]['avatar']}",
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  title: Text(
                                    "${posts[index]['user']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: mainTextColor,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    '${posts[index]['message']}',
                                    style: TextStyle(
                                      color: mainTextColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 250,
                                  width: 350,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 5  ,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      child: Image.network(
                                        "${posts[index]['avatar']}",
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: <Widget> [
                                    Row(
                                      children: [
                                        const Center(
                                          child: LikeButton(),
                                        ),
                                        IconButton(
                                          onPressed: (){
                                            postId = int.parse(posts[index]['postId']);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Comments(
                                                    data: int.parse(
                                                        posts[index]['postId'])
                                                ))
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.chat_bubble_outline_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: (){
                                            showDialog(context: context,
                                                builder: (context){
                                                  return AlertDialog(
                                                      backgroundColor: gradientEndColor,
                                                      title: Text("Delete Post",
                                                        style: TextStyle(
                                                          color: mainTextColor,
                                                        ),),
                                                      content: Text("Are you sure you want to delete your post?",
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
                                                            deletePost(posts[index]['postId']);
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  );
                }
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePost())
              );
            },
            backgroundColor: primaryBtnColor,
            child: Icon(Icons.add,
            color: mainTextColor,),
          ),
        );
  }
  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    var url = 'https://640dc456b07afc3b0db58266.mockapi.io/posts';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as Map;
      final result = json['posts'] as List;
      setState(() {
        posts = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}