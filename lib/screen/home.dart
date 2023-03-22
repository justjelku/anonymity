import 'dart:async';
import 'dart:convert';
import 'package:anonymity/util/constant.dart';
import 'package:anonymity/util/likebutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../csidebar/collapsible_sidebar.dart';
import 'add_comments.dart';
import 'package:anonymity/util/postmodel.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';


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
  List comments = <dynamic>[];
  bool showNoCommentsText = false;
  bool showNoPostsText = false;

  final TextEditingController messageController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy/HH:mm:ss').format(
      DateTime.now());

  File? _image;

  @override
  void initState() {
    fetchPosts();
    fetchComments();
    getUsers();
    getUser();
    setUser();
    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: gradientStartColor,
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
          onRefresh: fetchPosts,
          child: FutureBuilder<List<dynamic>>(
              future: getPosts(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 16.0),
                        Text('Loading'),
                      ],
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ListTile(
                          title: Text('No anonymous posts yet'),
                          subtitle: Text('Be the first to post anonymously.'),
                        ),
                      ],
                    ),
                  );
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
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [gradientStartColor, gradientEndColor],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              // color: Colors.black.withOpacity(0.5),
                              color: Colors.transparent,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
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
                                  elevation: 5,
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
                                children: <Widget>[
                                  Row(
                                    children: [
                                      const Center(
                                        child: LikeButton(),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // postId =
                                          //     int.parse(posts[index]['postId']);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             Comments(
                                          //                 data: int.parse(
                                          //                     posts[index]['postId'])
                                          //             ))
                                          // );
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: gradientEndColor,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(50),
                                              ),
                                            ),
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return AnimatedContainer(
                                                duration: const Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                                height: 400,
                                                child: RefreshIndicator(
                                                  onRefresh: fetchComments,
                                                  child: FutureBuilder<List<dynamic>>(
                                                    future: getComments(),
                                                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Center(child: Text('Error: ${snapshot.error}'));
                                                      }
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return Center(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: const [
                                                              CircularProgressIndicator(),
                                                              SizedBox(height: 16.0),
                                                              Text('Loading'),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      Timer(const Duration(seconds: 10), () {
                                                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                          setState(() {
                                                            showNoCommentsText = true;
                                                          });
                                                        }
                                                      });
                                                      if (showNoCommentsText) {
                                                        return const Center(child: Text('No comments yet'));
                                                      }
                                                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                                                        return Center(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              const Icon(
                                                                Icons.drag_handle,
                                                                color: Colors.grey,
                                                                size: 48.0,
                                                              ),
                                                              const ListTile(
                                                                title: Text('No comments yet'),
                                                                subtitle: Text('Be the first to comment.'),
                                                              ),
                                                              TextButton.icon(
                                                                  onPressed: (){
                                                                    postId =
                                                                        int.parse(posts[index]['postId']);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                AddComments(
                                                                                    data: int.parse(
                                                                                        posts[index]['postId'])
                                                                                ))
                                                                    );
                                                                  },
                                                                  icon: Icon(Icons.chat_bubble_outline_outlined, color: secondaryTextColor,),
                                                                  label: Text("Add Comment", style: TextStyle(color: secondaryTextColor),)
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      List<dynamic> postComment = snapshot.data!;
                                                      return Column(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.drag_handle_outlined,
                                                            color: gradientStartColor,
                                                            size: 50.0,
                                                          ),
                                                          Expanded(
                                                              child: ListView.builder(
                                                                itemCount: postComment.length,
                                                                itemBuilder: (context, index) {
                                                                  return Container(
                                                                    padding: const EdgeInsets.all(50),
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
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                          ),
                                                          TextButton.icon(
                                                                  onPressed: (){
                                                                    postId =
                                                                        int.parse(posts[index]['postId']);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                AddComments(
                                                                                    data: int.parse(
                                                                                        posts[index]['postId'])
                                                                                ))
                                                                    );
                                                                  },
                                                                  icon: SizedBox(
                                                                    height: 20,
                                                                    child: Icon(Icons.chat_bubble_outline_outlined, color: secondaryTextColor,),
                                                                  ),
                                                                  label: Text("Add Comment", style: TextStyle(color: secondaryTextColor),)
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.chat_bubble_outline_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    backgroundColor: gradientEndColor,
                                                    title: Text("Delete Post",
                                                      style: TextStyle(
                                                        color: mainTextColor,
                                                      ),),
                                                    content: Text(
                                                      "Are you sure you want to delete your post?",
                                                      style: TextStyle(
                                                        color: mainTextColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("No",
                                                          style: TextStyle(
                                                            color: mainTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deletePost(
                                                              posts[index]['postId']);
                                                          Navigator.pop(
                                                              context);
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: gradientEndColor,
                  scrollable: true,
                  title: Text('Create Post',
                    style: TextStyle(
                      color: mainTextColor,
                    ),
                  ),
                  content: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: userController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Alias",
                                hintText: "Ex. The Ecologist",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: messageController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: "Write here",
                                hintText: "How was your day?",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 50.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 100,
                              color: gradientEndColor,
                              child: _image != null
                                  ? Image.file(_image!, fit: BoxFit.cover)
                                  : TextButton.icon(
                                      onPressed: getImage,
                                      icon: const Icon(Icons.photo),
                                      label: const Text('Please select an image'),
                              ),
                            ),
                            if (_image != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Image.file(_image!),
                                ),
                              ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                String messageText = messageController.text
                                    .trim();
                                String userText = userController.text.trim();
                                if (messageText.isNotEmpty &&
                                    userText.isNotEmpty) {
                                  setState(() async {
                                    createPost(
                                      posts.lastIndexOf('postId', 0),
                                      messageText,
                                      userText,
                                      formattedDate,
                                    );
                                  });
                                  messageController.clear();
                                  userController.clear();
                                } else {
                                  // Show an error message or toast to the user indicating that the fields cannot be empty
                                  _showMsg(
                                      "Message and user fields cannot be empty");
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                ),
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(primaryBtnColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              child: Icon(Icons.send,
                                color: mainTextColor,),
                            ),
                          ],
                        ),
                      ),
                    ),
                );
              },
            );
          },
          backgroundColor: primaryBtnColor,
          child: Icon(Icons.add,
            color: mainTextColor,),
        ),
      );
    }
  Future<void> fetchComments() async {
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

  Future<void> fetchPosts() async {
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

  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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

  Future<void> deletePost(String postId) async {
    setState(() {
      isLoading = true;
    });

    var url = 'https://640dc456b07afc3b0db58266.mockapi.io/posts/${int.parse(
        postId)}';
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

  Future<String> imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }
}

