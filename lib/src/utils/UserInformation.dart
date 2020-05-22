import 'package:flutter/cupertino.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class UserInformation {
  Token token;

  UserInformation() {
    token = new Token();
  }

  void userData(body, data) {
    token.setToken(body['token']);
    token.setString('userId', body['Id'].toString());
    token.setString('email', data['authEmail'].toString());
    token.setString('password', data['authPassword'].toString());
  }

  Future<Map> getUserInformation() async {
    final userdata = {
      'userId': await token.getString('userId'),
      'email': await token.getString('email'),
      'password': await token.getString('password'),
    };
    return userdata;
  }

  Future signOff(context) {
    token.setToken('');
    token.setString('userId', '');
    token.setString('email', '');
    token.setString('password', '');
    token.setString('direction', '');
    token.setString('city', '');
    return Navigator.pushReplacementNamed(context, 'login');
  }
}
