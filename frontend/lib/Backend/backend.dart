import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/user.dart';

class Backend {
  // use IP 10.0.2.2 to access localhost from windows client
  static const _backend = "http://127.0.0.1:8080/";

  // use IP 10.0.2.2 to access localhost from emulator!
  // static const _backend = "http://10.0.2.2:8080/";

  Future<User> createUser(http.Client client, String username, String email,
      String password, String confirmPassword) async {
    Map data = {
      'username': username,
      'email': email,
      'password': password,
    };

    // access REST interface with post request
    var response = await client.post(Uri.parse('${_backend}register'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data));

    // check response from backend
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<bool> isUsernameAvailable(http.Client client, String username) async {
    final response = await client.get(Uri.parse('${_backend}items'));

    if (response.statusCode == 200) {
      // Konvertieren Sie die Antwort in eine Liste von Benutzern
      List<User> userList = List<User>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((x) => User.fromJson(x)));

      // Überprüfen, ob der angegebene Benutzername bereits vergeben ist
      bool isAvailable = userList.every((user) => user.username != username);

      return isAvailable;
    } else {
      // Fehler beim Laden der Benutzerliste
      throw Exception('Failed to load user list');
    }
  }

  Future<bool> isEmailAvailable(http.Client client, String email) async {
    final response = await client.get(Uri.parse('${_backend}items'));

    if (response.statusCode == 200) {
      // Konvertieren Sie die Antwort in eine Liste von Benutzern
      List<User> userList = List<User>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((x) => User.fromJson(x)));

      // Überprüfen, ob der angegebene Benutzername bereits vergeben ist
      bool isAvailable = userList.every((user) => user.email != email);

      return isAvailable;
    } else {
      // Fehler beim Laden der Benutzerliste
      throw Exception('Failed to load user list');
    }
  }

  Future<bool> userIsAuthenticated(http.Client client, String email, String password) async {
    try {

      Map data = {
      'email': email,
      'password': password,
    };
      // Access REST interface with a GET request to check if the username exists
      var response = await client.post(Uri.parse('${_backend}login'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(data));

      return json.decode(utf8.decode(response.bodyBytes));

    } catch (e) {
      // Handle exceptions, e.g., network errors
      print('Error checking user authentication: $e');
      return false;
    }
  }
}
