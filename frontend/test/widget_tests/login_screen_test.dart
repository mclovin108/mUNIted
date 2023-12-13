import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:munited/Backend/backend.dart';
import 'package:munited/Screens/Login/login_screen.dart';

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
  testWidgets('Test: Two text fields and a button with text Login are present', (tester) async {
    await tester.pumpWidget(TestWrapperLoginPage());
    expect(find.byType(TextField), findsNWidgets(2));
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
