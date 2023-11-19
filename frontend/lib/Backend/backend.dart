import 'dart:convert';
import '../model/user.dart';
import 'package:http/http.dart' as http;


class Backend {
  // use IP 10.0.2.2 to access localhost from windows client 
  static const _backend = "http://127.0.0.1:8080/";
  
  // use IP 10.0.2.2 to access localhost from emulator! 
  // static const _backend = "http://10.0.2.2:8080/";

  // get user list from backend
  Future<List<User>> fetchUserList(http.Client client) async {

     // access REST interface with get request
    final response = await client.get(Uri.parse('${_backend}users'));

    // check response from backend
    if (response.statusCode == 200) {
      return List<User>.from(json.decode(utf8.decode(response.bodyBytes)).map((x) => User.fromJson(x)));
    } else {
      throw Exception('Failed to load User List');
    }
  }

  Future<User> createUser(http.Client client, String username, String email, String password, String confirmPassword) async {

    Map data = {
      'username': username,
      'email': email,
      'password': password,
    };

    // access REST interface with post request
    var response = await client.post(Uri.parse('${_backend}users'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data)
    );

    // check response from backend
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to create user');
    }

  }

  Future<bool> userIsAuthenticated(http.Client client, String enteredUsername, String enteredPassword) async {
  try {
    // Access REST interface with a GET request to check if the username exists
    var response = await client.get(Uri.parse('${_backend}users/$enteredUsername'));

    // Check if the user with the specified username exists
    if (response.statusCode == 200) {
      // If the user exists, check if the entered password matches the stored one
      var userData = json.decode(utf8.decode(response.bodyBytes));
      String storedPassword = userData['password'];

      return enteredPassword == storedPassword;
    } else if (response.statusCode == 404) {
      // User with the specified username does not exist
      return false;
    } else {
      // Failed to check user authentication
      return false;
    }
  } catch (e) {
    // Handle exceptions, e.g., network errors
    print('Error checking user authentication: $e');
    return false;
  }
}
  
}