import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Createpage will be implemented later',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dash');
              },
              child: Text('Zurück'),
            ),
          ],
        ),
      ),
    );
  }
}
