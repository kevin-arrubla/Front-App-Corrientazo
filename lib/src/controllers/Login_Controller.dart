import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/Login_Provider.dart';
import 'package:front_app_corrientazo/src/providers/notifications_Providers.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/notifications.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class LoginController {
  LoginProvider loginProvider;
  Alerts alert;
  NotificationsProvider notificationsProvider;
  Notifications notification;
  UserInformation userInformation;
  Token tokens;
  String direction;

  LoginController() {
    userInformation = UserInformation();
    alert = Alerts();
    tokens = Token();
    loginProvider = LoginProvider();
    notificationsProvider = NotificationsProvider();
    notification = Notifications();
  }

  void login(BuildContext context, data) {
    tokens.getString('direction').then((res) {
      direction = res;
    });
    loginProvider.login(data).then((res) async {
      var id = res['Id'];
      final token = await notification.initNotifications();
      notificationsProvider.updateNotification(
          id, {"tokenNotification": token}).then((res) async {});
      if (res == null) {
        alert.errorAlert(
            context, 'No se ha podido iniciar sesión, revise sus credenciales');
      } else {
        if (direction == '') {
          userInformation.userData(res, data);
          print('vacia la direccion');
          Navigator.popAndPushNamed(context, 'newdirection');
        } else {
          userInformation.userData(res, data);
          Navigator.pushReplacementNamed(context, 'search');
        }
      }
    }).catchError((e) {
      alert.errorAlert(
          context, 'No se ha podido iniciar sesión, revise sus credenciales');
      Future.delayed(Duration(seconds: 2)).then((value) {
        userInformation.signOff(context);
      });
    });
  }
}
