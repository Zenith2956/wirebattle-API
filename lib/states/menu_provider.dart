import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  String _menu = 'Accueil';

  String get menu => _menu;

  void changeMenu(String newMenu) {
    _menu = newMenu;
    notifyListeners();
  }
}
