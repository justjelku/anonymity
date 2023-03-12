import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Color primaryBGColor = const Color(0xFF000000);
Color primaryBtnColor = const Color(0xFF07AF3F);
Color mainTextColor = const Color(0xFFFFFFFF);
Color gradientEndColor = const Color(0xFFEAA626);

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  File? image;
  File? file;

  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  uploadImage(File image) async {
    var request = http.MultipartRequest("POST", Uri.parse("https://640d7547b07afc3b0dadbf4d.mockapi.io/users/1/image_uploads"));
    request.fields["image"] = _image.toString();
    request.files.add(
        http.MultipartFile.fromBytes(
            "picture",
            File(_image!.path).readAsBytesSync(),filename: _image!.path)
    );
    var res = await request.send();
    throw res;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
        appBar: AppBar(
          backgroundColor: primaryBGColor,
          title: const Text('Image Upload'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: _openImagePicker,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(primaryBtnColor),
                      ),
                      child: Text('Select An Image',
                        style: TextStyle(
                          color: mainTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 300,
                    color: primaryBGColor,
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Text('Please select an image',
                      style: TextStyle(
                        color: mainTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ElevatedButton(
                      onPressed: (){
                        uploadImage(_image!);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(primaryBtnColor),
                      ),
                      child: Text("Upload",
                        style: TextStyle(
                          color: mainTextColor,
                        ),
                      )
                  )
              ]
            ),
          ),
        )
    );
  }

  upload(File imageFile) async {
    var stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://640d7547b07afc3b0dadbf4d.mockapi.io/users/1/image_uploads");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      }
    );
  }
}
