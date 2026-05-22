import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/database_provider.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get currentUser => _user;

  void login(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  Future<void> addScore(int amount) async {
    if (_user == null) return;

    _user!.score += amount;
    notifyListeners();

    await DatabaseProvider().updateScore(_user!.id!, _user!.score);
  }
}
