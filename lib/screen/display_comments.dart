import 'package:flutter/material.dart';

class DisplayComments extends StatefulWidget {

  final List data;
  const DisplayComments({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<DisplayComments> createState() => _DisplayCommentsState();
}

class _DisplayCommentsState extends State<DisplayComments> {

  List postComment = <dynamic>[];
  int currentIndex = 0;

  @override
  void initState() {
    displayComments();
    postComment;
    super.initState();
  }

  displayComments() async {
    postComment = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: ListView.builder(
          itemCount: postComment.length,
          itemBuilder: (context, index){
            return Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    child: Image.network(
                      "${postComment[index]['avatar']}",
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    "${postComment[index]['alias']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "${postComment[index]['createdAt']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                      '${postComment[index]['comment']}'
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5,
                ),
              ],
            );
          }
       ),
    );
  }
}
