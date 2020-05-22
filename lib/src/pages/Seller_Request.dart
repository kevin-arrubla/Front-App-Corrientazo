import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/controllers/Seller_Controller.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/services/Validators.dart';

class SellerRequestPage extends StatefulWidget {
  @override
  _SellerRequestPageState createState() => _SellerRequestPageState();
}

class _SellerRequestPageState extends State<SellerRequestPage> {
  
  SellerRequestController seller;
  TextEditingController email;
  Alerts alert;
  Validators validator;

  _SellerRequestPageState() {
    validator = Validators();
    alert = Alerts();
    seller = SellerRequestController();
    email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          children: <Widget>[
            _createHeader(),
            _createLabel(),
            _createInputEmail(),
            _createButton(),
          ],
        ),
      ),
    );
  }

  Widget _createHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 190,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF44336), Color(0xFFF44336)]),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)]),
      child: ListView(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            alignment: Alignment.bottomLeft,
            iconSize: 30.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Image.asset('assets/img1/logo1.png'),
          ),
        ],
      ),
    );
  }

  Widget _createInputEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              hintText: 'Correo Electrónico',
              labelText: 'Email',
              suffixIcon: Icon(Icons.email, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
        ),
      ),
    );
  }

  Widget _createLabel() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          'Digite los siguientes datos :',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Berlin Sans FB Demi',
              fontSize: 20),
        ),
      ),
    );
  }

  Widget _createButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
            gradient:
                LinearGradient(colors: [Color(0xFFF44336), Color(0xFFF44336)]),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: RaisedButton(
          child: Text('Aceptar'.toUpperCase()),
          color: Colors.red,
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: () {
            if (_validate()) {
              seller.request(context, {'email': email.text});
            }
          },
        ),
      ),
    );
  }

  bool _validate() {
    bool res = true;
    if (!validator.validateText(email.text)) {
      res = false;
      alert.errorAlert(context, 'Debe diligenciar todos los campos');
    } else if (!validator.validateEmail(email.text)) {
      res = false;
      alert.errorAlert(context,
          'Email incorrecto, intente con otro : ej. Usuario@gmail.com');
    }

    return res;
  }
}
