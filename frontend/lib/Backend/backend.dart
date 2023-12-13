import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:munited/model/user.dart';
import 'package:munited/model/meeting.dart';

class Backend {
  // use IP 10.0.2.2 to access localhost from windows client
  static const _backend = "http://127.0.0.1:8080/";

  // use IP 10.0.2.2 to access localhost from emulator!
  // static const _backend = "http://10.0.2.2:8080/";

  // get meeting list from backend
  Future<List<Meeting>> fetchMeetingList(http.Client client) async {

     // access REST interface with get request
    final response = await client.get(Uri.parse('${_backend}meetings'));

    // check response from backend
    if (response.statusCode == 200) {
      return List<Meeting>.from(json.decode(utf8.decode(response.bodyBytes)).map((x) => Meeting.fromJson(x)));
    } else {
      throw Exception('Failed to load MeetingList');
    }
  }

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

  Future<User?> getUserById(http.Client client, int userId) async {
    try {
      var response = await client.get(
        Uri.parse('$_backend/users/$userId'),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 404) {
        // Benutzer mit der angegebenen userId nicht gefunden
        return null;
      } else {
        // Fehler beim Abrufen des Benutzers
        print('Failed to get user. Status code: ${response.statusCode}');
        throw Exception('Failed to get user');
      }
    } catch (e) {
      // Fehler beim Netzwerkzugriff oder in der Verarbeitung
      print('Error getting user: $e');
      throw Exception('Error getting user');
    }
  }

  Future<bool> isUsernameAvailable(http.Client client, String username) async {
    final response = await client.get(Uri.parse('${_backend}users'));

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
    final response = await client.get(Uri.parse('${_backend}users'));

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

  Future<Map<String, dynamic>> userIsAuthenticated(http.Client client, String email, String password) async {
    try {
      Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      // Access REST interface with a POST request to check user authentication
      var response = await client.post(
        Uri.parse('${_backend}login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Decode the response body
        Map<String, dynamic> responseBody =
            json.decode(utf8.decode(response.bodyBytes));

        // Check if authentication is successful
        bool isAuthenticated = responseBody['authenticated'] ?? false;

        // If authenticated, return user information including user ID
        if (isAuthenticated) {
          // Assuming your API returns user data in the 'user' field
          Map<String, dynamic> userData = responseBody['user'] ?? {};

          // Create a User object from the user data
          User user = User.fromJson(userData);

          // Get the user ID from the user object
          int? userId = user.id;

          return {'authenticated': isAuthenticated, 'user': user, 'userId': userId};
        }
      }

      // Authentication failed
      return {'authenticated': false, 'user': null, 'userId': null};
    } catch (e) {
      // Handle exceptions, e.g., network errors
      print('Error checking user authentication: $e');
      return {'authenticated': false, 'user': null, 'userId': null};
    }
  }

  Future<void> createMeeting(http.Client client, String title, String icon, DateTime start, String description,
  int? maxVisitors, double? costs, List<String>? labels, User creator, List<User>? visitors) async {
    try {

    Map<String, dynamic> data = {
      'title': title,
      'icon': icon,
      'start': start.toUtc().toIso8601String(),
      'description': description,
      'maxVisitors': maxVisitors,
      'costs': costs,
      'labels': labels,
      'creator': creator.toJson(),
      'visitors': visitors?.map((user) => user.toJson()).toList(),
    };

      var response = await client.post(
        Uri.parse('${_backend}meetings'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data)
      );

      if (response.statusCode == 200) {
        print('Meeting created successfully');
      } else {
        print('Failed to create meeting. Status code: ${response.statusCode}');
        throw Exception('Failed to create meeting');
      }
    } catch (e) {
      print('Error creating meeting: $e');
      throw Exception('Error creating meeting');
    }
  }

}
