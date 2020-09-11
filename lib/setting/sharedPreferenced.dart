
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  getStringPrefs(String nameOfPrefs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameOfPrefs);
  }

  hasString(String nameOfPrefs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(nameOfPrefs);
  }

  setStringPrefs(String nameOfPrefs, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameOfPrefs, value);
  }

  setIntPrefs(String nameOfPrefs, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(nameOfPrefs, value);
  }

  getIntPrefs(String nameOfPrefs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(nameOfPrefs);
  }

  removeValues(String nameOfPrefs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(nameOfPrefs);
  }

}