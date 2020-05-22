import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/OrdersHistoryDetail.dart';
import 'package:front_app_corrientazo/src/providers/ListOrders_Providers.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';

class OrdersHistoryPage extends StatefulWidget {
  OrdersHistoryPage();

  @override
  _OrdersHistoryPageState createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  UserInformation userInformation;
  ListOrdersProviders listOrdersProviders = ListOrdersProviders();
  Alerts alert;
  List orders;
  Map userData = {};

  _OrdersHistoryPageState() {
    userInformation = UserInformation();
    orders = [];
    alert = Alerts();
  }

  Future orderHistoryUser() async {
    userData = await userInformation.getUserInformation();
    listOrdersProviders
        .getOrdersByUser(userData['userId'], {'state': 'CERRADO'}).then((res) {
      setState(() {
        orders = res;
        if (orders.toString() == '[]') {
          alert.errorAlert(context, 'No Hay Historial de Pedidos');
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
    orderHistoryUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF44336),
          title: Text('Historial de Pedidos'),
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
          child: ListView(
            children: <Widget>[
              _listOrders(),
            ],
          ),
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
            orders[index]['created_at'].toString().split('T')[1].split('.')[0],
            orders[index]['namerestaurant'],
            orders[index]['address'],
            orders[index]['state'].toString(),
            orders[index]['orderId'].toString(),
            orders[index]['restId'].toString());
      },
    );
  }

  Widget _cardOrder(context, String fecha, String hora, String nameRestaurant,
      String address, String state, String orderId, String restId) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(5)),
          elevation: 9.0,
          child: Column(
            children: <Widget>[
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
              Divider(color: Colors.blue),
              ListTile(
                title: Text(
                  'Su Pedido fue: ',
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18),
                ),
                subtitle: Text(
                  ' $state',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Detalle Pedido',
                        style: TextStyle(color: Color(0xFFF44336)),
                      ),
                    ),
                  ),
                ],
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
          return HistoryOrdersDetail(
            orderId: orderId,
          );
        });
        Navigator.push(context, route);
      },
    );
  }
}
