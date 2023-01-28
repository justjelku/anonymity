import 'package:final_project_group4/screen/auth/login_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Anonymity',
    theme: ThemeData.dark(),
    home: const LoginPage(),
  )
  );
}

