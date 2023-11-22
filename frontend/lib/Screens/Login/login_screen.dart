import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';
import 'package:http/http.dart' as http;



class LoginPage extends StatefulWidget {

  final Backend _backend;
  final http.Client _client;

  const LoginPage(this._backend, this._client);


  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {


  // necessary for mocking (unit and widget tests)
  late Backend _backend;    // library with functions to access backend
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
    TextEditingController passwordController = TextEditingController();

    void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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

  Future<void> _loginButtonPressed() async {

    if (usernameController.text.isEmpty) {
      genericErrorMessage("Please type in your username");
      return;
    }
    if (passwordController.text.isEmpty) {
      genericErrorMessage("Please type in your password");
      return;
    }

  bool isAuthenticated = await _backend.userIsAuthenticated(
    _client,
    usernameController.text,
    passwordController.text,
  );

  if (isAuthenticated) {
    Navigator.pushNamed(context, '/dash');
  } else {
    genericErrorMessage("Invalid username or password");
  }
}

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
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
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: kPrimaryColor,
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Error: please enter username';
                        }
                        return null;
                      }
                    ),

                    const SizedBox(height: 20),
                                
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: kPrimaryColor,
                          filled: true,
                          prefixIcon: const Icon(Icons.lock)),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Error: please enter password';
                        }
                        return null;
                      }
                    ),

                    const SizedBox(height: 20),
                  
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),

                    child: ElevatedButton(
                      onPressed: () {
                        _loginButtonPressed();
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kPrimaryDarkColor,
                      ),
                    )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Don't have an account yet?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text("Signup", style: TextStyle(color: kPrimaryDarkColor),)
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}