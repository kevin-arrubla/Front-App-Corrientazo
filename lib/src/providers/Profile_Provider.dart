import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class ProfileProvider {
  String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  ProfileProvider() {
    uri = '$url/user';
    httpClient = HttpClient();
  }
  Future<Map> getUserById(id) async {
    Map user;
    try {
      Response response = await httpClient.get('$uri/profile/$id');
      user = jsonDecode(response.body);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> updateUserById(id, data) async {
    Map user;
    try {
      Response response = await httpClient.put('$uri/update/$id', data);
      user = jsonDecode(response.body);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> changePassword(authId, data) async {
    Map user;
    try {
      Response response = await httpClient.put('$uri/change/$authId', data);
      user = jsonDecode(response.body);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> saveDirection(data) async {
    Map direction;
    try {
      Response response = await httpClient.post('$uri/saveDirection', data);
      direction = jsonDecode(response.body);
      return direction;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> getDirectionsByUserId(id) async {
    List directions;
    try {
      Response response = await httpClient.get('$uri/getDirections/$id');
      directions = jsonDecode(response.body);
      return directions;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> getOneDirection(id) async {
    Map direction;
    try {
      Response response = await httpClient.get('$uri/getDirection/$id');
      direction = jsonDecode(response.body);
      return direction;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
