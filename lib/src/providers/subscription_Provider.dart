import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/Url_Gateway.dart';

class SubscriptionProvider {
  String url = Uri().getUri();
  HttpClient http;
  String uri;

  SubscriptionProvider() {
    http = HttpClient();
    uri = '$url/subscription';
  }

  Future<Map> createPackage(data) async {
    Map package;

    try {
      Response res = await http.post('$uri/packages', data);
      package = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return package;
  }

  Future<Map> createSubscription(data) async {
    Map subscription;

    try {
      Response res = await http.post('$uri/createSubscription', data);
      subscription = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return subscription;
  }

  Future<List> getSubscriptionsByUser(id) async {
    List subscriptions;
    try {
      Response response = await http.get('$uri/getSubsByUser/$id');

      subscriptions = jsonDecode(response.body);
      return subscriptions;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> getSubscriptionsByRestaurant(idRest) async {
    List subscriptions;

    try {
      Response response = await http.get('$uri/getSubsByRestaurant/$idRest');
      subscriptions = jsonDecode(response.body);
      return subscriptions;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> getOneSubscription(idSubscription) async {
    Map subscription;

    try {
      Response response =
          await http.get('$uri/getOneSubscription/$idSubscription');
      subscription = jsonDecode(response.body);
      return subscription;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> getOnePackage(idrest) async {
    Map pack;
    try {
      Response response = await http.get('$uri/getOnePackage/$idrest');
      pack = jsonDecode(response.body);
      return pack;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> getPacksByRestaurant(idrest) async {
    List pack;

    try {
      Response response = await http.get('$uri/getPacksByRestaurant/$idrest');
      pack = jsonDecode(response.body);
      return pack;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> getBalance(userId) async {
    List balance;
    try {
      Response response = await http.get('$uri/getBalance/$userId');
      balance = jsonDecode(response.body);
      return balance;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> updateBalance(userId, data) async {
    List balance;
    try {
      Response res = await http.put('$uri/updateBalance/$userId', data);
      balance = jsonDecode(res.body);
      return balance;
    } catch (err) {
      print(err);
    }
    return null;
  }
}
