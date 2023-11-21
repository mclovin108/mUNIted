
//import 'dart:ffi';

class User {
    int id;
    String username;
    String email;
    String password;

    User({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
    });

    // parse User from JSON-data
    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] as int,
        username: json["username"] as String,
        email: json["email"] as String,
        password: json["password"] as String,
    );

    // map user to JSON-data (so far not used in app)
    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
    };
}