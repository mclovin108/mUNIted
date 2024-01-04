
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munited/Screens/Dashboard/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/CreateMeeting/create_meeting.dart';
import 'package:munited/Screens/Detail/detail_screen.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../unit_tests/fetch_meeting_list_test.mocks.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}

const _backend = "http://127.0.0.1:8080/events";


class TestWrapperAppDashboard1 extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final mockClient = MockClient();

    when(mockClient.get(Uri.parse(_backend))).thenAnswer((_) async =>
        http.Response(
            '[{"id": 1, "title": "Titel1", "icon": "balloon", "start": "2007-03-01T13:00:00", "description": "description1", "maxVisitors": 10, "costs": 15.0, "labels": ["U18", "U16"], "visitors": [{"id": 1, "username": "user", "email": "user@mail.com", "password": "password", "createdEvents": []}], "creator": { "id": 2, "username": "creator", "email": "creator@mail.com", "password": "password", "createdEvents": [1]}}]',
            200));

    return MaterialApp(
      home: Scaffold(
        body: Dashboard(Backend(), mockClient),
      ),
    );
  }
}

class TestWrapperAppDashboard2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mockClient = MockClient();

    when(mockClient.get(Uri.parse(_backend))).thenAnswer((_) async =>
        http.Response('[]', 200));

    return MaterialApp(
      home: Scaffold(
        body: Dashboard(Backend(), mockClient),
      ),
    );
  }
}

void main() {
  testWidgets('Dashboard displays meetings correctly', (tester) async {
    await tester.pumpWidget(TestWrapperAppDashboard1());
    expect(find.byType(Dashboard), findsOneWidget);
    await tester.pumpAndSettle();
    debugDumpApp();
    expect(find.byType(Card), findsNWidgets(1));
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Dashboard displays no meetings message', (tester) async {
    await tester.pumpWidget(TestWrapperAppDashboard2());
    expect(find.byType(Dashboard), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

}