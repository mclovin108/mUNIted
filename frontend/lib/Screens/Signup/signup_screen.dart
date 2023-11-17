import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';
import 'package:http/http.dart' as http;



class SignupPage extends StatefulWidget {

  final Backend _backend;
  final http.Client _client;

  const SignupPage(this._backend, this._client);


  @override
  State<SignupPage> createState() => _SignupPageState();
}


class _SignupPageState extends State<SignupPage> {


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
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

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
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
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
                      controller: emailController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: kPrimaryColor,
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Error: please enter E-Mail';
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
                          hintText: "Pasword",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: kPrimaryColor,
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Error: please enter password';
                        }
                        return null;
                      }
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: confirmPasswordController,
                      maxLines: 1,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: kPrimaryColor,
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Error: please confirm password';
                        }
                        return null;
                      }
                    ),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),

                    child: ElevatedButton(
                      onPressed: () {
                        if (passwordController.text == confirmPasswordController.text) {
                          _backend.createUser(_client, usernameController.text, emailController.text, passwordController.text, confirmPasswordController.text)
                          .then((value) => Navigator.pop(context));
                        } else {
                          //show error password dont match
                          genericErrorMessage("Passwords don't match!");
                        }
                      },
                      child: const Text(
                        "Sign up",
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
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                        },
                        child: const Text("Login", style: TextStyle(color: kPrimaryDarkColor),)
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