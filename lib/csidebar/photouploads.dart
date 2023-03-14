import 'dart:io';
import 'package:finalproject/constant.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'dart:async';


class ImageShare extends StatefulWidget {
  const ImageShare({Key? key}) : super(key: key);

  @override
  State<ImageShare> createState() => _ImageShareState();
}

class _ImageShareState extends State<ImageShare> {

  List photos = <dynamic>[];
  bool isLoading = true;


  @override
  void initState() {
    getPhotos();
    super.initState();
  }

  Future<void> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://640d7547b07afc3b0dadbf4d.mockapi.io/users/1/image_uploads"));

    var stream =
    http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      // parse responseString and insert the image data into your database
      // you can use the http package or another package like dio to handle the API request and response
    } else {
      throw Exception('Failed to upload image');
    }
  }


  Future<List<dynamic>> getPhotos() async {
    var url = "https://640d7547b07afc3b0dadbf4d.mockapi.io/users/1/image_uploads";
    var response = await http.get(Uri.parse(url));

    return convert.jsonDecode(response.body) as List<dynamic>;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      appBar: AppBar(
        backgroundColor: primaryBGColor,
        title: const Text("Photo Uploads"),
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: FutureBuilder<List<dynamic>>(
            future: getPhotos(), // replace fetchPhotos with your own future function that returns the data
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                List<dynamic> photos = snapshot.data!; // access the data property of the snapshot
                return ListView.builder(
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            child: Image.network(
                              "${photos[index]['image']}",
                            ),
                          )
                      );
                    }
                );
              }
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            await uploadImage(File(pickedFile.path));
            setState(() {
              getPhotos(); // refresh the photo list after the upload is complete
            });
          }
        },
        backgroundColor: primaryBtnColor,
        child: Icon(
          Icons.image_outlined,
          color: mainTextColor,
        ),
      ),
    );
  }
  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    var url = 'https://640d7547b07afc3b0dadbf4d.mockapi.io/users/1/image_uploads';
    var headers = {'Cache-Control': 'no-cache'};
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as Map;
      final result = json['image_uploads'] as List;
      setState(() {
        photos = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
