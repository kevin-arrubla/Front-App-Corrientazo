import 'dart:convert';

import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/configs/url_gateway.dart';

class PaymentProviders {
  String url = Uri().getUri();
  HttpClient http;
  String uri;

  PaymentProviders() {
    http = HttpClient();
    uri = '$url/payment';
  }

  Future<String> create(data) async {
   
    try {
      Response res = await http.post('$uri/create', data);
      print(data);
      final payment = jsonDecode(res.body);
      return payment['link'];
    } catch (err) {
      return null;
    }
    
  }

  Future<bool> success(data) async{
    print('pas por provider success 1');
    try {
      Response res = await http.post('$uri/success', data);
      
      final succes = jsonDecode(res.body);
      
      print('pas por provider success 2');
      print(succes['success']);
      return succes['success'];

    } catch (err) {
    }
    return false;
  }

  Future<Map> createPayment(data) async {
    Map payment;
    try {
      Response res = await http.post('$uri/createPayment', data);
      payment = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return payment;
  }

  Future<List> listPayments(userId) async {
    List getListPaymentAll;
    try {
      Response res = await http.get('$uri/getAll/$userId');
      getListPaymentAll = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return getListPaymentAll;
  }

  Future<List> listPaymentDetail(paymentId) async {
    List getListPaymentDetailAll;
    try {
      Response res = await http.get('$uri/getDetailAll/$paymentId');
      getListPaymentDetailAll = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return getListPaymentDetailAll;
  }

  Future<Map> createPaymentDetail(data) async {
    Map paymentDetail;
    try {
      Response res = await http.post('$uri/createPaymentDetail', data);
      paymentDetail = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return paymentDetail;
  }
}
