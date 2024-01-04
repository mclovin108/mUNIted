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

    test('Checks if username is available', () async {
      final client = MockClient();

      // Mock object provides a predefined response for a specific request.
      when(client.get(
        Uri.parse('${_backend}users'),
      )).thenAnswer((_) async => http.Response(
          '[{"id": 1, "username": "existingUser", "email": "existing@example.com", "password": "password"}]', 200));

      bool isAvailable = await backend.isUsernameAvailable(client, 'testUser');
      expect(isAvailable, isTrue);
    });

    test('Checks if username is not available', () async {
      final client = MockClient();

      // Mock object provides a predefined response for a specific request.
      when(client.get(
        Uri.parse('${_backend}users'),
      )).thenAnswer((_) async => http.Response(
          '[{"id": 1, "username": "testUser", "email": "test@example.com", "password": "password"}]', 200));

      bool isAvailable = await backend.isUsernameAvailable(client, 'testUser');
      expect(isAvailable, isFalse);
    });

    test('isUsernameAvailable throws an exception on HTTP error', () async {
      final client = MockClient();

      when(client.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));

      // Hier kannst du die Exception-Logik anpassen, basierend auf deiner tatsächlichen Implementierung
      expect(() async => await backend.isUsernameAvailable(client, 'username1'), throwsException);
    });

    test('Checks if email is available', () async {
      final client = MockClient();

      // Mock object provides a predefined response for a specific request.
      when(client.get(
        Uri.parse('${_backend}users'),
      )).thenAnswer((_) async => http.Response(
          '[{"id": 1, "username": "existingUser", "email": "existing@example.com", "password": "password"}]', 200));

      bool isAvailable = await backend.isEmailAvailable(client, 'test@example.com');
      expect(isAvailable, isTrue);
    });

    test('Checks if email is not available', () async {
      final client = MockClient();

      // Mock object provides a predefined response for a specific request.
      when(client.get(
        Uri.parse('${_backend}users'),
      )).thenAnswer((_) async => http.Response(
          '[{"id": 1, "username": "existingUser", "email": "existing@example.com", "password": "password"}]', 200));

      bool isAvailable = await backend.isEmailAvailable(client, 'existing@example.com');
      expect(isAvailable, isFalse);
    });

    test('isEmailAvailable throws an exception on HTTP error', () async {
      final client = MockClient();

      when(client.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await backend.isEmailAvailable(client, 'testMail@user1.de'), throwsException);
    });



    test('returns authenticated user data on successful authentication', () async {
      final client = MockClient();
      // Arrange
      final email = 'test@example.com';
      final password = 'password';

      when(client.post(
          Uri.parse('${_backend}login'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
              http.Response('{"id": 1, "username": "testUser", "email": "test@example.com", "password": "password"}', 200));

      // Act
      final result = await backend.userIsAuthenticated(client, email, password);

      // Assert
      expect(result['authenticated'], true);
      expect(result['user'], isNotNull);
      expect(result['userId'], 1);
    });

    test('returns unauthenticated user data on failed authentication', () async {
      final client = MockClient();

      final email = 'test@example.com';
      final password = 'wrong_password';

      when(client.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Authentication failed', 401));

      // Act
      final result = await backend.userIsAuthenticated(client, email, password);

      // Assert
      expect(result['authenticated'], false);
      expect(result['user'], isNull);
      expect(result['userId'], isNull);
    });

    test('handles exceptions and returns unauthenticated user data', () async {
      final client = MockClient();
      
      final email = 'test@example.com';
      final password = 'password';

      when(client.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await backend.userIsAuthenticated(client, email, password);

      // Assert
      expect(result['authenticated'], false);
      expect(result['user'], isNull);
      expect(result['userId'], isNull);
    });


    test('returns user on successful retrieval', () async {
      final client = MockClient();
      // Arrange
      final userId = 1;

      when(client.get(
        Uri.parse('${_backend}users/$userId'),
      )).thenAnswer((_) async => http.Response(
          '{"id": 1, "username": "existingUser", "email": "existing@example.com", "password": "password"}', 200));

      // Act
      final result = await backend.getUserById(client, userId);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, userId);
      expect(result.username, 'existingUser');
    });

    test('returns null when user is not found (404 status code)', () async {
      final client = MockClient();
      // Arrange
      final userId = 1;

      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final result = await backend.getUserById(client, userId);

      // Assert
      expect(result, isNull);
    });

    test('throws exception on other error status codes', () async {
      final client = MockClient();
      // Arrange
      final userId = 1;

      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));

      // Act and Assert
      expect(() async => await backend.getUserById(client, userId),
          throwsException);
    });

    test('throws exception on network error', () async {
      final client = MockClient();
      // Arrange
      final userId = 1;

      when(client.get(any, headers: anyNamed('headers')))
          .thenThrow(Exception('Network error'));

      // Act and Assert
      expect(() async => await backend.getUserById(client, userId),
          throwsException);
    });

  });
}
