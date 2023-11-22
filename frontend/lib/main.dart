import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/Dashboard/dashboard.dart';
import 'package:munited/Screens/Login/login_screen.dart';
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
      initialRoute: '/signup', // Set the initial route
      routes: {
        '/signup': (context) => SignupPage(Backend(), http.Client()),
        '/dash': (context) => Dashboard(),
        '/login': (context) => LoginPage(Backend(), http.Client()),
      },
    );
  }
}
