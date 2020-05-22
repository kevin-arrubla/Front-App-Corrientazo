import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class TodayMenuProvider {
  String url = Uri().getUri();
  String uri;
  HttpClient http;

  TodayMenuProvider() {
    http = HttpClient();
    uri = "$url/menu";
  }

  List decodeData1;

  Future<List> optionsBymenuId(menuId) async {
    try {
      Response resp1 = await http.get('$uri/Options/$menuId');
      decodeData1 = json.decode(resp1.body);

      return decodeData1;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List> loadmenu(id) async {
    List decodeData;
    try {
      Response resp = await http.get('$uri/list/$id');
      decodeData = json.decode(resp.body);
      return decodeData;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List> optionmenu(menuId) async {
    try {
      Response resp1 = await http.get('$uri/option/$menuId');
      decodeData1 = json.decode(resp1.body);

      return decodeData1;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List> suboption(id) async {
    List decodeData;
    try {
      Response resp1 = await http.get('$uri/subOption/$id');
      decodeData = json.decode(resp1.body);
      return decodeData;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
