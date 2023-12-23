import 'package:munited/Backend/backend.dart';
import 'package:munited/model/meeting.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'fetch_meeting_list_test.mocks.dart';

const _backend = "http://127.0.0.1:8080/events";

// Generiere Mock-Objekt für http.Client.
@GenerateMocks([http.Client])
void main() {
  Backend backend = Backend();
  group('Fetch Item List', () {
    test('Test: Wirft Exception, falls Http Aufruf mit Fehler 404 endet.', () {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(backend.fetchEvents(client), throwsException);
    });
    test('Test: Liefert eine nicht leere Liste von Meetings vom Server.', () async {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('[{"id": 1, "title": "Titel1", "icon": "balloon", "start": "2007-03-01T13:00:00", "description": "description1", "maxVisitors": 10, "costs": 15.0, "labels": ["U18", "U16"], "visitors": [{"id": 1, "username": "user", "email": "user@mail.com", "password": "password", "createdEvents": []}], "creator": { "id": 2, "username": "creator", "email": "creator@mail.com", "password": "password", "createdEvents": [1]}}]', 200));

      List<Meeting> result = await backend.fetchEvents(client);
      expect(result, isA<List<Meeting>>());
      expect(result.length, 1);
      expect(result[0].id, 1);
      expect(result[0].title, "Titel1");
      expect(result[0].description, "description1");
      expect(result[0].icon, "balloon");
      expect(result[0].start, DateTime(2007, 03, 01, 13));
      expect(result[0].maxVisitors, 10);
      expect(result[0].costs, 15.0);
      expect(result[0].labels, ["U18", "U16"]);
      expect(result[0].creator.id, 2);
      expect(result[0].creator.username, "creator");
      expect(result[0].creator.email, "creator@mail.com");
      expect(result[0].creator.password, "password");
      expect(result[0].visitors![0].id, 1);
      expect(result[0].visitors![0].username, "user");
      expect(result[0].visitors![0].email, "user@mail.com");
      expect(result[0].visitors![0].password, "password");
    });
    test('Test: Liefert eine leere Liste von Meetings vom Server.', () async {
      final client = MockClient();

      // Mock-Objekt liefert bei entsprechender Anfrage vordefinierte Antwort.
      when(client
              .get(Uri.parse(_backend)))
          .thenAnswer((_) async =>
              http.Response('[]', 200));

      List<Meeting> result = await backend.fetchEvents(client);
      expect(result, isA<List<Meeting>>());
      expect(result.length, 0);
    });
  });
}

