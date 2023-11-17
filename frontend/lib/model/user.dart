
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

    // parse Item from JSON-data
    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] as int,
        username: json["username"] as String,
        email: json["email"] as String,
        password: json["password"] as String,
    );

    // map item to JSON-data (so far not used in app)
    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
    };
}

//List<Item> itemsFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

//String itemsToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//Item itemFromJson(String str) => Item.fromJson(json.decode(str));

//String itemToJson(Item data) => json.encode(data.toJson());

