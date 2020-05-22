import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_corrientazo/src/services/HttpClient.dart';
import 'package:front_app_corrientazo/src/configs/url_gateway.dart';

class SellerProvider{
  String url= Uri().getUri();
  HttpClient http;
  String uri ;


SellerProvider(){
  
  http = HttpClient();
  uri='$url/user/email';

}

Future<Map> request(data) async {

  Map user;
  try {
    Response res = await http.post('$uri',data);
    user = jsonDecode(res.body);
  }catch (err){
    print(err);
  }
  return user;
}
}