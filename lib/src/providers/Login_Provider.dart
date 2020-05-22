import 'dart:convert';
import 'package:front_app_corrientazo/src/utils/token.dart';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class LoginProvider {
  String url = Uri().getUri();
  HttpClient http;
  String uri;

  LoginProvider() {
    http = HttpClient();
    uri = '$url/user/login';
  }

  Future<Map> login(data) async {
    Map user;
    try {
      Response res = await http.post('$uri', data);
      user = jsonDecode(res.body);
      Token().setToken(user['token']);
      Token().setString(data['authEmail'], data['authPassword']);
    } catch (err) {
      print(err);
    }
    return user;
  }
}
