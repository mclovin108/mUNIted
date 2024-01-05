
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munited/Screens/Dashboard/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/CreateMeeting/create_meeting.dart';
import 'package:munited/Screens/Detail/detailpage.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:munited/model/meeting.dart';
import 'package:munited/model/user.dart';
import 'package:munited/model/user_provider.dart';
import 'package:provider/provider.dart';

import '../unit_tests/fetch_meeting_list_test.mocks.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}


const _backend = "http://127.0.0.1:8080/events";


class TestWrapperAppDashboard1 extends StatelessWidget {
  Backend backend = Backend();
  final client = MockClient();
  final mockObserver = MockNavigatorObserver();

  @override
  Widget build(BuildContext context) {
    final mockClient = MockClient();

    when(mockClient.get(Uri.parse(_backend))).thenAnswer((_) async =>
        http.Response(
            '[{"id": 1, "title": "Titel1", "icon": "balloon", "start": "2007-03-01T13:00:00", "description": "description1", "maxVisitors": 10, "costs": 15.0, "labels": ["U18", "U16"], "visitors": [{"id": 1, "username": "user", "email": "user@mail.com", "password": "password", "createdEvents": []}], "creator": { "id": 2, "username": "creator", "email": "creator@mail.com", "password": "password", "createdEvents": [1]}}]',
            200));

    UserProvider userProvider = UserProvider();
    userProvider.userId = 1;

 
  return ChangeNotifierProvider<UserProvider>.value(
    // create: (context) => UserProvider(),
    value: userProvider,
    child: MaterialApp(
      home: Scaffold(
        body: Dashboard(Backend(), mockClient),
      ),
      routes: {
          '/dash': (context) => Dashboard(Backend(), http.Client()),
          '/detail': (context) => Detail(backend, client, Meeting(id: 1, title: "title", icon: "icon", start: DateTime(2007, 03, 01, 13), description: "description", creator: User(id: 1, username: "creator", email: "creator@mail.com", password: "password"))),
          '/create': (context) => CreateMeetingPage(Backend(), http.Client()),
        },
      navigatorObservers: [mockObserver],
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
  Backend backend = Backend();

  testWidgets('Dashboard displays meetings correctly', (tester) async {
    await tester.pumpWidget(TestWrapperAppDashboard1());
    expect(find.byType(Dashboard), findsOneWidget);
    await tester.pumpAndSettle();
    debugDumpApp();
    expect(find.byType(Card), findsNWidgets(1));
    expect(find.byType(GestureDetector), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Dashboard displays no meetings message', (tester) async {
    await tester.pumpWidget(TestWrapperAppDashboard2());
    expect(find.byType(Dashboard), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Dashboard navigates to Create', (tester) async {
    await tester.pumpWidget(TestWrapperAppDashboard1());
    await tester.pumpAndSettle();
    debugDumpApp();

    await tester.tap(find.byType(FloatingActionButton));

    await tester.pumpAndSettle();

    expect(find.byType(Dashboard), findsNothing);
    expect(find.byType(CreateMeetingPage), findsOneWidget);

  });

  testWidgets('Dashboard navigates to Detail', (tester) async {
    await tester.pumpWidget(TestWrapperAppDashboard1());
    await tester.pumpAndSettle();
    debugDumpApp();

    expect(find.byType(Card), findsNWidgets(1));

    await tester.tap(find.byType(Card));

    await tester.pumpAndSettle();

    expect(find.byType(Dashboard), findsNothing);
    expect(find.byType(Detail), findsOneWidget);

  });

}

