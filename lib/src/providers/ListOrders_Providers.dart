import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class ListOrdersProviders {
  String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  ListOrdersProviders() {
    uri = '$url/order';
    httpClient = HttpClient();
  }

  Future<List> getOrdersByUser(id, data) async {
    List orders;

    try {
      Response response = await httpClient.post('$uri/bill/list/$id', data);
      orders = jsonDecode(response.body);
      return orders;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
