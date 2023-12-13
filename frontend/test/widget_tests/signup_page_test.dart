import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munited/Screens/Signup/signup_screen.dart';
import 'package:munited/Backend/backend.dart';
import 'package:http/http.dart' as http;

class TestWrapperSignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SignupPage(Backend(), http.Client()),
      ),
    );
  }
}

void main() {
  testWidgets('Test: four TextFields and a button with text "Registrieren" are present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.widgetWithText(ElevatedButton, 'Registrieren'), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing username', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing email', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing password', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change with missing confirm password', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Page does not change when password and confirm password do not match', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password1');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password2');
    await tester.tap(find.byType(ElevatedButton));
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('Test: Hint for username text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    final textFormField = find.byKey(Key("username"));
    final textFinder = find.text('Benutzername');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Benutzername');
  });

  testWidgets('Test: Hint for email text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    final textFormField = find.byKey(Key("email"));
    final textFinder = find.text('E-Mail');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'E-Mail');
  });

  testWidgets('Test: Hint for password text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    final textFormField = find.byKey(Key("password"));
    final textFinder = find.text('Passwort');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Passwort');
  });

  testWidgets('Test: Hint for confirm password text field is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    final textFormField = find.byKey(Key("confirm_password"));
    final textFinder = find.text('Passwort bestätigen');
    final hintMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(hintMessageFinder.data, 'Passwort bestätigen');
  });

  testWidgets('Test: Validation text for empty username is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("username")), '');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("username"));
    final textFinder = find.text('Error: Bitte Benutzername eingeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte Benutzername eingeben');
  });

  testWidgets('Test: Validation text for empty email is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), '');
    await tester.enterText(find.byKey(Key("password")), 'password');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("email"));
    final textFinder = find.text('Error: Bitte E-Mail eingeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte E-Mail eingeben');
  });

  testWidgets('Test: Validation text for empty password is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
    await tester.enterText(find.byKey(Key("username")), 'testUser');
    await tester.enterText(find.byKey(Key("email")), 'test@example.com');
    await tester.enterText(find.byKey(Key("password")), '');
    await tester.enterText(find.byKey(Key("confirm_password")), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    final textFormField = find.byKey(Key("password"));
    final textFinder = find.text('Error: Bitte Passwort eingeben');
    final validationMessageFinder = find.descendant(of: textFormField, matching: textFinder).first.evaluate().single.widget as Text;
    expect(validationMessageFinder.data, 'Error: Bitte Passwort eingeben');
  });

  testWidgets('Test: Validation text for empty confirm password is present', (tester) async {
    await tester.pumpWidget(TestWrapperSignupPage());
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

