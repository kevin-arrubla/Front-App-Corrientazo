import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/PaymentSubscripion.dart';
import 'package:front_app_corrientazo/src/providers/subscription_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';

class Subscriptions extends StatefulWidget {
  final String idRest;

  Subscriptions({this.idRest});

  @override
  _SubscriptionsState createState() => _SubscriptionsState(idRest: idRest);
}

class _SubscriptionsState extends State<Subscriptions> {
  SubscriptionProvider subscriptionProvider;
  Alerts alerts;

  final String idRest;

  List packages;
  List packagesToShow;
  Map userData;

  _SubscriptionsState({this.idRest}) {
    subscriptionProvider = SubscriptionProvider();
    packages = [];
    packagesToShow = [];
    alerts = Alerts();
  }

  Future subscriptionUser() async {
    subscriptionProvider.getPacksByRestaurant(idRest).then((res) {
      setState(() {
        packages = res;
        if (packages.toString() == '[]') {
          alerts.errorAlert(
              context, 'No hay Paquetes disponibles en este Reataurante');
          Future.delayed(Duration(seconds: 2)).then((res) {
            Navigator.popAndPushNamed(context, 'menu');
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    subscriptionUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista De Paquetes'),
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, 'menu');
            },
          ),
        ),
        body: ListView(children: <Widget>[
          _createLabel(),
          _listPackages(),
        ]));
  }

  Widget _listPackages() {
    for (int i = 0; i < packages.length; i++) {
      if (packages[i]['state'] == 'ACTIVO') {
        packagesToShow.add(packages[i]);
      }
    }
    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: packagesToShow == null ? 0 : packagesToShow.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardPackage(
              packagesToShow[index]['description'],
              packagesToShow[index]['subvalue'].toString(),
              packagesToShow[index]['balance'].toString(),
              packagesToShow[index]['packageId'].toString());
        });
  }

  Widget _cardPackage(
      String description, String value, String balance, String packageId) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          elevation: 20.0,
          child: Column(children: <Widget>[
            Center(
              child: Image(
                image: AssetImage('assets/img1/promociones.jpg'),
              ),
            ),
            Divider(
              color: Colors.blue,
              indent: 30.0,
              endIndent: 20.0,
            ),
            ListTile(
              title: Text(
                'Paquete : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$description',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Número: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$packageId',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Valor a Pagar : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                ' $value',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Valor Recibido : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                ' $balance',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            FlatButton(
              onPressed: () {
                final route = MaterialPageRoute(builder: (context) {
                  return PaymentSubscriptionPage(
                      description: description,
                      balance: balance,
                      value: value,
                      idRest: idRest,
                      packageId: packageId);
                });
                Navigator.push(context, route);
              },
              child: Text('Comprar',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          ]),
        ),
      ),
    );
    return list;
  }

  Widget _createLabel() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          'Suscribase Al Paquete De Su Preferencia',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Berlin Sans FB Demi',
              fontSize: 34,fontWeight: FontWeight.w800),textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
