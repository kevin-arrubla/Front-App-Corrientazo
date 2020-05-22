import 'package:flutter/material.dart';
import 'dart:math';
import 'package:front_app_corrientazo/src/pages/Payment_Method.dart';
import 'package:front_app_corrientazo/src/providers/Payment_Providers.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/providers/subscription_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class ListSubscription extends StatefulWidget {
  final String total;
  ListSubscription({this.total});

  @override
  _ListSubscriptionState createState() =>
      _ListSubscriptionState(total: this.total);
}

class _ListSubscriptionState extends State<ListSubscription> {
  final Set<String> _saved = Set<String>();
  SubscriptionProvider subscriptionProvider;
  UserInformation userInformation;
  PaymentProviders paymentProviders;
  OrdersProviders ordersProviders;
  Alerts alerts;
  Token token;

  List itemNameRestaurant = [];
  List itemCredit = [];
  List itemSubId = [];

  List subscriptionList = [];
  List creditList = [];
  List listOrserAll;
  Map userData = {};
  int balance;
  String direction;
  String restId;
  List<String> subIds;
  int counter;

  var credit;
  var idPayment;
  final String total;

  _ListSubscriptionState({this.total}) {
    subIds = [];
    subscriptionProvider = SubscriptionProvider();
    userInformation = UserInformation();
    paymentProviders = PaymentProviders();
    ordersProviders = OrdersProviders();
    alerts = Alerts();
    token = Token();
    balance = 0;
    counter = 0;
  }

  Future listSubscriptionUser() async {
    userData = await userInformation.getUserInformation();
    await token.getString('direction').then((res) {
      setState(() {
        direction = res;
      });
    });
    await token.getString('restId').then((res) {
      setState(() {
        restId = res;
      });
    });
    subscriptionProvider.getSubscriptionsByUser(userData['userId']).then((res) {
      setState(() {
        subscriptionList = res;
        for (var i = 0; i < subscriptionList.length; i++) {
          String converterString = subscriptionList[i]['restId'].toString();
          if (converterString == restId) {
            itemNameRestaurant.add(subscriptionList[i]['namerestaurant']);
            itemCredit.add(subscriptionList[i]['credit']);
            itemSubId.add(subscriptionList[i]['subId']);
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listSubscriptionUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Mis Suscripciones'),
      ),
      body: Container(
        color: Colors.black.withOpacity(0.06),
        child: CustomScrollView(
          slivers: <Widget>[
            Container(
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return buildList(
                        context,
                        itemNameRestaurant[index],
                        itemCredit[index].toString(),
                        itemSubId[index].toString());
                  },
                  childCount: itemSubId.length == null ? 0 : itemSubId.length,
                ),
              ),
            ),
          ],
        ),
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
            methodPaymentSelect();
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

  Widget buildList(BuildContext context, String nameRestaurant, String credit,
      String subId) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[check(subId, nameRestaurant, credit)],
            ),
          ),
        ],
      ),
    );
  }

  Widget check(String subId, nameRestaurant, String credit) {
    final bool alreadySaved = _saved.contains(subId);
    return ListTile(
      title: Text(
        nameRestaurant,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 22),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '\$' + credit,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
      ),
      leading: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 3, color: Colors.black.withOpacity(0.03)),
          image: DecorationImage(
              image: AssetImage('assets/img1/fondo2.jpg'), fit: BoxFit.fill),
        ),
      ),
      trailing: Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Color(0xFFF44336) : Color(0xFFF44336),
        size: 30,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            subIds.remove(subId);
            _saved.remove(subId);
          } else {
            subIds.add(subId);
            _saved.add(subId);
          }
        });
      },
    );
  }

  void methodPaymentSelect() async {
    for (var i = 0; i < subIds.length; i++) {
      await subscriptionProvider.getBalance(subIds[i].toString()).then((res) {
        setState(() {
          var converterInt = int.parse(res[0]['credit'].toString());
          creditList.add(converterInt);
          balance = balance + converterInt;
          counter++;
        });
      });
    }
    if (balance > 0) {
      var result = int.parse(total);
      if (balance > result) {
        var value;
        for (var i = 0; i < counter; i++) {
          if (i == 0) {
            if (counter > 1) {
              subscriptionProvider.updateBalance(subIds[i], {'credit': '0'});
            } else {
              value = balance - result;
              subscriptionProvider
                  .updateBalance(subIds[i], {'credit': '$value'}).then((res) {
                setState(() {
                  finishPayment();
                });
              });
            }
          } else {
            if (i < counter) {
              if (counter == i + 1) {
                value = balance - result;
                subscriptionProvider
                    .updateBalance(subIds[i], {'credit': '$value'}).then((res) {
                  setState(() {
                    finishPayment();
                  });
                });
              } else {
                subscriptionProvider.updateBalance(subIds[i], {'credit': '0'});
              }
            }
          }
        }
      } else {
        if (balance == result) {
          for (var i = 0; i < counter; i++) {
            if (i == 0) {
              if (counter > 1) {
                subscriptionProvider.updateBalance(subIds[i], {'credit': '0'});
              } else {
                subscriptionProvider
                    .updateBalance(subIds[i], {'credit': '0'}).then((res) {
                  setState(() {
                    finishPayment();
                  });
                });
              }
            } else {
              if (i < counter) {
                if (counter == i + 1) {
                  subscriptionProvider
                      .updateBalance(subIds[i], {'credit': '0'}).then((res) {
                    setState(() {
                      finishPayment();
                    });
                  });
                } else {
                  subscriptionProvider
                      .updateBalance(subIds[i], {'credit': '0'});
                }
              }
            }
          }
        } else {
          alerts.errorAlert(context, 'Credito no es Suficiente');
          Future.delayed(Duration(seconds: 1)).then((resp) {
            final route = MaterialPageRoute(builder: (context) {
              return PaymentMethod(value: total);
            });

            Navigator.push(context, route);
          });
        }
      }
    } else {
      alerts.errorAlert(context, 'Credito no es Suficiente');
      Future.delayed(Duration(seconds: 1)).then((resp) {
        final route = MaterialPageRoute(builder: (context) {
          return PaymentMethod(value: total);
        });

        Navigator.push(context, route);
      });
    }
  }

  Future finishPayment() async {
    var rng = new Random();
    for (var i = 0; i < 1; i++) {
      idPayment = rng.nextInt(1000000000);
    }

    ordersProviders.orderAll(userData['userId']).then((res) async {
      setState(() {
        listOrserAll = res;
        print('que paso');
        print(listOrserAll);
      });

      var counter = listOrserAll.length;
      var paymentIdTransations = idPayment.toString();

      var paymentId = await paymentProviders.createPayment({
        'userId': userData['userId'].toString(),
        'paymentIdTransations': '&Subc_' + paymentIdTransations + '&',
        'description': 'Pago a Restaurante',
        'paymentMethod': 'Suscripcion',
        'amount': total,
        'email': userData['email'].toString()
      });

      for (var i = 0; i < counter; i++) {
        print(listOrserAll[i]['orderId']);
        print(paymentId['idPayment']);

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
  }
}
