import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Backend/backend.dart';
import '../../constants.dart';

//import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  final Backend _backend;
  final http.Client _client;

  const SignupPage(this._backend, this._client);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // necessary for mocking (unit and widget tests)
  late Backend _backend; // library with functions to access backend
  late http.Client _client; // REST client proxy

  @override
  void initState() {
    super.initState();
    _backend = widget._backend;
    _client = widget._client;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    void genericErrorMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kPrimaryColor,
            title: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "Registrieren",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Account erstellen",
                        style: TextStyle(fontSize: 15, color: Colors.grey[900]),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                          key: Key("username"),
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: "Benutzername",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.person)),
                          validator: (text) {
                            if (text == null || text.isEmpty || text.length < 5) {
                              return 'Error: Bitte Benutzername mit mindestens 5 Zeichen eingeben';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      TextFormField(
                          key: Key("email"),
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: "E-Mail",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.mail)),
                          validator: (text) {
                            if (text == null || text.isEmpty || !text.contains('@') || !text.contains('.')) {
                              return 'Error: Bitte korrekte E-Mail angeben';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      TextFormField(
                          key: Key("password"),
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Passwort",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.key)),
                          validator: (text) {
                            if (text == null || text.isEmpty || text.length < 8) {
                              return 'Error: Bitte Passwort mit mindestens 8 Zeichen eingeben';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      TextFormField(
                          key: Key("confirm_password"),
                          controller: confirmPasswordController,
                          maxLines: 1,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Passwort bestätigen",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.key)),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Error: Bitte Passwort bestätigen';
                            }
                            return null;
                          }),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (passwordController.text ==
                                confirmPasswordController.text) {
                              bool isUsernameAvailable =
                                  await _backend.isUsernameAvailable(
                                      _client, usernameController.text);
                              bool isEmailAvailable =
                                  await _backend.isEmailAvailable(
                                      _client, emailController.text);

                              if (isUsernameAvailable) {
                                if (isEmailAvailable) {
                                  // Der Benutzername und die Mail sind verfügbar, Sie können den Benutzer erstellen
                                  _backend
                                      .createUser(
                                          _client,
                                          usernameController.text,
                                          emailController.text,
                                          passwordController.text,
                                          confirmPasswordController.text)
                                      .then((value) =>
                                          Navigator.pushReplacementNamed(
                                              context, "/login"));
                                } else {
                                  // Die Mail ist bereits vergeben
                                  genericErrorMessage(
                                      "Diese E-Mail ist bereits vergeben");
                                }
                              } else {
                                // Der Benutzername ist bereits vergeben
                                genericErrorMessage(
                                    "Der Benutzername ist bereits vergeben");
                              }
                            } else {
                              // Die Passwörter stimmen nicht überein
                              genericErrorMessage(
                                  "Die Passwörter stimmen nicht überein!");
                            }
                          }
                        },
                        child: const Text(
                          "Registrieren",
                          style: TextStyle(fontSize: 20, color: kPrimaryLightColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: kPrimaryDarkColor,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Bereits registriert?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "Anmelden",
                            style: TextStyle(color: kPrimaryDarkColor),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
