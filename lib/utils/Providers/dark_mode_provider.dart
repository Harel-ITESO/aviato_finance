import 'package:flutter/widgets.dart';


class DarkModeProvider with ChangeNotifier{
  var darkMode=false;
  setDarkMode(bool value){
    darkMode = value;
    notifyListeners();

  }
  toggleDarkMode(){
    darkMode = !darkMode;
    notifyListeners();
  }
  getDarkModeValue(){
    return darkMode;
  }
} 