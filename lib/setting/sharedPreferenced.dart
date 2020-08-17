
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  getStringPrefs(String nameOfPrefs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameOfPrefs);
  }

  setStringPrefs(String nameOfPrefs, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameOfPrefs, value);
  }

}