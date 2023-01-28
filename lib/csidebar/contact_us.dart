import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  List contacts = [
    {'name': "Jeremiah Larry King Ungsod", 'email': 'j.ungsod019@gmail.com'},
    {'name': "Arjay Audiencia Charcos", 'email': 'rain.shigatsu@gmail.com'},
    {'name': "Janmark Sabanal", 'email': 'trishaganados01@gmail.com'},
    {'name': "Johnlearn Mosqueda",'email': 'mosquedajohnlearn@gmail.com'},
    {'name':  "Jonard Salvanera Estamo",'email': 'joboy.estamo@gmail.com'},
    {'name': "Julianne G. Ong",'email': 'ongjulianne02@gmail.com'},
    {'name': "Ronald Naguita",'email': 'ronaldnaguita@gmail.com'},
    {'name': "Angelica Lazarito",'email': 'azerlazarito@gmail.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text('${contacts[index]['name']}'),
              subtitle: Text('${contacts[index]['email']}'),
            ),
          );
        },
      ),
    );
  }
}
