import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class SignInProvider {
  String url = Uri().getUri();
  HttpClient http;
  String uri;

  SignInProvider() {
    http = HttpClient();
    uri = '$url/user/save';
  }

  Future<Map> createUser(data) async {
    Map user;
    try {
      Response res = await http.post('$uri', data);
      user = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return user;
  }
}
