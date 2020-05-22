import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Ongoing_Orders.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';

class HistoryRequestDetail extends StatefulWidget {
  final String orderId;
  final String state;
  HistoryRequestDetail({this.orderId, this.state});

  @override
  _HistoryRequestDetailState createState() =>
      _HistoryRequestDetailState(orderId: this.orderId, state: this.state);
}

class _HistoryRequestDetailState extends State<HistoryRequestDetail> {
  
  OrdersProviders ordersProvider;

  final String orderId;
  final String state;

  var menuName;
  var value;
  var address;

  List orderDetail;
  Map order;

  _HistoryRequestDetailState({this.orderId, this.state}) {
    ordersProvider = OrdersProviders();
    menuName= '';
    value = '';
    address = '';
  }

  Future historyRequestDeatilUser() async {
    ordersProvider.getOrderActive(orderId).then((res) {
      setState(() {
        order = res;
        menuName = order['menuName'];
        address = order['address'];
        value = order['price'];
        orderDetail = order['orderDetail'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    historyRequestDeatilUser();
  }

  Widget textSubname() {
    return ListView.builder(
      physics: new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: orderDetail == null ? 0 : orderDetail.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text(orderDetail[index]['subName']));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Descripcion del pedido'),
          backgroundColor: Colors.red,
          leading: IconButton(
            padding: const EdgeInsets.only(right: 25),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            color: Colors.white,
            onPressed: () {
              final route = MaterialPageRoute(builder: (context) {
                return OrgoingOrdersPage();
              });
              Navigator.push(context, route);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 9.0,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.fastfood,
                      size: 80,
                      color: Colors.red,
                    ),
                    ListTile(
                      title: Text('Menú :  $menuName',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Berlin Sans FB Demi',
                              fontSize: 20)),
                    ),
                    ListTile(
                      title: Text('Precio: $value ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Berlin Sans FB Demi',
                              fontSize: 20)),
                    ),
                    ListTile(
                      title: Text(
                        'Direccion : $address ',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Berlin Sans FB Demi',
                            fontSize: 20),
                      ),
                    ),
                    ListTile(
                      title: Text('Su Elección fue: ',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Berlin Sans FB Demi',
                              fontSize: 34)),
                    ),
                    textSubname(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.green,
                            iconSize: 60.0,
                            onPressed: () {
                              if (state == 'ENVIADO') {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Image.asset(
                                                  'assets/img1/logoD.png'),
                                            ),
                                            Text('Ya recibió el pedido ?',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Berlin Sans FB Demi',
                                                    fontSize: 20)),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('SI',
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                              onPressed: () {
                                                ordersProvider.updateOrder(
                                                    state,
                                                    orderId,
                                                    {'state': 'RECIBIDO'});
                                                final route = MaterialPageRoute(
                                                    builder: (context) {
                                                  return OrgoingOrdersPage();
                                                });
                                                Navigator.push(context, route);
                                              }),
                                          FlatButton(
                                              child: Text('NO',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Image.asset(
                                                  'assets/img1/logoD.png'),
                                            ),
                                            Text(
                                                'El pedido no se ha enviado a entrega, no se puede marcar como recibido',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Berlin Sans FB Demi',
                                                    fontSize: 20)),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    });
                              }
                            }),
                        IconButton(
                            icon: Icon(Icons.clear),
                            color: Colors.red,
                            iconSize: 60.0,
                            onPressed: () {
                              if (state == 'SOLICITADO') {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Image.asset(
                                                  'assets/img1/logoD.png'),
                                            ),
                                            Text(
                                                'Seguro que desea cancelar el pedido ?',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Berlin Sans FB Demi',
                                                    fontSize: 20)),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('SI',
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                              onPressed: () {
                                                ordersProvider.updateOrder(
                                                    state,
                                                    orderId,
                                                    {'state': 'CANCELADO'});
                                                final route = MaterialPageRoute(
                                                    builder: (context) {
                                                  return OrgoingOrdersPage();
                                                });
                                                Navigator.push(context, route);
                                              }),
                                          FlatButton(
                                              child: Text('NO',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Image.asset(
                                                  'assets/img1/logoD.png'),
                                            ),
                                            Text(
                                                'El pedido ya está en proceso, no se puede cancelar',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Berlin Sans FB Demi',
                                                    fontSize: 20)),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    });
                              }
                            })
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
