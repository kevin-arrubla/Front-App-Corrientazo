import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/Payment_Providers.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class DetailPayment extends StatefulWidget {
  @override
  _DetailPaymentState createState() => _DetailPaymentState();
}

class _DetailPaymentState extends State<DetailPayment> {
  PaymentProviders paymentProviders;
  UserInformation userInformation;
  Map userData;
  Alerts alerts;

  List getListPaymentAll;
  Token token;

  _DetailPaymentState() {
    userInformation = UserInformation();
    paymentProviders = PaymentProviders();
    token = Token();
    userData = {};
    alerts = Alerts();
  }
  Future paymentUser() async {
    userData = await userInformation.getUserInformation();
    paymentProviders.listPayments(userData['userId']).then((res) {
      setState(() {
        getListPaymentAll = res;
        if (getListPaymentAll.toString() == '[]') {
          alerts.errorAlert(context, 'No hay Pagos Realizados');
          Future.delayed(Duration(seconds: 2)).then((res) {
            Navigator.popAndPushNamed(context, 'search');
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    paymentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial De Pagos',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Berlin Sans FB Demi',
                fontSize: 20)),
        backgroundColor: Colors.red,
        leading: FlatButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, 'search');
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        child: CustomScrollView(
          slivers: <Widget>[
            Container(
                child: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Transacción Exitosa",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900),
                            ),
                            Divider(endIndent: 50, indent: 50, thickness: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("FECHA",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900)),
                                Text("HORA",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(getListPaymentAll[index]['created_at']
                                    .toString()
                                    .split('T')[0]),
                                Text(getListPaymentAll[index]['created_at']
                                    .toString()
                                    .split('T')[1]
                                    .split('.')[0])
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("CORREO",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900)),
                                    Text(
                                      getListPaymentAll[index]['email'],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("MONTO",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900)),
                                    Text(
                                        "\$" +
                                            getListPaymentAll[index]['amount'],
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Text(getListPaymentAll[index]['description'],
                                    style: TextStyle(fontSize: 18))
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Container(
                                child: FlatButton(
                                    onPressed: () async {
                                      token.setString(
                                          'paymentId',
                                          getListPaymentAll[index]['paymentId']
                                              .toString());
                                      token.setString(
                                          'pago',
                                          getListPaymentAll[index]
                                                  ['description']
                                              .toString());
                                      Navigator.pushNamed(
                                          context, 'listPaidProduct');
                                    },
                                    child: Text(
                                      'Ver Productos',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ))),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.credit_card),
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        getListPaymentAll[index]
                                            ['paymentMethod'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        getListPaymentAll[index]
                                                ['paymentIdTransations']
                                            .split('&')[1],
                                        style: TextStyle(fontSize: 18),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
                  childCount:
                      getListPaymentAll == null ? 0 : getListPaymentAll.length),
            ))
          ],
        ),
      ),
    );
  }
}
