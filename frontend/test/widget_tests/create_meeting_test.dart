import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/CreateMeeting/create_meeting.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';


class TestWrapperCreateMeetingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: CreateMeetingPage(Backend(), http.Client()),
      ),
    );
  }
}

void main() {
  /*
  testWidgets('Test: Form validation and meeting creation', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());

    // Enter valid data into form fields
    await tester.enterText(find.byKey(Key("title")), 'Test Meeting');
    await tester.enterText(find.byKey(Key("icon")), '😊');
    await tester.enterText(find.byKey(Key("start")), '2023-01-01 12:00');
    await tester.enterText(find.byKey(Key("description")), 'description');
    await tester.tap(find.byType(ElevatedButton));

    // Wait for validation to complete
    await tester.pumpAndSettle();

    // Expect the meeting creation to succeed
    expect(find.text('Meeting created successfully'), findsOneWidget);
  });*/

  testWidgets('Test: Seite wechselt nicht bei fehlendem Titel', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(CreateMeetingPage), findsOneWidget);
  });

  testWidgets('Test: Seite wechselt nicht bei fehlendem Icon', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.enterText(find.byKey(Key("title")), 'Meeting Title');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(CreateMeetingPage), findsOneWidget);
  });

  testWidgets('Test: Seite wechselt nicht bei fehlender Startzeit', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.enterText(find.byKey(Key("title")), 'Meeting Title');
    await tester.enterText(find.byKey(Key("icon")), '😊');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(CreateMeetingPage), findsOneWidget);
  });

  testWidgets('Test: Seite wechselt nicht bei fehlender Beschreibung', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.enterText(find.byKey(Key("title")), 'Meeting Title');
    await tester.enterText(find.byKey(Key("icon")), '😊');
    await tester.enterText(find.byKey(Key("start")), '2023-01-01 12:00');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(CreateMeetingPage), findsOneWidget);
  });

  testWidgets('Test: Validation Text bei leerem Titel ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.enterText(find.byKey(Key("title")), '');
    await tester.enterText(find.byKey(Key("icon")), '😊');
    await tester.enterText(find.byKey(Key("start")), '2023-01-01 12:00');
    await tester.enterText(find.byKey(Key("description")), 'description');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("title"));
    final textFinder = find.text('Titel darf nicht leer sein');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Titel darf nicht leer sein');
  });

  testWidgets('Test: Validation Text bei leerem Icon ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.enterText(find.byKey(Key("title")), 'Titel');
    await tester.enterText(find.byKey(Key("icon")), '');
    await tester.enterText(find.byKey(Key("start")), '2023-01-01 12:00');
    await tester.enterText(find.byKey(Key("description")), 'description');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("icon"));
    final textFinder = find.text('Icon darf nicht leer sein');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Icon darf nicht leer sein');
  });

  testWidgets('Test: Validation Text bei leerer Startzeit ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.enterText(find.byKey(Key("title")), 'Titel');
    await tester.enterText(find.byKey(Key("icon")), '😊');
    await tester.enterText(find.byKey(Key("start")), '');
    await tester.enterText(find.byKey(Key("description")), 'description');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("start"));
    final textFinder = find.text('Startzeit darf nicht leer sein');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Startzeit darf nicht leer sein');
  });

  testWidgets('Test: Validation Text bei leerer Beschreibung ist vorhanden', (tester) async {
    await tester.pumpWidget(TestWrapperCreateMeetingPage());
    await tester.enterText(find.byKey(Key("title")), 'Titel');
    await tester.enterText(find.byKey(Key("icon")), '😊');
    await tester.enterText(find.byKey(Key("start")), '2023-01-01 12:00');
    await tester.enterText(find.byKey(Key("description")), '');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("description"));
    final textFinder = find.text('Beschreibung darf nicht leer sein');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Beschreibung darf nicht leer sein');
  });

}
