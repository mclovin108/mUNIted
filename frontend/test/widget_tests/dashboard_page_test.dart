import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munited/Screens/Dashboard/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/CreateMeeting/create_meeting.dart';
import 'package:munited/Screens/Detail/detailpage.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dashboard_page_test.mocks.dart';


class TestWrapperAppDashboard1 extends StatelessWidget {
  static const _backend = "http://127.0.0.1:8080/meetings";

  @override
  Widget build(BuildContext context) {
    final mockClient = MockClient();

    when(mockClient.get(Uri.parse(_backend))).thenAnswer((_) async =>
        http.Response(
            '[{"title": "Meeting 1", "icon": "🚀", "start": "2023-01-01T10:00:00Z", "description": "Description 1", "maxVisitors": 10}, {"title": "Meeting 2", "icon": "🎉", "start": "2023-01-02T15:30:00Z", "description": "Description 2", "maxVisitors": 20, "costs": 8.0, "labels": ["Label 2"]}]',
            200));

    return MaterialApp(
      home: Scaffold(
        body: Dashboard(Backend(), mockClient),
      ),
    );
  }
}

class TestWrapperAppDashboard2 extends StatelessWidget {
  static const _backend = "http://127.0.0.1:8080/meetings";

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

@GenerateMocks([http.Client])
void main() {
  testWidgets('Dashboard displays meetings correctly', (tester) async {
    await tester.pumpWidget(TestWrapperAppDashboard1());
    expect(find.byType(Dashboard), findsOneWidget);
    await tester.pumpAndSettle();
    debugDumpApp();
    expect(find.byType(Card), findsNWidgets(2));
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

