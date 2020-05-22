import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Payment_WebView.dart';
import 'package:front_app_corrientazo/src/pages/Subscriptions.dart';
import 'package:front_app_corrientazo/src/providers/Payment_Providers.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PaymentSubscriptionPage extends StatefulWidget {
  final String description;
  final String balance;
  final String value;
  final String idRest;
  final String packageId;

  PaymentSubscriptionPage(
      {this.description,
      this.balance,
      this.value,
      this.idRest,
      this.packageId});

  @override
  _PaymentSubscriptionPageState createState() => _PaymentSubscriptionPageState(
      description: this.description,
      balance: this.balance,
      value: this.value,
      idRest: this.idRest,
      packageId: this.packageId);
}

class _PaymentSubscriptionPageState extends State<PaymentSubscriptionPage> {
  PaymentProviders paymentProviders;
  UserInformation userInformation;
  ProgressDialog progressDialog;
  Alerts alerts;

  final String description;
  final String balance;
  final String value;
  final String idRest;
  final String packageId;
  var total;

  int methodPayment;
  bool activate;
  Token token;
  Map userData;

  setSelectedRadio(int val) {
    setState(() {
      methodPayment = val;
    });
  }

  _PaymentSubscriptionPageState(
      {this.description,
      this.balance,
      this.value,
      this.idRest,
      this.packageId}) {
    userInformation = UserInformation();
    paymentProviders = PaymentProviders();
    alerts = Alerts();
    userData = {};
    activate = false;
    token = Token();
    total = int.parse(value);
  }

  Future paymentSubscriptionUser() async {
    userData = await userInformation.getUserInformation();
  }

  @override
  void initState() {
    super.initState();
    paymentSubscriptionUser();
    methodPayment = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAGOS'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            final route = MaterialPageRoute(builder: (context) {
              return Subscriptions(
                idRest: idRest,
              );
            });
            Navigator.push(context, route);
          },
        ),
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
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white70,
        height: 125,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('TOTAL A PAGAR', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700)),
              subtitle:
                  Text('Metodo de pago', style: TextStyle(fontSize: 17.0)),
              trailing: Text(
                'VALOR: $value',
                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700),
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
          label: Text('Comprar',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900)),
          backgroundColor: Color(0xFFF44336),
        ),
      ),
    );
  }

  Widget _list1() {
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
                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800),
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
              )
            ],
          ),
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Center(
                    child: Text(
                  'RESUMEN DE LA ORDEN',
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800),
                )),
                SizedBox(height: 15),
                ListTile(
                  title: Text(
                    'Descripcion',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 17.0),
                  ),
                  subtitle: Text(
                    '$description',
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
                SizedBox(height: 15),
                Divider(
                  endIndent: 30,
                  indent: 30,
                  thickness: 3,
                ),
                SizedBox(height: 15),
                ListTile(
                  title: Text(
                    'Valor a Recibir',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 17.0),
                  ),
                  subtitle: Text(
                    '$balance',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 25.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.monetization_on,
                        color: Color(0xFFF44336), size: 35),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void methodPaymentSelect() async {
    if (methodPayment == 1) {
      print('TARGETA');
      paymentProviders.create({
        'name': 'Usuario',
        "sku": userData['userId'].toString(),
        'price': total,
        'total': total,
        'description': 'Pago'
      }).then((url) {
        progress();
        progressDialog.show();
        token.setStringPayment('url', url);
        Future.delayed(Duration(seconds: 3)).then((value) {
          progressDialog.hide().whenComplete(() {
            final route = MaterialPageRoute(builder: (context) {
              return PaymentWeb(
                idRest: idRest,
                packageId: packageId,
                amountPayment: total.toString(),
                balance: balance,
              );
            });
            Navigator.push(context, route);
          });
        });
      });
    } else {
      return null;
    }
  }

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'iniciando metodo de pago',
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
}
