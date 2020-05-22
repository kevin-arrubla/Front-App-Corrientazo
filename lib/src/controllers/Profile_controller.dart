import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/Profile_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class ProfileController {
  ProfileProvider profileProvider;
  UserInformation userInformation;
  Alerts alert;
  Map userData;
  Token token;

  ProfileController() {
    profileProvider = ProfileProvider();
    userInformation = UserInformation();
    alert = Alerts();
    token = Token();
    userData = {};
  }

  void update(BuildContext context, data) async {
    userData = await userInformation.getUserInformation();
    profileProvider.updateUserById(userData['userId'], data).then((res) {
      if (res == null) {
        alert.errorAlert(context, 'No se ha podido actualizar sus datos');
      } else {
        Navigator.popAndPushNamed(context, 'profile');
      }
    }).catchError((e) {
      print(e);
      alert.errorAlert(context, 'error');
    });
  }

  void changePassword(BuildContext context, data, confirm) async {
    userData = await userInformation.getUserInformation();
    if (confirm == data['authPassword'].toString()) {
      profileProvider.changePassword(userData['userId'], data).then((res) {
        if (res == null) {
          alert.errorAlert(context, 'No se ha podido actualizar su contraseña');
        } else {
          Navigator.popAndPushNamed(context, 'profile');
        }
      }).catchError((e) {
        print(e);
        alert.errorAlert(context, 'error');
      });
    } else {
      alert.errorAlert(context, 'Las Contraseñas no coinciden');
    }
  }
}
