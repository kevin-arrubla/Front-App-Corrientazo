import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/SignIn_Provider.dart';
import 'package:front_app_corrientazo/src/providers/notifications_Providers.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/notifications.dart';

class SignInController {
  SignInProvider signInProvider;
  NotificationsProvider notificationsProvider;
  Notifications notification;
  Alerts alert;
  var id;
  var token;

  SignInController() {
    alert = Alerts();
    signInProvider = SignInProvider();
    notificationsProvider = NotificationsProvider();
    notification = Notifications();
  }
  
  create(BuildContext context, data, String confirm) async {
    if (confirm == data['authPassword'].toString()) {
     
      signInProvider.createUser(data).then((res) async {
        id = res['userId'];
        final token = await notification.initNotifications();
        notificationsProvider.saveNotification(
            {"idUser": id, "tokenNotification": token}).then((res) async {});

        // alert.createUserAlert(
        //     context,
        //     'Usuario :     ' +
        //         res['userName'].toString() +
        //         '    creado correctamente');
      });
    } else {
      alert.errorAlert(context, 'Las Contraseñas no coinciden');
    }
  }
 
}