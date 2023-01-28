import 'package:flutter/material.dart';
import 'screen/auth/login_page.dart';


void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Anonymity',
    theme: ThemeData.dark(),
    home: const LoginPage(),
  )
  );
}

