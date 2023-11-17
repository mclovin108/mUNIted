import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'Screens/Signup/signup_screen.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mUNIted App',
      home: SignupPage(Backend(), http.Client()),
    );
  }
}
