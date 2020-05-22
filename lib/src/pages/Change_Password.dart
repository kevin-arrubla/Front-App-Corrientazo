import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/controllers/Profile_controller.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage();

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  UserInformation userInformation;
  ProfileController profileController;
  TextEditingController password;
  TextEditingController newPassword;
  Map userData;

  _ChangePasswordPageState() {
    userInformation = UserInformation();
    profileController = ProfileController();
    password = TextEditingController();
    newPassword = TextEditingController();
    userData = {};
  }

  Future changePasswordUser() async {
    userData = await userInformation.getUserInformation();
  }

  @override
  void initState() {
    super.initState();
    changePasswordUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFF44336),
          title: Text('Cambio de Contraseña'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.popAndPushNamed(context, 'profile');
              // final route = MaterialPageRoute(builder: (context) {
              //   return ProfilePage();
              // });
              // Navigator.push(context, route);
            },
          )),
      body: ListView(
        children: <Widget>[
          _createInputText('Nueva Contraseña',
              Icon(Icons.lock, color: Colors.red), password),
          _createInputText('Confirme la contraseña',
              Icon(Icons.lock_open, color: Colors.red), newPassword),
          _createButton(),
        ],
      ),
    );
  }

  Widget _createInputText(
      String hintext, Icon icon, TextEditingController control) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: TextFormField(
              controller: control,
              cursorColor: Colors.red,
              decoration: InputDecoration(
                hintText: hintext,
                icon: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createButton() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: OutlineButton(
          highlightedBorderColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          child: Text('Guardar Cambios'),
          onPressed: () {
            profileController.changePassword(
                context,
                {'authEmail': userData['email'], 'authPassword': password.text},
                newPassword.text);
          },
        ),
      ),
    ]);
  }
}
