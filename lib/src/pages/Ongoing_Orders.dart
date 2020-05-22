import 'package:flutter/material.dart';
import 'dart:async';
import 'package:front_app_corrientazo/src/pages/Search_Restaurant.dart';
import 'package:front_app_corrientazo/src/pages/historyRequestDetail.dart';
import 'package:front_app_corrientazo/src/providers/ListOrders_Providers.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';

class OrgoingOrdersPage extends StatefulWidget {
  OrgoingOrdersPage();
  @override
  _OrgoingOrdersPageState createState() => _OrgoingOrdersPageState();
}

class _OrgoingOrdersPageState extends State<OrgoingOrdersPage> {
  ListOrdersProviders listOrdersProviders;
  UserInformation userInformation;
  Alerts alerts;
  List orders;
  String ongoingorders = 'ABIERTO';
  Map userData;

  _OrgoingOrdersPageState() {
    userInformation = UserInformation();
    listOrdersProviders = ListOrdersProviders();
    userData = {};
    orders = [];
    alerts = Alerts();
  }
  Future ongoindOrderUser() async {
    userData = await userInformation.getUserInformation();
    listOrdersProviders.getOrdersByUser(
        userData['userId'], {'state': ongoingorders}).then((res) {
      setState(() {
        orders = res;
        if (orders.toString() == '[]') {
          alerts.errorAlert(context, 'Usted no tiene pedidos pendientes');
          Future.delayed(Duration(seconds: 2)).then((res) {
            Navigator.popAndPushNamed(context, 'search');
          });
        }
      });
    });
  }

  Future refresh() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      ongoindOrderUser();
    });
    return Future.delayed(duration);
  }

  @override
  void initState() {
    super.initState();
    ongoindOrderUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pedidos en curso'),
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            color: Colors.white,
            onPressed: () {
              final route = MaterialPageRoute(builder: (context) {
                return SearchRestaurantPage();
              });
              Navigator.push(context, route);
            },
          ),
        ),
        body: Container(
          child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                children: <Widget>[
                  _listOrders(),
                ],
              )),
        ));
  }

  Widget _listOrders() {
    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: orders == null ? 0 : orders.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardOrder(
              context,
              orders[index]['created_at'].toString().split('T')[0],
              orders[index]['created_at']
                  .toString()
                  .split('T')[1]
                  .split('.')[0],
              orders[index]['namerestaurant'],
              orders[index]['address'],
              orders[index]['state'].toString(),
              orders[index]['orderId'].toString());
        });
  }

  Widget _cardOrder(context, String fecha, String hora, String nameRestaurant,
      String address, String state, String orderId) {
    Color colorSend = Colors.grey;
    Color colorProcess = Colors.grey;
    Color colorRequired = Colors.grey;

    if (state == 'SOLICITADO') {
      colorRequired = Colors.green;
    } else if (state == 'ACEPTADO') {
      colorProcess = Colors.green;
    } else if (state == 'ENVIADO') {
      colorSend = Colors.green;
    }
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          elevation: 20.0,
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.local_dining),
                        tooltip: 'En Espera',
                        color: colorRequired,
                        onPressed: () {}),
                    Text('En espera')
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.rotate_right),
                        tooltip: 'En Preparación',
                        color: colorProcess,
                        onPressed: () {}),
                    Text('En Proceso')
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.motorcycle),
                        tooltip: 'Enviado a entrega',
                        color: colorSend,
                        onPressed: () {}),
                    Text('Enviado')
                  ],
                ),
              ],
            ),
            Divider(
              color: Colors.blue,
              indent: 30.0,
              endIndent: 20.0,
            ),
            ListTile(
              title: Text(
                'Número de pedido : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$orderId',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Solicitado a: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$nameRestaurant',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Fecha de pedido : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                ' $fecha',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            FlatButton(
              onPressed: () {
                final route = MaterialPageRoute(builder: (context) {
                  return HistoryRequestDetail(orderId: orderId, state: state);
                });
                Navigator.push(context, route);
              },
              child: Text('Ver Detalle',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          ]),
        ),
      ),
    );
    return list;
  }
}
