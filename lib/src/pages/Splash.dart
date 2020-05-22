import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/controllers/Login_Controller.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'dart:async';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  LoginController loginController;
  UserInformation userInformation;

  var email;
  var password;
  
  Map userData;

  _SplashScreenPageState() {
    loginController = LoginController();
    userInformation = UserInformation();
    userData = {};
  }

  Future renovation() async {
    userData = await userInformation.getUserInformation();
    if (userData['email'].toString() == "") {
      Navigator.popAndPushNamed(context, 'login');
    } else {
      email = userData['email'].toString();
      password = userData['password'].toString();
      loginController
          .login(context, {'authEmail': email, 'authPassword': password});
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      renovation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/img1/LogotipoSplash.png'),
                        Padding(padding: EdgeInsets.only(top: 0.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text('Cargando',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.w900)),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
