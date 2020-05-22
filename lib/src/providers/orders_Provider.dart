import 'dart:convert';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/url_gateway.dart';

class OrdersProviders {
  Alerts alert = Alerts();

  String url = Uri().getUri();
  HttpClient http;
  String uri;

  //Future<bool> getOrder( );

  OrdersProviders() {
    http = HttpClient();
    uri = '$url/order';
  }

  Map ordetsData;
  Map token;

  Future<Map> getOrders() async {
    try {
      Response res = await http.get(url);
      ordetsData = json.decode(res.body);

      token = ordetsData['token'];
      return ordetsData;
    } catch (err) {
      return null;
    }
  }

  Future<Map> getOrderActive(id) async {
    Map order;
    try {
      Response res = await http.get('$uri/ordersDetail/$id');
      order = jsonDecode(res.body);
      return order;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<Map> createOrder(data) async {
    Map user;
    try {
      Response res = await http.post('$uri/createBill', data);
      user = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return user;
  }

  Future<Map> createDetailOrder(data) async {
    Map user;
    try {
      Response res = await http.post('$uri/createBillDetail', data);
      user = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return user;
  }

  Future<List> orderAll(userId) async {
    List orderAll;
    try {
      Response res = await http.get('$uri/getOrderAllBasket/$userId');
      orderAll = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return orderAll;
  }

  Future<Map> orderAllOrderId(orderId) async {
    Map orderAllorderId;
    try {
      Response res = await http.get('$uri/getOrderAllOrderId/$orderId');
      orderAllorderId = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return orderAllorderId;
  }

  Future<List> updateOrder(state, id, data) async {
    if (state == 'ENVIADO') {
      if (data['state'] == 'CANCELADO') {
        print('No se puede cancelar');
      } else if (data['state'] == 'RECIBIDO') {
        List order;
        try {
          Response res = await http.put('$uri/updateOrder/$id', data);
          order = jsonDecode(res.body);
          return order;
        } catch (err) {
          print(err);
        }
      }
    } else {
      List order;
      try {
        Response res = await http.put('$uri/updateOrder/$id', data);
        order = jsonDecode(res.body);
        return order;
      } catch (err) {
        print(err);
      }
    }

    return null;
  }

  Future<List> updateOrderPayment(userId, data) async {
    List order;
    try {
      Response res = await http.put('$uri/orderPayment/$userId', data);
      order = jsonDecode(res.body);
      return order;
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<Map> getOrderAndDetail(orderId) async {
    Map order;
    try {
      Response res = await http.get('$uri/ordersDetail/$orderId');
      order = jsonDecode(res.body);
      return order;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List> updateOrderDetail(orderDetailId, data) async {
    List order;
    try {
      Response res = await http.put('$uri/orderDetail/$orderDetailId', data);
      order = jsonDecode(res.body);
      return order;
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<List> deleteOrderDetail(orderDetailId) async {
    List order;
    try {
      Response res = await http.delete('$uri/deleteDetail/$orderDetailId');
      order = jsonDecode(res.body);
      return order;
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<List> deleteOrderId(orderId) async {
    List order;
    try {
      Response res = await http.delete('$uri/deleteOrderId/$orderId');
      order = jsonDecode(res.body);
      return order;
    } catch (err) {
      print(err);
    }
    return null;
  }
}
