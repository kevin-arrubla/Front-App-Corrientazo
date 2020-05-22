import 'dart:convert';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class ResetProvider {
  String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  ResetProvider() {
   uri = '$url/user';
    httpClient = HttpClient();
  }

  Future<Map> resetPassword(data) async {
    Map user;

    try {
      Response doc = await httpClient.post('$uri/resetPassword', data);
      user = jsonDecode(doc.body);
    } catch (err) {
      print(err);
    }

    return user;
  }
}
