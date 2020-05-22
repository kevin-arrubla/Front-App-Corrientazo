import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Direction.dart';
import 'package:front_app_corrientazo/src/pages/List_Subscription.dart';
import 'package:front_app_corrientazo/src/pages/Today_Menu.dart';
import 'package:front_app_corrientazo/src/providers/Payment_Providers.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/providers/subscription_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:front_app_corrientazo/src/pages/Payment_WebView.dart';
import 'dart:math';

class PaymentMethod extends StatefulWidget {
  final String value;

  PaymentMethod({this.value});

  @override
  _PaymentMethod createState() => _PaymentMethod(value: this.value);
}

class _PaymentMethod extends State<PaymentMethod> {
  SubscriptionProvider subscriptionProvider;
  PaymentProviders paymentProviders;
  OrdersProviders ordersProviders;
  UserInformation userInformation;
  ProgressDialog progressDialog;
  Token token;

  Alerts alerts;
  Map userData;
  String city;
  String direction;
  String restid;
  String nameRestaurant;

  final String value;
  var total;
  var idPayment;

  List subscriptionList;
  List listOrserAll;
  int methodPayment;
  int c = 0;
  bool activate;

  setSelectedRadio(int val) {
    setState(() {
      methodPayment = val;
    });
  }

  _PaymentMethod({this.value}) {
    userInformation = UserInformation();
    subscriptionProvider = SubscriptionProvider();
    paymentProviders = PaymentProviders();
    ordersProviders = OrdersProviders();
    alerts = Alerts();
    token = Token();
    subscriptionList = [];
    userData = {};
    activate = false;
    var v = int.parse(value);
    total = v;
  }

  Future paymentMethodUser() async {
    userData = await userInformation.getUserInformation();

    await token.getString('direction').then((res) {
      setState(() {
        direction = res;
      });
    });
    await token.getString('city').then((res) {
      setState(() {
        city = res;
      });
    });

    await token.getString('restId').then((res) {
      setState(() {
        restid = res;
      });
    });

    await token.getString('restaurantName').then((res) {
      setState(() {
        nameRestaurant = res;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    methodPayment = 0;
    paymentMethodUser();
  }

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Iniciando Metodo de pago',
      borderRadius: 15.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 20.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
    );
  }

  void methodPaymentSelect() async {
    if (methodPayment == 1) {
      print('EFECTIVO');
      var rng = new Random();
      for (var i = 0; i < 1; i++) {
        idPayment = rng.nextInt(1000000000);
      }
      ordersProviders.orderAll(userData['userId']).then((res) async {
        setState(() {
          listOrserAll = res;
        });

        var counter = listOrserAll.length;

        var paymentIdTransations = idPayment.toString();

        var paymentId = await paymentProviders.createPayment({
          'userId': userData['userId'].toString(),
          'paymentIdTransations': '&Efec_' + paymentIdTransations + '&',
          'description': 'Pago a Restaurante',
          'paymentMethod': 'Efectivo',
          'amount': total,
          'email': userData['email'].toString()
        });

        for (var i = 0; i < counter; i++) {
          paymentProviders.createPaymentDetail({
            'paymentId': paymentId['idPayment'],
            'orderId': listOrserAll[i]['orderId']
          });
        }
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
      });
    } else {
      if (methodPayment == 2) {
        print('TARGETA');
        paymentProviders.create({
          'name': 'Usuario',
          "sku": userData['userId'].toString(),
          'price': total,
          'total': total,
          'description': 'Pago',
          'email': userData['email'].toString(),
        }).then((url) {
          if (url.toString() == 'null') {
            alerts.successAlert(context, 'ERROR DE CONEXION');
          } else {
            progress();
            progressDialog.show();
            token.setStringPayment('url', url);
            Future.delayed(Duration(seconds: 3)).then((value) {
              progressDialog.hide().whenComplete(() {
                final route = MaterialPageRoute(builder: (context) {
                  return PaymentWeb(
                    amountPayment: total.toString(),
                  );
                });
                Navigator.push(context, route);
              });
            });
          }
        });
      } else {
        if (methodPayment == 3) {
          print('SUSCRIPCION');
          subscriptionProvider
              .getSubscriptionsByUser(userData['userId'])
              .then((res) {
            setState(() {
              subscriptionList = res;
              var counter = subscriptionList.length;
              if (counter > 0) {
                c = 0;
                for (var i = 0; i < counter; i++) {
                  String converterString =
                      subscriptionList[i]['restId'].toString();
                  if (converterString == restid) {
                    c++;
                    final route = MaterialPageRoute(builder: (context) {
                      return ListSubscription(total: total.toString());
                    });
                    Navigator.push(context, route);
                  }
                }
                if (c < 1) {
                  alerts.errorAlert(context,
                      'No hay suscripciones en el Restaurante $nameRestaurant');
                }
              } else {
                alerts.errorAlert(context,
                    'No hay suscripciones en el Restaurante $nameRestaurant');
              }
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAGOS'),
        backgroundColor: Color(0xFFF44336),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              final route = MaterialPageRoute(builder: (context) {
                return TodayMenuPage();
              });
              Navigator.push(context, route);
            }),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _list1();
              },
              childCount: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _list2();
              },
              childCount: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _list3();
              },
              childCount: 1,
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white70,
        height: 125,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('TOTAL A PAGAR',
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900)),
              subtitle: Text('Metodo de pago',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700)),
              trailing: Text(
                'VALOR: $total',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 180.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (activate == false) {
              alerts.errorAlert(context, 'Seleccione su Metodo de Pago');
            } else {
              methodPaymentSelect();
            }
          },
          label: Text(
            'CONTINUAR',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          backgroundColor: Color(0xFFF44336),
        ),
      ),
    );
  }

  Widget _list1() {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(5)),
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Dirección: ' + '$direction'),
                subtitle: Text('Ciudad: ' + '$city'),
                trailing: Icon(Icons.edit, color: Color(0xFFF44336), size: 35),
              )
            ],
          ),
        ),
      ),
    );
    return GestureDetector(
      child: list,
      onTap: () {
        final route = MaterialPageRoute(builder: (context) {
          return DirectionPage(
            value: value,
          );
        });
        Navigator.push(context, route);
      },
    );
  }

  Widget image() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('assets/img2/frijolada.jpg'),
    );
  }

  Widget _list2() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(5)),
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Seleccione Metodo de Pago',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Divider(
                endIndent: 30,
                indent: 30,
                thickness: 3,
              ),
              RadioListTile(
                value: 1,
                groupValue: methodPayment,
                onChanged: (val) {
                  activate = true;
                  print('value radio 1 $val');
                  setSelectedRadio(val);
                },
                title: Text(
                  'Efectivo',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      fontSize: 25.0),
                ),
                secondary: Icon(Icons.attach_money,
                    color: Color(0xFFF44336), size: 40),
                activeColor: Colors.red,
                selected: true,
              ),
              RadioListTile(
                value: 2,
                groupValue: methodPayment,
                onChanged: (val) {
                  activate = true;
                  print('value radio 2 $val');
                  setSelectedRadio(val);
                },
                title: Text(
                  'Paypal',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      fontSize: 25.0),
                ),
                secondary:
                    Icon(Icons.credit_card, color: Color(0xFFF44336), size: 35),
                activeColor: Colors.red,
                selected: false,
              ),
              RadioListTile(
                value: 3,
                groupValue: methodPayment,
                onChanged: (val) {
                  activate = true;
                  print('value radio 3 $val');
                  setSelectedRadio(val);
                },
                title: Text(
                  'Suscripcion',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      fontSize: 25.0),
                ),
                secondary: Icon(Icons.subscriptions,
                    color: Color(0xFFF44336), size: 35),
                activeColor: Colors.red,
                selected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list3() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(5)),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Center(
                    child: Text(
                  'RESUMEN DE LA ORDEN',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
                )),
                SizedBox(height: 10),
                ListTile(
                  title: Text(
                    'Pedido',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 17.0),
                  ),
                  subtitle: Text(
                    'Productos',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 25.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.shopping_cart,
                        color: Color(0xFFF44336), size: 35),
                    onPressed: () {},
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                  thickness: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
