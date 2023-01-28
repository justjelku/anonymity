import 'package:finalproject/csidebar/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class ImageShare extends StatefulWidget {
  const ImageShare({Key? key}) : super(key: key);

  @override
  State<ImageShare> createState() => _ImageShareState();
}

class _ImageShareState extends State<ImageShare> {

  List photos = <dynamic>[];


  @override
  void initState() {
    getPhotos();
    super.initState();
  }

  getPhotos() async {
    var url = "https://63c95a0e320a0c4c9546afb1.mockapi.io/api/images_share";
    var response = await http.get(Uri.parse(url));

    setState( () {
      photos = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Sharing"),
      ),
      body: ListView.builder(
          itemCount: photos.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text("${photos[index]['image']}"),
            );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageUpload())
          );
        },
        child: const Icon(Icons.image_outlined),
      ),
    );
  }
}
