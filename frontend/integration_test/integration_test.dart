import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:munited/main.dart';
import 'package:munited/Screens/Signup/signup_screen.dart';
import 'package:munited/Screens/Login/login_screen.dart';
import 'package:munited/Screens/Dashboard/dashboard.dart';
import 'package:munited/Screens/CreateMeeting/create_meeting.dart';
import 'package:munited/Screens/Detail/detailpage.dart';
import 'package:munited/Screens/EditMeeting/edit_meeting_screen.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  group('end-to-end test', () {
    testWidgets('Test: register & login',
    (tester) async {
      // Start auf MainPage
      await tester.pumpWidget(const MyApp());
      expect(find.byType(LoginPage), findsOneWidget);
      // Wechsel auf SignUpPage
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(SignupPage), findsOneWidget);
      // User Daten eintragen
      await tester.enterText(find.byKey(Key("username")), 'testUser');
      await tester.enterText(find.byKey(Key("email")), 'test@example.com');
      await tester.enterText(find.byKey(Key("password")), 'password1');
      await tester.enterText(find.byKey(Key("confirm_password")), 'password1');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      // Item speichern und Wechsel zurück auf Login
      expect(find.byType(LoginPage), findsOneWidget);
      // User mit Daten einloggen und auf DashboardPage wechseln
      await tester.enterText(find.byKey(Key("email")), 'test@example.com');
      await tester.enterText(find.byKey(Key("password")), 'password1');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dashboard), findsOneWidget);
      // leere liste Events
      expect(find.byType(VerticalCard).evaluate().length, 0);
    });

    testWidgets('Test: login , create & delete Event',
    (tester) async {
      // Start auf MainPage
      await tester.pumpWidget(const MyApp());
      expect(find.byType(LoginPage), findsOneWidget);
      // User mit Daten einloggen und auf DashboardPage wechseln
      await tester.enterText(find.byKey(Key("email")), 'test@example.com');
      await tester.enterText(find.byKey(Key("password")), 'password1');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dashboard), findsOneWidget);
      // leere liste Events
      expect(find.byType(VerticalCard).evaluate().length, 0);
      // Wechsel auf CreatePage
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(CreateMeetingPage), findsOneWidget);
      // Event Daten eintragen und erstellen
      // EmojiPicker:
      await tester.tap(find.byIcon(Icons.emoji_emotions));
      await tester.pumpAndSettle(Duration(seconds: 2)); 
      await tester.tap(find.byIcon(Icons.tag_faces));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('🤣'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      // time:
      await tester.tap(find.byKey(Key("start")));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      // rest:
      await tester.enterText(find.byKey(Key("title")), 'Titel');
      await tester.enterText(find.byKey(Key("description")), 'Beschreibung');
      await tester.enterText(find.byKey(Key("maxVisitors")), '20');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dashboard), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 2));
      // Liste mit einem Event
      expect(find.byType(VerticalCard).evaluate().length, 1);
      // Wechsel auf DetailPage
      await tester.tap(find.byType(VerticalCard));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Detail), findsOneWidget);
      // delete
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dashboard), findsOneWidget);
      expect(find.byType(VerticalCard).evaluate().length, 0);
    });

    testWidgets('Test: login , create & update Event',
    (tester) async {
      // Start auf MainPage
      await tester.pumpWidget(const MyApp());
      expect(find.byType(LoginPage), findsOneWidget);
      // User mit Daten einloggen und auf DashboardPage wechseln
      await tester.enterText(find.byKey(Key("email")), 'test@example.com');
      await tester.enterText(find.byKey(Key("password")), 'password1');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dashboard), findsOneWidget);
      // leere liste Events
      expect(find.byType(VerticalCard).evaluate().length, 0);
      // Wechsel auf CreatePage
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(CreateMeetingPage), findsOneWidget);
      // Event Daten eintragen und erstellen
      // EmojiPicker:
      await tester.tap(find.byIcon(Icons.emoji_emotions));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.byIcon(Icons.tag_faces));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('🤣'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      // time:
      await tester.tap(find.byKey(Key("start")));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      // rest:
      await tester.enterText(find.byKey(Key("title")), 'Titel');
      await tester.enterText(find.byKey(Key("description")), 'Beschreibung');
      await tester.enterText(find.byKey(Key("maxVisitors")), '20');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dashboard), findsOneWidget);
      // Liste mit einem Event
      expect(find.byType(VerticalCard).evaluate().length, 1);
      expect(find.text('Titel'), findsOneWidget);
      expect(find.text('testUser'), findsOneWidget);
      expect(find.text('🤣'), findsOneWidget);
      // Wechsel auf DetailPage
      await tester.tap(find.byType(VerticalCard));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Detail), findsOneWidget);
      // Wechsel auf EditPage
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(EditMeetingPage), findsOneWidget);
      // Emoji ändern
      await tester.tap(find.byIcon(Icons.emoji_emotions));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.byIcon(Icons.tag_faces));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('😍'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      // Titel & Beschreibung ändern
      await tester.enterText(find.byKey(Key("title")), 'Neuer Titel');
      await tester.enterText(find.byKey(Key("description")), 'Neue Beschreibung');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byType(Dashboard), findsOneWidget);
      // Liste mit einem geupdateten Event
      expect(find.byType(VerticalCard).evaluate().length, 1);
      expect(find.text('Neuer Titel'), findsOneWidget);
      expect(find.text('testUser'), findsOneWidget);
      expect(find.text('😍'), findsOneWidget);
    });
  });
  
}