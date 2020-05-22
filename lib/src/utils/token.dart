import 'package:shared_preferences/shared_preferences.dart';

class Token {
  List<String> data;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  void setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  void setString(String key, String value)async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

   void setStringPayment(String key, String value)async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  // Future<int> getNumber(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt(key) ?? 0;
  // }

  // void setNumber(String key, int value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt(key, value);
  //   print('pass');
  //   print(prefs.getInt(key).toString());
  // }

}
