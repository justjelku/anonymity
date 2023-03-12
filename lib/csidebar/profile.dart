import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        // color: Color(0xff3a506b),
                        color: Color(0xff6fffe9),
                        spreadRadius: 2
                    )
                  ],
                ),
                child: const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("assets/jeremiah.jpg"),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text("",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text('Name',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(':  Jeremiah Larry King Ungsod',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xff3a506b),
          ),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  flex: 1,
                  child: Text("",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Relationship',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Text(':  Me and Myself',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xff3a506b),
          ),
          ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text("",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text('Occupation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(':  IT Student',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xff3a506b),
          ),
          ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text("",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text('Birthday',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(':  January 19, 2002',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xff3a506b),
          ),
          ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text("",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text('Age',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(':  21',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xff3a506b),
          ),
        ],
      ),
    );
  }
}
