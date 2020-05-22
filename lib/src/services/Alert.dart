import 'package:flutter/material.dart';

class Alerts {
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();

  void errorAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset('assets/img1/logoD.png'),
                ),
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  void successLoginAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset('assets/img1/logoD.png'),
                ),
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pushNamed(context, 'restaurant'),
              ),
            ],
          );
        });
  }

  void successAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset('assets/img1/logoD.png'),
                ),
                Text(message,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 20),textAlign: TextAlign.center,),
              ],
            ),
            actions: <Widget>[
              // FlatButton(
              //   child: Text('Ok'),
              //   onPressed: () =>
              //       Navigator.pop(context),
              // ),
            ],
          );
        });
  }

  void sellerRequestAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset('assets/img1/logoD.png'),
                ),
                Text(message,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 20),textAlign: TextAlign.center,),
                //FlutterLogo(size: 100.0,)
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
              ),
            ],
          );
        });
  }

  void createUserAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset('assets/img1/logoD.png'),
                ),
                Text(message,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 20),textAlign: TextAlign.center,),
                //FlutterLogo(size: 100.0,)
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
              ),
            ],
          );
        });
  }

  void changePasswordAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Image.asset('assets/img1/logoD.png'),
                ),
                //Text('Digite su contraseña actual',style: TextStyle( color: Colors.black ,fontFamily: 'Berlin Sans FB Demi',fontSize: 20)),
                _createInputPassword(),
                _confirmPassword(),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'login');
                  }),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  Widget _createInputPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 3.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Contraseña',
              labelText: 'Password',
              suffixIcon: Icon(
                Icons.lock_open,
                color: Colors.red,
              ),
              // icon: Icon(Icons.lock, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
        ),
      ),
    );
  }

  Widget _confirmPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 3.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: confirm,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Nueva Contraseña',
              labelText: 'New Password',
              suffixIcon: Icon(
                Icons.lock_open,
                color: Colors.red,
              ),
              // icon: Icon(Icons.lock, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
        ),
      ),
    );
  }
}
