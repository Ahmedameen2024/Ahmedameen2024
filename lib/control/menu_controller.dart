import 'package:flutter/material.dart';

class MenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get ScaffuldKey => _globalKey;

  void controlMenu() {
    if (_globalKey.currentState!.isDrawerOpen) {
      _globalKey.currentState?.openDrawer();
    }
  }
}
