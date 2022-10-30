import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  loadPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print(_prefs.getString('id'));
  }
}
