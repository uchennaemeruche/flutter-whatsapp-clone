import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier{
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;
  setTheme(ThemeData theme){
    _themeData = theme;

    notifyListeners();
  }
}


class ThemeMode{
  String text;
  int id;

  ThemeMode({this.text, this.id});

  // static List<ThemeMode> getThemeModes(){
  //   return <ThemeMode>[
  //     ThemeMode(id: 1, text: 'Dark Mode'),
  //     ThemeMode(id: 2, text: 'Light Mode')
  //   ];
  // }


}

List<ThemeMode> modes = [
 ThemeMode(id: 10, text: 'Dark Mode'),
  ThemeMode(id: 20, text: 'Light Mode')
];