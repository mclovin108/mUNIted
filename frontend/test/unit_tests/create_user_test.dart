import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/Signup/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:munited/model/user.dart';
import 'package:flutter/material.dart';
import 'create_user_test.mocks.dart';

const _backend = "http://127.0.0.1:8080/";



@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();

  group('Create User', () {
    test('Throws Exception if HTTP call results in 404 error', () {
      final client = MockClient();

      // Mock object provides a predefined response for a specific request.
      when(client.post(
        Uri.parse('${_backend}register'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () async => await backend.createUser(
          client,
          "testUser",
          "test@example.com",
          "password",
          "password",
        ),
        throwsException,
      );
    });

    test('Creates a new user', () async {
      final client = MockClient();

      // Mock object provides a predefined response for a specific request.
      when(client.post(
        Uri.parse('${_backend}register'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
          '{"id": 1, "username": "testUser", "email": "test@example.com", "password": "password"}', 200));

      User user = await backend.createUser(
        client,
        "testUser",
        "test@example.com",
        "password",
        "password",
      );

      expect(user, isA<User>());
      expect(user.id, 1);
      expect(user.username, "testUser");
      expect(user.email, "test@example.com");
    });
  });
}
