import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/controllers/Subscription_Controller.dart';
import 'package:front_app_corrientazo/src/providers/subscription_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';

class UserSubscriptionsPage extends StatefulWidget {
  @override
  _UserSubscriptionsState createState() => _UserSubscriptionsState();
}

class _UserSubscriptionsState extends State<UserSubscriptionsPage> {
  UserInformation userInformation;
  SubscriptionProvider subscriptionProvider;
  SubscriptionController subscriptionController;
  Alerts alerts;

  List subscriptions;
  Map userData = {};

  _UserSubscriptionsState() {
    userInformation = UserInformation();
    subscriptionProvider = SubscriptionProvider();
    subscriptionController = SubscriptionController();
    subscriptions = [];
    alerts = Alerts();
  }

  Future subscriptionUser() async {
    userData = await userInformation.getUserInformation();
    await subscriptionProvider
        .getSubscriptionsByUser(userData['userId'])
        .then((res) {
      setState(() {
        subscriptions = res;
        if (subscriptions.toString() == '[]') {
          alerts.errorAlert(context, 'No Tiene Suscripciones');
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
    subscriptionUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Suscripciones'),
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
        body: ListView(children: <Widget>[
          _createLabel(),
          _listSubscriptions(),
        ]));
  }

  Widget _createLabel() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          'Mis Subscripciones',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Berlin Sans FB Demi',
              fontSize: 34),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _listSubscriptions() {
    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: subscriptions == null ? 0 : subscriptions.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardSubscription(
              context,
              subscriptions[index]['namerestaurant'].toString(),
              subscriptions[index]['description'].toString(),
              subscriptions[index]['credit'].toString());
        });
  }

  Widget _cardSubscription(
      context, String restaurant, String description, String balance) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          elevation: 20.0,
          child: Column(children: <Widget>[
            ListTile(
              title: Text(
                'Restaurante : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$restaurant',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Paquete: ',
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
                'Saldo Disponible: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$balance',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
          ]),
        ),
      ),
    );
    return list;
  }
}
