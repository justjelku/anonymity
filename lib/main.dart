import 'package:anonymity/util/constant.dart';
import 'package:flutter/material.dart';
import 'screen/auth/login_page.dart';


void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Anonymity',
    theme: ThemeData(
      backgroundColor: gradientStartColor,
    ),
    home: const LoginPage(),
  )
  );
}

