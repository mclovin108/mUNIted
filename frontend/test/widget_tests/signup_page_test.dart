import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munited/Screens/Login/login_screen.dart';
import 'package:munited/Screens/Signup/signup_screen.dart';
import 'package:munited/Backend/backend.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../unit_tests/create_user_test.mocks.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}

const _backend = "http://127.0.0.1:8080/";

class TestWrapperSignupPage extends StatelessWidget {

  final Backend _backend;
  final http.Client _client;

  const TestWrapperSignupPage(this._backend, this._client);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signup': (context) => SignupPage(_backend, _client),
        '/login': (context) => LoginPage(_backend, _client),
      },
      home: Scaffold(
        body: SignupPage(_backend, _client),
      ),
    );
  }
}



void main() {

  Backend backend = Backend();

  testWidgets('Test: Error message when passwords do not match', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));

    // Fülle die erforderlichen Felder aus, aber setze unterschiedliche Passwörter
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password1');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password2');

    // Überwache die Fehlermeldung
    await tester.tap(find.byType(ElevatedButton));

    // Warte darauf, dass die Validierung durchgeführt wird
    await tester.pump();

    // Überprüfe, ob eine Fehlermeldung angezeigt wird
    expect(find.text('Die Passwörter stimmen nicht überein!'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'OK'), findsOneWidget);
  });


  testWidgets('Test: Error message for already taken email', (tester) async {
    // Erstelle eine Mock-Instanz von Backend
    final backend = Backend();
    final client = MockClient();


    when(client.get(
        Uri.parse('${_backend}users'),
      )).thenAnswer((_) async => http.Response(
          '[{"id": 1, "username": "testUser", "email": "test@example.com", "password": "password"}]', 200));

    await tester.pumpWidget(TestWrapperSignupPage(backend, client));

    // Fülle die erforderlichen Felder aus
    await tester.enterText(find.byKey(Key("username")), 'testUser1');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');

    // Überwache die Fehlermeldung
    await tester.tap(find.byType(ElevatedButton));

    // Warte darauf, dass die Validierung durchgeführt wird
    await tester.pumpAndSettle();

    // Überprüfe, ob die richtige Fehlermeldung angezeigt wird
    expect(find.text('Diese E-Mail ist bereits vergeben'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'OK'), findsOneWidget);
  });

  testWidgets('Test: Error message for already taken username', (tester) async {
    // Erstelle eine Mock-Instanz von Backend
    final backend = Backend();
    final client = MockClient();

    when(client.get(
        Uri.parse('${_backend}users'),
      )).thenAnswer((_) async => http.Response(
          '[{"id": 1, "username": "testUser", "email": "test@example.com", "password": "password"}]', 200));

    await tester.pumpWidget(TestWrapperSignupPage(backend, client));

    // Fülle die erforderlichen Felder aus
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test1@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');

    // Überwache die Fehlermeldung
    await tester.tap(find.byType(ElevatedButton));

    // Warte darauf, dass die Validierung durchgeführt wird
    await tester.pumpAndSettle();

    // Überprüfe, ob die richtige Fehlermeldung angezeigt wird
    expect(find.text('Der Benutzername ist bereits vergeben'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'OK'), findsOneWidget);
  });
  

  testWidgets('Test: Page does change correct input', (tester) async {
    // Erstelle eine Mock-Instanz von Backend
    final client = MockClient();

    final mockObserver = MockNavigatorObserver();

    when(client.get(
        Uri.parse('${_backend}users'),
      )).thenAnswer((_) async => http.Response(
          '[]', 200));

    when(client.post(
        Uri.parse('${_backend}register'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
          '{"id": 1, "username": "testUser", "email": "test@example.com", "password": "password"}', 200));


    await tester.pumpWidget(
      MaterialApp(
        home: SignupPage(backend, client),
        routes: {
        '/signup': (context) => SignupPage(backend, client),
        '/login': (context) => LoginPage(backend, client),
      },
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');

    await tester.tap(find.byType(ElevatedButton));

    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Test: Page does change on go to Anmelden Button', (tester) async {

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: SignupPage(backend, MockClient()),
        routes: {
        '/signup': (context) => SignupPage(backend, MockClient()),
        '/login': (context) => LoginPage(backend, MockClient()),
      },
        navigatorObservers: [mockObserver],
      ),
    );

    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(SignupPage), findsNothing);
  });



  testWidgets('Test: four TextFields and a button with text "Registrieren" are present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Anmelden'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Registrieren'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Anmelden'), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing username', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing email', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing password', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing confirm password', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change when password and confirm password do not match', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password1');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password2');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Hint for username text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    final textFormField = find.byKey(Key("username"));
    final textFinder = find.text('Benutzername');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Benutzername');
  });

  testWidgets('Test: Hint for email text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    final textFormField = find.byKey(Key("email"));
    final textFinder = find.text('E-Mail');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'E-Mail');
  });

  testWidgets('Test: Hint for password text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    final textFormField = find.byKey(Key("password"));
    final textFinder = find.text('Passwort');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Passwort');
  });

  testWidgets('Test: Hint for confirm password text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    final textFormField = find.byKey(Key("confirm_password"));
    final textFinder = find.text('Passwort bestätigen');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Passwort bestätigen');
  });

  testWidgets('Test: Validation text for empty username is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), '');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("username"));
    final textFinder = find.text('Error: Bitte Benutzername mit mindestens 5 Zeichen eingeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte Benutzername mit mindestens 5 Zeichen eingeben');
  });

  testWidgets('Test: Validation text for empty email is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), '');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("email"));
    final textFinder = find.text('Error: Bitte korrekte E-Mail angeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte korrekte E-Mail angeben');
  });

  testWidgets('Test: Validation text for empty password is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), '');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("password"));
    final textFinder = find.text('Error: Bitte Passwort mit mindestens 8 Zeichen eingeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte Passwort mit mindestens 8 Zeichen eingeben');
  });

  testWidgets('Test: Validation text for empty confirm password is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage(backend, MockClient()));
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), '');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("confirm_password"));
    final textFinder = find.text('Error: Bitte Passwort bestätigen');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte Passwort bestätigen');
  });

}

