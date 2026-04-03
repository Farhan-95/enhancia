import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  SharedPreferences? prefs;
  bool _isDarkTheme = true;
  bool get isDarkTheme  => _isDarkTheme;
  Color _appBarColor = Colors.black;
  Color get appBarColor => _appBarColor;

  ThemeProvider(){
    getCustomAppbarColor();
    loadThemeSP();
  }

  void toggleTheme()async{
    _isDarkTheme = !_isDarkTheme;
    setThemeSP();
    notifyListeners();
  }


  void setThemeSP()async{
   prefs = await SharedPreferences.getInstance();
   await prefs?.setBool('isDarkTheme',_isDarkTheme);
  }
  void loadThemeSP()async{
    prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs?.getBool('isDarkTheme')??true;
    notifyListeners();
  }

  void setCustomAppbarColor(Color color)async{
    _appBarColor = color;
    prefs = await SharedPreferences.getInstance();
    prefs?.setInt('appBarColor', color.value);
    notifyListeners();
  }
  void getCustomAppbarColor()async{
    prefs = await SharedPreferences.getInstance();
    int? savedColor = prefs?.getInt('appBarColor');
    if(savedColor!=null){
      _appBarColor = Color(savedColor);
      notifyListeners();
    }
  }
}