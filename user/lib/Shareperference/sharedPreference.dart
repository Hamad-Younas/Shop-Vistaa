import 'package:shared_preferences/shared_preferences.dart';


void saveNameToLocal(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('storedName', name);
}

// Getting the name from local storage
Future<String?> getNameFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('storedName');
}