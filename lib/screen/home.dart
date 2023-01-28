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


  List posts = <dynamic>[];
  List users = <dynamic>[];
  int postId = 0;
  int currentIndex = 0;
  List account = <dynamic>[];

  @override
  void initState() {
    getPosts();
    getUsers();
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

  getPosts() async {
    var url = 'https://63cb9d8cea85515415128b2b.mockapi.io/api/posts';
    var response = await http.get(Uri.parse(url));

    setState(() {
      posts = convert.jsonDecode(response.body) as List<dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        icon: Icon(
                          Icons.search,
                          color: Colors.white54,
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
          drawer: NavBar(data: widget.data),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Image.network(
                            "${posts[index]['avatar']}",
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          "${posts[index]['user']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          "${posts[index]['createdAt']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                            '${posts[index]['message']}'
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget> [
                          TextButton.icon(
                            onPressed: (){},
                            icon: const Icon(
                              Icons.thumb_up_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Like",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton.icon(
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
                                  Icons.comment_outlined,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Comment",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ],
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
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePost())
              );
            },
            child: const Icon(Icons.create_outlined),
          ),
        )
    );
  }
}
