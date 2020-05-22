import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/TodayMenu_Provider.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';

class BasketDetailPage extends StatefulWidget {
  final String menuName;
  final String orderId;
  final String menuId;
  final String imagen;

  BasketDetailPage({this.menuName, this.orderId, this.menuId, this.imagen});

  @override
  _BasketDetail createState() => _BasketDetail(
      menuName: this.menuName,
      orderId: this.orderId,
      menuId: this.menuId,
      imagen: this.imagen);
}

class _BasketDetail extends State<BasketDetailPage> {
  OrdersProviders ordersProviders;
  TodayMenuProvider option;
  Alerts alerts;

  final Set<String> _saved = Set<String>();
  final Set<String> _savedNew = Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18, color: Colors.black);

  final String menuName;
  final String orderId;
  final String menuId;
  final String imagen;

  List<String> itemOption;
  List<String> itemSubName;
  List<String> item;
  List menuOption;
  List subNames;
  int counter;
  Map lisDetailOrder;

  _BasketDetail({this.menuName, this.orderId, this.menuId, this.imagen}) {
    ordersProviders = OrdersProviders();
    option = TodayMenuProvider();
    alerts = Alerts();
    itemOption = [];
    itemSubName = [];
    item = [];
    counter = 0;
  }
  Future basketDetailUser() async {
    await option.optionsBymenuId(menuId).then((res) {
      setState(() {
        menuOption = res;
      });
    });
    await ordersProviders.getOrderAndDetail(orderId).then(
      (res) {
        setState(() {
          lisDetailOrder = res;
        });

        var numb = menuOption.length;
        counter = lisDetailOrder['orderDetail'].length;
        for (var i = 0; i < lisDetailOrder['orderDetail'].length; i++) {
          var detail = lisDetailOrder['orderDetail'][i]['subName'];
          var idOrderDetail = lisDetailOrder['orderDetail'][i]['orderDetailId'];
          for (var o = 0; o < numb; o++) {
            subNames = menuOption[o]['subOptionDetail'];

            for (var h = 0; h < subNames.length; h++) {
              if (detail.toString() == subNames[h]['subName'].toString()) {
                item.insert(item.length, detail);
                itemSubName.insert(itemSubName.length, detail);
                itemOption.insert(
                    itemOption.length, menuOption[o]['optionName']);
                _saved.add(detail);
                _savedNew.add(idOrderDetail.toString());
              }
            }
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    basketDetailUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          createBar(context),
          Container(
            child: Container(
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return fooditem1(menuOption[index]['optionName'].toString(),
                        menuOption[index]['subOptionDetail']);
                  },
                  childCount: menuOption == null ? 0 : menuOption.length,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 44),
          child: FloatingActionButton.extended(
            elevation: 3.0,
            onPressed: () async {
              if (counter > 2) {
                var cont1 = itemSubName.length;
                var cont2 = item.length;
                if (cont2 <= cont1) {
                  if (cont1 > cont2) {
                    for (var i = 0; i < cont1; i++) {
                      if (i < cont2) {
                        ordersProviders.updateOrderDetail(
                            _savedNew.toList()[i], {'subName': itemSubName[i]});
                      } else {
                        ordersProviders.createDetailOrder(
                            {'orderId': orderId, 'subName': itemSubName[i]});
                      }
                    }
                  } else {
                    for (var i = 0; i < cont2; i++) {
                      ordersProviders.updateOrderDetail(
                          _savedNew.toList()[i], {'subName': itemSubName[i]});
                    }
                  }
                } else {
                  for (var i = 0; i < cont2; i++) {
                    if (i < cont1) {
                      ordersProviders.updateOrderDetail(
                          _savedNew.toList()[i], {'subName': itemSubName[i]});
                    } else {
                      ordersProviders.deleteOrderDetail(_savedNew.toList()[i]);
                    }
                  }
                }
                Navigator.popAndPushNamed(context, 'menu');
              } else {
                alerts.errorAlert(context, 'Por Favor Seleccione Minimo 3');
              }
            },
            icon: Icon(
              Icons.add_shopping_cart,
              size: 30,
            ),
            backgroundColor: Color(0xFFF44336),
            label: Text('PEDIR'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Material(
          child: SizedBox(
            height: 60.0,
          ),
          color: Color(0xFFF44336),
        ),
      ),
    );
  }

  Widget image1() {
    return Container(
      child: Image.network(
        imagen,
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.4),
        colorBlendMode: BlendMode.hardLight,
      ),
    );
  }

  Widget createBar(BuildContext context) {
    return Container(
      child: SliverAppBar(
        expandedHeight: 150.0,
        floating: false,
        pinned: true,
        elevation: 0,
        backgroundColor: Color(0xFFF44336),
        flexibleSpace: FlexibleSpaceBar(
          title: Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 148.5),
              child: Text(menuName != null ? menuName : ''),
            ),
          ),
          background: image1(),
        ),
      ),
    );
  }

  Widget check(String option, List subName) {
    List subOptionsToShow = [];
    for (int i = 0; i < subName.length; i++) {
      subOptionsToShow.add(subName[i]);
    }
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: subOptionsToShow == null ? 0 : subOptionsToShow.length,
      itemBuilder: (BuildContext context, int index) {
        bool alreadySaved = _saved.contains(subOptionsToShow[index]['subName']);
        return ListTile(
          title: Text(
            subOptionsToShow[index]['subName'],
            style: _biggerFont,
          ),
          leading: Icon(
            Icons.label_important,
            color: Color(0xFFF44336),
          ),
          trailing: Icon(
            alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
            color: alreadySaved ? Color(0xFFF44336) : Color(0xFFF44336),
            size: 30,
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                itemOption.remove(option);
                itemSubName.remove(subOptionsToShow[index]['subName']);
                _saved.remove(subOptionsToShow[index]['subName']);
                counter--;
              } else {
                if (itemOption.toString() == '[]') {
                  _saved.add(subOptionsToShow[index]['subName']);
                  itemOption.insert(itemOption.length, option);
                  itemSubName.insert(
                      itemSubName.length, subOptionsToShow[index]['subName']);
                  counter++;
                } else {
                  var count = itemOption.length;
                  var c = 0;
                  var position = 0;
                  for (var i = 0; i < count; i++) {
                    if (itemOption[i] == option) {
                      c++;
                      position = i;
                    }
                  }
                  if (c < 1) {
                    _saved.add(subOptionsToShow[index]['subName']);
                    itemOption.insert(itemOption.length, option);
                    itemSubName.insert(
                        itemSubName.length, subOptionsToShow[index]['subName']);
                    counter++;
                  } else {
                    _saved.remove(itemSubName[position]);
                    _saved.add(subOptionsToShow[index]['subName']);
                    itemOption.removeAt(position);
                    itemSubName.removeAt(position);
                    itemOption.insert(itemOption.length, option);
                    itemSubName.insert(
                        itemSubName.length, subOptionsToShow[index]['subName']);
                  }
                }
              }
            });
          },
        );
      },
    );
  }

  Widget fooditem1(String opttionName, List subName) {
    return ListBody(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[300], border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              opttionName,
              style: TextStyle(fontSize: 25, fontStyle: FontStyle.normal),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Container(child: check(opttionName, subName))
      ],
    );
  }
}
