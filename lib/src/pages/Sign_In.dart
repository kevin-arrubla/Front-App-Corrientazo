import 'package:flutter/material.dart';

import 'package:front_app_corrientazo/src/controllers/signIn_controller.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/services/Validators.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SingInPage extends StatefulWidget {
  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  Alerts alert = Alerts();
  SignInController signInController = SignInController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController document = TextEditingController();
  TextEditingController phone = TextEditingController();
  Validators validator = Validators();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF44336),
          title: Container(
            child: Text(
              'Registro',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        body: ListView(children: <Widget>[
          Center(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[300],
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(2.0, -10.0))
                    ]),
                width: 400,
                height: 200,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 70.0),
                    Icon(
                      Icons.account_circle,
                      size: 100.0,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                )),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              controller: name,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Nombre Completo",
                prefixIcon: Icon(Icons.person, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: document,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Documento De Identificación",
                prefixIcon: Icon(Icons.recent_actors, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: phone,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Teléfono ",
                prefixIcon: Icon(Icons.settings_cell, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Correo Electrónico",
                prefixIcon: Icon(Icons.email, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              obscureText: true,
              controller: password,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Contraseña",
                prefixIcon: Icon(Icons.lock, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              obscureText: true,
              controller: passwordConfirm,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Confirmar Contraseña",
                prefixIcon: Icon(Icons.lock, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: MaterialButton(
                minWidth: 350,
                color: Colors.red,
                textColor: Colors.white,
                child: Text("Aceptar".toUpperCase()),
                onPressed: () {
                  _submit();
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: MaterialButton(
              minWidth: 350,
              color: Colors.red,
              textColor: Colors.white,
              child: Text("CANCELAR"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 20.0),
        ]));
  }

  void _submit() async {
    if (_validation()) {
      final confirm = passwordConfirm.text;
      signInController
          .create(
              context,
              {
                'userName': name.text,
                'userIdentification': document.text,
                'userPhone': phone.text,
                'authEmail': email.text.toLowerCase(),
                'authPassword': password.text
              },
              confirm)
          .then((res) {
        setState(() {});
        // alert.createUserAlert(context, 'Usuario creado correctamente');

        name.clear();
        document.clear();
        phone.clear();
        email.clear();
        password.clear();
        passwordConfirm.clear();
        _createDialog(context);
        Future.delayed(Duration(seconds: 3)).then((value) {
          Navigator.popAndPushNamed(context, 'login');
        });
      });
    }
  }

  void _createDialog(BuildContext context) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Guardando Información...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    pr.show();
    Future.delayed(Duration(seconds: 30)).then((value) {
      pr.hide();
    });
  }

  bool _validation() {
    bool res = true;

    if (!validator.validateText(name.text) ||
        !validator.validateText(document.text) ||
        !validator.validateText(phone.text) ||
        !validator.validateText(email.text) ||
        !validator.validateText(passwordConfirm.text) ||
        !validator.validateText(password.text)) {
      res = false;
      alert.errorAlert(context, 'Debe diligenciar todos los campos');
    } else if (!validator.validateEmail(email.text)) {
      res = false;
      alert.errorAlert(context,
          'Email incorrecto, intente con otro : ej. Usuario@gmail.com');
    } else if (!validator.validatePassword(password.text) ||
        !validator.validatePassword(passwordConfirm.text)) {
      res = false;
      alert.errorAlert(context, 'La contraseña debe tener más de 4 caracteres');
    }

    return res;
  }
}
