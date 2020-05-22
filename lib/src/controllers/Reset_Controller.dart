import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/Reset_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';

class ResetController {
  ResetProvider resetProvider;
  Alerts alert;

  ResetController() {
    alert = Alerts();
    resetProvider = ResetProvider();
  }

  reset(BuildContext context, data) {
    resetProvider.resetPassword(data).then((res) {
      if (res == null) {
        alert.errorAlert(context,
            'No se ha podido restablecer su contraseña, revise sus datos');
      } else {
        alert.successLoginAlert(context,
            'Hemos enviado la nueva contraseña a su correo electrónico');
      }
    }).catchError((err) {
      print(err);
      alert.errorAlert(context, 'Error');
    });
  }
}
