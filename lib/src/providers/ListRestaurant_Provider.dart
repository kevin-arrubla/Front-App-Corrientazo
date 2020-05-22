import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class ListRestaurantProviders {
  String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  ListRestaurantProviders() {
    uri = '$url';
    httpClient = HttpClient();
  }

  Future<List> getRestaurant() async {
    List restaurant;
    try {
      Response response = await httpClient.get('$uri/restaurant/list');
      restaurant = jsonDecode(response.body);
      return restaurant;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> getRestaurantByCity(city) async {
    List restaurant;
    try {
      Response response = await httpClient.get('$uri/restaurant/listRestByCity/$city');
      restaurant = jsonDecode(response.body);
    
      return restaurant;
    } catch (e) {
      print(e);
      return null;
    }
  }
  Future<Map> getRestaurantId(id) async {
    Map restaurant;

    try {
      Response response = await httpClient.get('$uri/restaurant/list/$id');
      restaurant = jsonDecode(response.body);      
      return restaurant;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> getRestaurantByName(name) async {
    List restaurant;

    try {
      Response response = await httpClient.get('$uri/restaurant/listRestByName/$name');
      restaurant = jsonDecode(response.body);     
      return restaurant;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
