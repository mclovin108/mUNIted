import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:munited/model/user_provider.dart';
import 'package:provider/provider.dart';

import '../../Backend/backend.dart';
import '../../constants.dart';

class LoginPage extends StatefulWidget {
  final Backend _backend;
  final http.Client _client;

  const LoginPage(this._backend, this._client);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                        "Log in",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Log into your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[900]),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
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
                              prefixIcon: const Icon(Icons.person)),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Error: Bitte E-Mail eingeben';
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
                            if (text == null || text.isEmpty) {
                              return 'Error: Bitte Passwort eingeben';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            Map<String, dynamic> authenticationResult =
                                await _backend.userIsAuthenticated(
                              _client,
                              emailController.text,
                              passwordController.text,
                            );

                            bool isAuthenticated =
                                authenticationResult['authenticated'] ?? false;

                            if (isAuthenticated) {
                              int userId = authenticationResult['userId'];
                              // Setzen Benutzer-ID im Provider
                              context.read<UserProvider>().setUserId(userId);
                              Navigator.pushNamed(context, '/dash');
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text("Login failed"),
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
                          }
                        },
                        child: const Text(
                          "Login",
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
                      const Text("Don't have an account yet?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text(
                            "Signup",
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
