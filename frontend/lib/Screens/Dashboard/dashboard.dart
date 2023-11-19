import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Necessary for mocking (unit and widget tests)
  late Backend _backend; // Library with functions to access the backend
  late http.Client _client; // REST client proxy

  @override
  void initState() {
    super.initState();
    _backend = Backend(); // Initialize your Backend instance here
    _client = http.Client(); // Initialize your http.Client instance here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Page content will be implemented later',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
