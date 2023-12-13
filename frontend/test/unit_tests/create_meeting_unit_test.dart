import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:munited/Backend/backend.dart';
import 'package:munited/model/meeting.dart';
import 'package:http/http.dart' as http;
//import 'package:test/test.dart';
import 'create_meeting_unit_test.mocks.dart';
import 'package:munited/Screens/CreateMeeting/create_meeting.dart';

const _backend = "http://127.0.0.1:8080/";

// Generate Mock objects for http.Client.
@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();

  group('Create Meeting Tests', () {
    testWidgets('Test: Creating a new meeting', (WidgetTester tester) async {
      final client = MockClient();

      // Set up a mock response for the post request to 'http://127.0.0.1:8080/meetings'
      when(client.post(
        Uri.parse('${_backend}meetings'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response('{"id": 1, "title": "Meeting 1", "icon": "😃", "description": "Description 1", "start": "2007-03-01T13:00:00"}', 200));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: CreateMeetingPage(backend, client),
        ),
      );

      // Enter data into the form fields.
      await tester.enterText(find.byKey(Key("title")), "Meeting 1");
      await tester.enterText(find.byKey(Key("icon")), "😃");
      await tester.enterText(find.byKey(Key("description")), "Description 1");
      await tester.enterText(find.byKey(Key("start")), "2007-03-01T13:00:00");

      // Tap the "Meeting erstellen" button.
      await tester.tap(find.byType(ElevatedButton));

      // Wait for the createMeeting function to finish.
      await tester.pump();

      // Verify that the createMeeting function is called.
      verify(client.post(
        Uri.parse('${_backend}meetings'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).called(1);
    });
  });
}
