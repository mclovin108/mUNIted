import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserProvider extends ChangeNotifier {
  int? userId;

  void setUserId(int id) {
    userId = id;
    notifyListeners();
  }

  int? getUserId() {
    return userId;
  }
}