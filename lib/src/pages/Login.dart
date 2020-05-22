import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/controllers/Login_Controller.dart';
import 'package:front_app_corrientazo/src/controllers/Reset_Controller.dart';
import 'package:front_app_corrientazo/src/controllers/Seller_Controller.dart';
import 'package:front_app_corrientazo/src/controllers/SignIn_Controller.dart';
import 'package:front_app_corrientazo/src/pages/Sign_In.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/services/Validators.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  SellerRequestController sellerRequest = SellerRequestController();
  LoginController loginController = LoginController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Validators validator = Validators();
  Alerts alert = Alerts();
  ResetController resetController = ResetController();
  SignInController signInController = SignInController();
  TextEditingController passwordConfirm = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController document = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img1/fondo.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.hardLight)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView(
                children: <Widget>[
                  _createHeader(),
                  Center(
                      child:
                          Image(image: AssetImage('assets/img1/logotipo.png'))),
                  _createInputEmail(),
                  _createInputPassword(),
                  _createButtonLogin(),
                  _createFlattButtonRegister('Registrate Aquí!!', 'registry'),
                  _createFlattButtonNewPassword(
                      'Olvido La Contraseña', 'reset'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createHeader() {
    return ListTile(
        leading: MaterialButton(
      child: Text(
        'Quiero Ser Vendedor',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        seller(context);
      },
    ));
  }

  Widget _createInputEmail() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "  Usuario o Correo",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createInputPassword() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: '  Contraseña',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.lock_open, color: Colors.white)),
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createButtonLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          height: 60,
          child: Center(
            child: MaterialButton(
              height: 50,
              minWidth: 300,
              color: Colors.red,
              onPressed: () {
                if (_validate()) {
                  loginController.login(context, {
                    'authEmail': email.text.toLowerCase(),
                    'authPassword': password.text
                  });
                }
              },
              child: Text('ENTRAR',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createFlattButtonRegister(String text, String route) {
    text = text;
    route = route;
    return MaterialButton(
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Berlin Sans FB Demi',
            fontSize: 22,
            color: Colors.white.withAlpha(1000)),
      ),
      onPressed: () {
        final route = MaterialPageRoute(builder: (context) {
          return SingInPage();
        });
        Navigator.push(context, route);
      },
    );
  }

  Widget _createFlattButtonNewPassword(String text, String route) {
    text = text;
    route = route;
    return MaterialButton(
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Berlin Sans FB Demi',
            fontSize: 22,
            color: Colors.white.withAlpha(1000)),
      ),
      onPressed: () {
        newpassword(context);
      },
    );
  }

  bool _validate() {
    bool res = true;
    if (!validator.validateText(email.text) ||
        !validator.validateText(password.text)) {
      res = false;
      alert.errorAlert(
          context, 'No se ha podido iniciar sesión, revise sus credenciales');
    } else if (!validator.validateEmail(email.text)) {
      res = false;
      alert.errorAlert(
          context, 'No se ha podido iniciar sesión, revise sus credenciales ');
    }
    return res;
  }

  void seller(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 130),
                      child: AlertDialog(
                        title: Center(child: Text('DILIGENCIE LOS CAMPOS')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: "   Correo Electrónico",
                                prefixIcon:
                                    Icon(Icons.email, color: Color(0xFFF44336)),
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            const SizedBox(height: 10.0),
                            MaterialButton(
                              minWidth: 350,
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("Aceptar"),
                              onPressed: () {
                                if (_validate3()) {
                                  // _createDialog(context);
                                  ProgressDialog pr;
                                  pr = new ProgressDialog(context);
                                  pr.style(
                                  message: 'Enviando Correo Electrónico...',
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
                                  Future.delayed(Duration(seconds: 3)).then((value) {
  
                                      });
                                  sellerRequest.request(context,
                                      {'email': email.text}).then((res) {
                                         pr.hide();
                                    setState(() {
                                      email.clear();
                                    });
                                  });
                                }
                              },
                            ),
                            MaterialButton(
                              minWidth: 350,
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void newpassword(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 130),
                      child: AlertDialog(
                        title: Center(child: Text('RESTABLECER CONTRASEÑA')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: email,
                              decoration: InputDecoration(
                                hintText: "   Correo Electrónico",
                                prefixIcon:
                                    Icon(Icons.email, color: Color(0xFFF44336)),
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              obscureText: true,
                              controller: document,
                              decoration: InputDecoration(
                                hintText: "   Documento",
                                prefixIcon: Icon(Icons.security,
                                    color: Color(0xFFF44336)),
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            const SizedBox(height: 10.0),
                            MaterialButton(
                              minWidth: 350,
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("Aceptar"),
                              onPressed: () {
                                if (_validate2()) {
                                  resetController.reset(context, {
                                    'authEmail': email.text.toLowerCase(),
                                    'userIdentification': document.text
                                  }).then((res) {
                                    setState(() {
                                      email.clear();
                                      document.clear();
                                    });
                                  });
                                }
                              },
                            ),
                            MaterialButton(
                              minWidth: 350,
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  bool _validate2() {
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

  bool _validate3() {
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
