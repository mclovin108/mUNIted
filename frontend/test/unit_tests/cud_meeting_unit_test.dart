import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:munited/Backend/backend.dart';
import 'package:munited/model/meeting.dart';
import 'package:http/http.dart' as http;
import 'package:munited/model/user.dart';
import 'cud_meeting_unit_test.mocks.dart';
import 'package:munited/Screens/CreateMeeting/create_meeting.dart';

const _backend = "http://127.0.0.1:8080/";

// Generate Mock objects for http.Client.
@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();

  group('Create Meeting Tests', () {
    test('Test: Wirft Exception, falls Http Aufruf mit Fehler 404 endet.', () {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .post(Uri.parse('${_backend}events'),
              body: anyNamed('body'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(backend.createEvent(client, "Titel1", "balloon", DateTime(2007, 03, 01, 13), "description", 10, 15.0, ["U18", "U16"], User(id: 1, username: "creator@mail.com", email: "email", password: "password"), []), throwsException);
    });
    
    testWidgets('Test: Creating a new meeting', (WidgetTester tester) async {
      final client = MockClient();

      when(client.post(
        Uri.parse('${_backend}events'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response('{"id": 1, "title": "Titel1", "icon": "balloon", "start": "2007-03-01T13:00:00", "description": "description1", "maxVisitors": 10, "costs": 15.0, "labels": ["U18", "U16"], "visitors": [], "creator": { "id": 2, "username": "creator", "email": "creator@mail.com", "password": "password", "createdEvents": [1]}}', 200));

      Meeting meeting = await backend.createEvent(client, "Titel1", "balloon", DateTime(2007, 03, 01, 13), "description", 10, 15.0, ["U18", "U16"], User(id: 1, username: "creator@mail.com", email: "email", password: "password"), []);
      expect(meeting, isA<Meeting>());
      expect(1, meeting.id);
      expect("Titel1", meeting.title);
      expect("balloon", meeting.icon);
      expect("description1", meeting.description);
      expect(DateTime(2007, 03, 01, 13), meeting.start);
      expect(10, meeting.maxVisitors);
      expect(15.0, meeting.costs);
      expect(["U18", "U16"], meeting.labels);

      // Verify that the createMeeting function is called.
      verify(client.post(
        Uri.parse('${_backend}events'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).called(1);
    });
  });


  group('Update Meeting Tests', () {

    int eventId = 1;
    test('Test: Wirft Exception, falls Http Aufruf mit Fehler 404 endet.', () {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
             .patch(Uri.parse('${_backend}events/$eventId'),
              body: anyNamed('body'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(backend.updateEvent(client, eventId, "Titel1", "balloon", DateTime(2007, 03, 01, 13), "description", 10, 15.0, ["U18", "U16"], User(id: 1, username: "creator@mail.com", email: "email", password: "password"), []), throwsException);
    });
    
    testWidgets('Test: Creating a new meeting', (WidgetTester tester) async {
      final client = MockClient();

      when(client.patch(
        Uri.parse('${_backend}events/$eventId'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response('{"id": 1, "title": "Titel1", "icon": "balloon", "start": "2007-03-01T13:00:00", "description": "description1", "maxVisitors": 10, "costs": 15.0, "labels": ["U18", "U16"], "visitors": [{ "id": 1, "username": "username", "email": "user@mail.com", "password": "password", "createdEvents": []}], "creator": { "id": 2, "username": "creator", "email": "creator@mail.com", "password": "password", "createdEvents": [1]}}', 200));

      Meeting meeting= await backend.updateEvent(client, eventId, "Titel1", "balloon", DateTime(2007, 03, 01, 13), "description", 10, 15.0, ["U18", "U16"], User(id: 1, username: "creator@mail.com", email: "email", password: "password"), [User(id: 1, username: "username", email: "user@mail.com", password: "password")]);

      expect(meeting, isA<Meeting>());
      expect(1, meeting.id);
      expect("Titel1", meeting.title);
      expect("balloon", meeting.icon);
      expect("description1", meeting.description);
      expect(DateTime(2007, 03, 01, 13), meeting.start);
      expect(10, meeting.maxVisitors);
      expect(15.0, meeting.costs);
      expect(["U18", "U16"], meeting.labels);
      expect(meeting.creator, isA<User>());
      expect(meeting.visitors!.length, 1);
      expect(2, meeting.creator.id);
      expect("creator", meeting.creator.username);
      expect("creator@mail.com", meeting.creator.email);
      expect("password", meeting.creator.password);
      expect(1, meeting.visitors![0].id);
      expect("username", meeting.visitors![0].username);
      expect("user@mail.com", meeting.visitors![0].email);
      expect("password", meeting.visitors![0].password);


      // Verify that the createMeeting function is called.
      verify(client.patch(
        Uri.parse('${_backend}events/$eventId'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).called(1);
    });
  });

  group('Create Meeting Tests', () {
    int eventId = 1;
    test('Successful event deletion', () async {
      final client = MockClient();
      
      when(client.delete(Uri.parse('${_backend}events/$eventId')))
          .thenAnswer((_) async => http.Response('', 200));

      expect(() async => await backend.deleteEvent(client, eventId), returnsNormally);
    });

    test('Event not found', () async {
      final client = MockClient();
      when(client.delete(Uri.parse('${_backend}events/$eventId')))
          .thenAnswer((_) async => http.Response('', 404));

      expect(() => backend.deleteEvent(client, eventId), throwsException);
    });

    test('Failed event deletion with status code', () async {
      final client = MockClient();
      when(client.delete(Uri.parse('${_backend}events/$eventId')))
          .thenAnswer((_) async => http.Response('', 500)); // Beispielhaft 500 als Statuscode

      expect(() => backend.deleteEvent(client, eventId), throwsException);
      // Erwarte, dass die Exception-Meldung den erwarteten Statuscode enthält
    });

    test('Failed event deletion due to network error', () async {
      final client = MockClient();
      when(client.delete(Uri.parse('${_backend}events/$eventId')))
          .thenThrow(Exception('Network error'));

      expect(() => backend.deleteEvent(client, eventId), throwsException);
      // Erwarte, dass die Exception-Meldung den erwarteten Netzwerkfehler enthält
    });


  });
}
