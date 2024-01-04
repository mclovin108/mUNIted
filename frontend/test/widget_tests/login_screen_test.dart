import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/Dashboard/dashboard.dart';
import 'package:munited/Screens/Login/login_screen.dart';

import 'package:mockito/mockito.dart';
import 'package:munited/Screens/Signup/signup_screen.dart';
import 'package:munited/model/user_provider.dart';
import 'package:provider/provider.dart';
import '../unit_tests/create_user_test.mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

const _backend = "http://127.0.0.1:8080/";

class TestWrapperLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LoginPage(Backend(), http.Client()),
      ),
    );
  }
}

void main() {

  Backend backend = Backend();

  testWidgets('Test: Page does change correct input', (tester) async {
    // Erstelle eine Mock-Instanz von Backend
    final client = MockClient();

    final mockObserver = MockNavigatorObserver();

    when(client.post(
          Uri.parse('${_backend}login'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
              http.Response('{"id": 1, "username": "testUser", "email": "test@example.com", "password": "password"}', 200));


    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(
          home: LoginPage(backend, client),
          routes: {
          '/dash': (context) => Dashboard(Backend(), http.Client()),
          '/login': (context) => LoginPage(backend, client),
        },
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');

    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(Dashboard), findsOneWidget);
  });

  testWidgets('Test: Page does not change on wrong input', (tester) async {
    // Erstelle eine Mock-Instanz von Backend
    final client = MockClient();

    final mockObserver = MockNavigatorObserver();

    when(client.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response('Authentication failed', 401));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(
          home: LoginPage(backend, client),
          routes: {
          '/dash': (context) => Dashboard(Backend(), http.Client()),
          '/login': (context) => LoginPage(backend, client),
        },
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');

    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(find.byType(Dashboard), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Test: Page does change on go to register Button', (tester) async {

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(backend, MockClient()),
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

    expect(find.byType(SignupPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('Test: Two text fields and a button with text Login are present', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Log in'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('Test: Page does not switch when email is missing', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Test: Page does not switch when password is missing', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Test: Hint for email text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    final textFormField = find.byKey(Key("email"));
    final textFinder = find.text('E-Mail');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'E-Mail');
  });

  testWidgets('Test: Hint for password text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    final textFormField = find.byKey(Key("password"));
    final textFinder = find.text('Passwort');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Passwort');
  });

  testWidgets('Test: Validation text for empty email is present', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    await tester.enterText(find.byKey(Key("email")), '');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("email"));
    final textFinder = find.text('Error: Bitte E-Mail eingeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte E-Mail eingeben');
  });

  testWidgets('Test: Validation text for empty password is present', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), '');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("password"));
    final textFinder = find.text('Error: Bitte Passwort eingeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte Passwort eingeben');
  });
}
