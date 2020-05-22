import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';

class HistoryOrdersDetail extends StatefulWidget {
  final String orderId;
  HistoryOrdersDetail({
    this.orderId,
  });

  @override
  _HistoryOrdersDetailState createState() =>
      _HistoryOrdersDetailState(orderId: this.orderId);
}

class _HistoryOrdersDetailState extends State<HistoryOrdersDetail> {
  
  OrdersProviders ordersProvider;

  final String orderId;
  var menuName;
  var value;
  var address;

  List orderDetail;
  Map order;

  _HistoryOrdersDetailState({this.orderId}) {
    ordersProvider = OrdersProviders();
    menuName = '';
    value = '';
    address = '';
  }

  Future orderHistoryDetailUser() async {
    ordersProvider.getOrderActive(orderId).then((res) {
      setState(() {
        order = res;
        menuName = order['menuName'];
        value = order['price'];
        address = order['address'];
        orderDetail = order['orderDetail'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    orderHistoryDetailUser();
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
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Container(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 9.0,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.fastfood,
                      size: 60,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
