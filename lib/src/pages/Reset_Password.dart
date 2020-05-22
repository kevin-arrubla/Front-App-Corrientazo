import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/controllers/Reset_Controller.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/services/Validators.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  
  ResetController resetController;
  Validators validator;
  TextEditingController email;
  TextEditingController document;
  Alerts alert;

  _ResetPageState() {
    resetController = ResetController();
    validator = Validators();
    email = TextEditingController();
    document = TextEditingController();
    alert = Alerts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "|  Correo Electrónico",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email, color: Color(0xFFF44336)),
            ),
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: document,
            decoration: InputDecoration(
              hintText: "|  Documento de Identidad",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.security, color: Color(0xFFF44336)),
            ),
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          const SizedBox(height: 10.0),
          RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(),
            child: Text("Aceptar"),
            onPressed: () {
              if (_validate(context)) {
                resetController.reset(context, {
                  'authEmail': email.text.toLowerCase(),
                  'userIdentification': document.text
                });
              }
            },
          ),
        ],
      ),
    );
  }

  bool _validate(BuildContext context) {
    bool res = true;
    if (!validator.validateText(email.text)) {
      res = false;
      alert.errorAlert(context, 'Debe diligenciar todos los campos');
    } else if (!validator.validateEmail(email.text)) {
      res = false;
      alert.errorAlert(context, 'Email incorrecto, intente con otro');
    }

    return res;
  }
}
