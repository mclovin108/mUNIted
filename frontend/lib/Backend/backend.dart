import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:munited/model/meeting.dart';
import 'package:munited/model/user.dart';

class Backend {
  // use IP 10.0.2.2 to access localhost from windows client
  static const _backend = "http://127.0.0.1:8080/";



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
        Uri.parse('${_backend}users/$userId'),
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

  Future<Map<String, dynamic>> userIsAuthenticated(
      http.Client client, String email, String password) async {
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

        // Create a User object from the user data
        User user = User.fromJson(responseBody);

        // Get the user ID from the user object
        int? userId = user.id;

        return {'authenticated': true, 'user': user, 'userId': userId};
      }

      // Authentication failed
      return {'authenticated': false, 'user': null, 'userId': null};
    } catch (e) {
      // Handle exceptions, e.g., network errors
      print('Error checking user authentication: $e');
      return {'authenticated': false, 'user': null, 'userId': null};
    }
  }

  // Event backend 

  Future<Meeting> createEvent(
      http.Client client,
      String title,
      String icon,
      DateTime start,
      String description,
      int? maxVisitors,
      double? costs,
      List<String>? labels,
      User creator,
      List<User>? visitors) async {
    try {
      Map<String, dynamic> data = {
        'title': title,
        'icon': icon,
        'start': start.toUtc().toIso8601String(),
        'description': description,
        'maxVisitors': maxVisitors,
        'costs': costs,
        'labels': labels,
        'creatorId': creator.id,
        'visitors': visitors?.map((user) => user.toJson()).toList(),
      };

      var response = await client.post(Uri.parse('${_backend}events'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(data));

      if (response.statusCode == 200) {
        return Meeting.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        print('Failed to create meeting. Status code: ${response.statusCode}');
        throw Exception('Failed to create meeting');
      }
    } catch (e) {
      print('Error creating meeting: $e');
      throw Exception('Error creating meeting');
    }
  }

  Future<Meeting> updateEvent(
      http.Client client,
      int id,
      String title,
      String icon,
      DateTime start,
      String description,
      int? maxVisitors,
      double? costs,
      List<String>? labels,
      User creator,
      List<User>? visitors) async {

    try {
      Map<String, dynamic> data = {
        'title': title,
        'icon': icon,
        'start': start.toUtc().toIso8601String(),
        'description': description,
        'maxVisitors': maxVisitors,
        'costs': costs,
        'labels': labels,
        'creatorId': creator.id,
        'visitors': visitors?.map((user) => user.toJson()).toList(),
      };

      // access REST interface with post request
      var response = await client.put(Uri.parse('${_backend}events/$id'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(data)
      );

      // check response from backend
      if (response.statusCode == 200) {
        return Meeting.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        print('Failed to update meeting. Status code: ${response.statusCode}');
        throw Exception('Failed to update meeting');
      }
      } catch (e) {
      print('Error updating event: $e');
      throw Exception('Error updating event');
    }
  }

  Future<void> deleteEvent(http.Client client, int id) async {

      final response = await client.delete(Uri.parse('${_backend}events/$id'));

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          throw Exception('Event was not found');
        } else {
          throw Exception('Failed to delete event with id $id. Status code: ${response.statusCode}');
        }
      }
      print('Event deleted');
  }

  Future<List<Meeting>> fetchEvents(http.Client client) async {
  try {
    final response = await client.get(Uri.parse('${_backend}events'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      // Ensure that the JSON response is a list
      if (jsonResponse is List) {
        // Filter out items that are not of type Map<String, dynamic> (Meeting objects)
        final List<Meeting> fetchedEvents = jsonResponse
            .whereType<Map<String, dynamic>>() // Filter out non-Meeting items
            .map((e) => Meeting.fromJson(e))
            .toList();

        return fetchedEvents;
      } else {
        throw Exception('Invalid JSON response: Expected a list but received ${jsonResponse.runtimeType}');
      }
    } else {
      throw Exception('Failed to load events. Status code: ${response.statusCode}');
    }
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Failed to load events');
    }
  }

  Future<void> signUpToEvent(http.Client client, int eventId, int userId) async {
    final response = await client.post(
      Uri.parse('${_backend}events/$eventId/register/$userId'),
    );

    if (response.statusCode == 200) {
      print('Signed up successfully');
    } else {
      if (response.statusCode == 404) {
        throw Exception('Event was not found');
      } else {
        throw Exception('Failed to sign up. Status code: ${response.statusCode}');
      }
    }
  }

  Future<void> signOffFromEvent(http.Client client, int eventId, int userId) async {
    final response = await client.post(
      Uri.parse('${_backend}events/$eventId/signoff/$userId'),
    );

    if (response.statusCode == 200) {
      print('Signed off successfully');
    } else {
      if (response.statusCode == 404) {
        throw Exception('Event was not found');
      } else {
        throw Exception('Failed to sign off. Status code: ${response.statusCode}');
      }
    }
  }

}
