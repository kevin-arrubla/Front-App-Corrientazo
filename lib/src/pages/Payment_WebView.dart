import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/Payment_Providers.dart';
import 'package:front_app_corrientazo/src/providers/Profile_Provider.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/providers/subscription_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaymentWeb extends StatefulWidget {
  final String idRest;
  final String packageId;
  final String amountPayment;
  final String balance;

  PaymentWeb({this.idRest, this.packageId, this.amountPayment, this.balance});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState(
      idRest: this.idRest,
      packageId: this.packageId,
      amountPayment: this.amountPayment,
      balance: this.balance);
}

class _PaymentWebViewState extends State<PaymentWeb> {
  UserInformation userInformation;
  SubscriptionProvider subscriptionProvider;
  PaymentProviders paymentProviders;
  OrdersProviders ordersProviders;
  FlutterWebviewPlugin flutterWebviewPlugin;
  ProfileProvider profileProvider;
  Alerts alerts;
  Token token;

  final String idRest;
  final String packageId;
  final String amountPayment;
  final String balance;

  String direction;
  List listOrserAll;
  String url;
  int cont;
  Map userData;

  _PaymentWebViewState(
      {this.idRest, this.packageId, this.amountPayment, this.balance}) {
    flutterWebviewPlugin = FlutterWebviewPlugin();
    userInformation = UserInformation();
    profileProvider = ProfileProvider();
    ordersProviders = OrdersProviders();
    subscriptionProvider = SubscriptionProvider();
    paymentProviders = PaymentProviders();
    alerts = Alerts();
    token = Token();
    userData = {};
  }

  @override
  void initState() {
    super.initState();
    paymentWebViewUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Pagos Paypal'),
        ),
        body: url != null
            ? WebviewScaffold(url: url)
            : Text(
                'Cargando...',
                style: TextStyle(fontSize: 60, color: Colors.red),
              ),
      ),
    );
  }

  Future paymentWebViewUser() async {
    userData = await userInformation.getUserInformation();
    cont = 0;

    token.getString('direction').then((res) {
      setState(() {
        direction = res;
      });
    });

    token.getString('url').then((url) {
      setState(() {
        this.url = url;
      });
    });

    flutterWebviewPlugin.onUrlChanged.listen(
      (String url) async {
        if (url.contains('success') && cont < 1) {
          cont++;
          flutterWebviewPlugin.close();
          bool res = await paymentProviders.success({'url': url});
          if (res == null) {
            if (packageId == null) {
              methodPaymentSelect(url, 'Pago a Restaurante', '');
              ordersProviders.updateOrderPayment(userData['userId'],
                  {'state': 'SOLICITADO', 'address': '$direction'}).then((res) {
                if (res == null) {
                  alerts.errorAlert(context, 'ERROR');
                } else {
                  token.setString('restId', '');
                  token.setString('restaurantName', '');

                  alerts.successAlert(context, 'Pago Recibido');
                  Future.delayed(Duration(seconds: 2)).then((resp) {
                    Navigator.pushNamedAndRemoveUntil(context, 'search',
                        (Route<dynamic> route) {
                      print(route);
                      return route.isFirst;
                    });
                  });
                }
              });
            } else {
              subscriptionProvider.createSubscription({
                'userId': userData['userId'].toString(),
                'packageId': packageId,
                'restId': idRest,
                'credit': balance,
              }).then((res) {
                methodPaymentSelect(
                    url, 'Pago Por Suscripción ', res['subId'].toString());
                if (res == null) {
                  alerts.errorAlert(context, 'ERROR');
                } else {
                  alerts.successAlert(context, 'Pago Recibido');
                  Future.delayed(Duration(seconds: 2)).then((resp) {
                    Navigator.pushNamedAndRemoveUntil(context, 'search',
                        (Route<dynamic> route) {
                      print(route);
                      return route.isFirst;
                    });
                  });
                }
              });
            }
          } else {
            alerts.errorAlert(context, 'ERROR EN EL PAGO');
          }
        }
      },
    );
  }

  void methodPaymentSelect(
      String idpayment, String description, String subId) async {
    await ordersProviders.orderAll(userData['userId']).then((res) async {
      setState(() {
        listOrserAll = res;
      });
    });

    print(description);

    var paymentId = await paymentProviders.createPayment({
      'userId': userData['userId'].toString(),
      'paymentIdTransations': idpayment,
      'description': description,
      'paymentMethod': 'Paypal',
      'amount': amountPayment,
      'email': userData['email'].toString()
    });
    var counter = listOrserAll.length;

    if (description.toString() == 'Pago a Restaurante') {
      print('si pasa por pago paypal');
      print(paymentId['idPayment']);
      for (var i = 0; i < counter; i++) {
        paymentProviders.createPaymentDetail(
          {
            'paymentId': paymentId['idPayment'],
            'orderId': listOrserAll[i]['orderId']
          },
        );
      }
    } else {
      paymentProviders.createPaymentDetail(
        {'paymentId': paymentId['idPayment'], 'orderId': subId.toString()},
      );
    }
  }
}
