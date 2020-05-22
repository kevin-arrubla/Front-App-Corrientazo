import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Basket_Detail.dart';
import 'package:front_app_corrientazo/src/pages/Payment_Method.dart';
import 'package:front_app_corrientazo/src/providers/ListRestaurant_Provider.dart';
import 'package:front_app_corrientazo/src/providers/Profile_Provider.dart';
import 'package:front_app_corrientazo/src/providers/TodayMenu_Provider.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';
import 'package:front_app_corrientazo/src/pages/Subscriptions.dart';

class TodayMenuPage extends StatefulWidget {
  static final String path = "lib/src/pages/animations/anim5.dart";
  @override
  _TodaysMenu createState() => _TodaysMenu();
}

class _TodaysMenu extends State<TodayMenuPage> {
  final TodayMenuProvider optionMenu = TodayMenuProvider();
  final ListRestaurantProviders restaurants = ListRestaurantProviders();
  final OrdersProviders orderProviders = OrdersProviders();
  final ProfileProvider profileProvider = ProfileProvider();
  GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  UserInformation userInformation;
  Alerts alerts = Alerts();
  Token token;
  String restIdListRestaurant;

  List listOptioMenu = [];
  List menuToShow = [];
  Map listRestaurant;
  List listOrder = [];
  int activate;

  var nameRestaurant = '';
  var direction = '';
  var celphone = '';
  var schedule = '';

  String amountBasket;
  String restaurantName;
  String restid;

  var value;
  var lista1 = {};
  var lista2 = {};
  var v;
  var amount;

  int counter;

  List<String> order;
  List<String> orderDetail;
  List<String> itemImage;
  List<String> itemMenuName;
  List<String> itemPrice;
  List<String> itemOrderId;
  List<String> total;
  String idRest;
  Map userData = {};

  _TodaysMenu() {
    userInformation = UserInformation();
    token = Token();
  }
  Future getOrderAll() async {
    counter = 0;
    userData = await userInformation.getUserInformation();

    await token.getString('restaurantName').then((res) {
      setState(() {
        restaurantName = res;
      });
    });
    await token.getString('restId').then((res) {
      setState(() {
        restid = res;
      });
    });

    await token.getString('resIdListRestaurant').then((res) {
      setState(() {
        restIdListRestaurant = res;
      });
    });

    await optionMenu.loadmenu(restIdListRestaurant).then((resp) {
      setState(() {
        listOptioMenu = resp;
        for (int i = 0; i < listOptioMenu.length; i++) {
          if (listOptioMenu[i]['state'] == 'ACTIVO') {
            menuToShow.add(listOptioMenu[i]);
          }
        }
      });
    });

    restaurants.getRestaurantId(restIdListRestaurant).then((res) {
      setState(() {
        listRestaurant = res;
        nameRestaurant = listRestaurant['namerestaurant'];
        direction = listRestaurant['direction'].toString();
        celphone = listRestaurant['celphone'].toString();
        schedule = listRestaurant['schedule'].toString();
        idRest = listRestaurant['restid'].toString();
      });
    });

    await orderProviders.orderAll(userData['userId']).then((res) {
      setState(() {
        listOrder = res;

        if (listOrder.toString() == [].toString()) {
          counter = 1;
        }

        for (var i = 0; i < listOrder.length; i++) {
          idRest = listOrder[i]['restId'].toString();
          itemImage.insert(itemImage.length, listOrder[i]['image']);
          itemMenuName.insert(itemMenuName.length, listOrder[i]['menuName']);
          itemPrice.insert(itemPrice.length, listOrder[i]['price'].toString());
          itemOrderId.insert(
              itemOrderId.length, listOrder[i]['orderId'].toString());
        }
        if (idRest == restIdListRestaurant || idRest == null) {
          activate = 0;
        } else {
          activate = 1;
        }
        if (itemPrice.length < 1) {
          value = value + v;
          total.insert(total.length, value.toString());
        } else {
          for (var i = 0; i < itemPrice.length; i++) {
            v = int.parse(itemPrice[i].toString());
            value = value + v;
            total.insert(0, value.toString());
            amountBasket = total[0];
          }
        }
      });
    });
  }

  @override
  void initState() {
    getOrderAll();
    itemImage = [];
    itemMenuName = [];
    itemPrice = [];
    itemOrderId = [];
    total = [];
    value = 0;
    v = 0;
    activate = 0;
    amountBasket = '';
    refresh();
    super.initState();
  }

  Future refresh() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      amoutn();
    });
    return Future.delayed(duration);
  }

  Future refreshMenus() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      menuToShow.clear();
      getOrderAll();
    });
    return Future.delayed(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshMenus,
        child: CustomScrollView(
          slivers: <Widget>[
            createBar(),
            Container(
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return description();
                  },
                  childCount: 1,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return fooditem(
                  menuToShow[index]['image'].toString(),
                  menuToShow[index]['menuName'],
                  menuToShow[index]['value'].toString(),
                  menuToShow[index]['menuId'].toString(),
                );
              },
              childCount: menuToShow == null ? 0 : menuToShow.length,
            )),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 44),
          child: FloatingActionButton.extended(
            elevation: 3.0,
            onPressed: () async {
              _showModalSheet();
            },
            icon: Icon(
              Icons.shopping_cart,
              size: 30,
            ),
            backgroundColor: Color(0xFFF44336),
            label: Text('VER CANASTA'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Material(
          child: SizedBox(
            height: 10.0,
          ),
          color: Color(0xFFF44336),
        ),
      ),
    );
  }

  Widget icon1() {
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'list');
        });
  }

  Widget image1() {
    return Container(
      child: PageView.builder(
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(listRestaurant['image'].toString()),
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.hardLight))),
          );
        },
        itemCount: listRestaurant == null ? 0 : listRestaurant.length,
      ),
    );
  }

  Widget createBar() {
    return Container(
      child: SliverAppBar(
        leading: icon1(),
        expandedHeight: 150.0,
        floating: false,
        pinned: true,
        elevation: 0,
        backgroundColor: Color(0xFFF44336),
        flexibleSpace: FlexibleSpaceBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 0, right: 148.5),
            child: Text(
              '$nameRestaurant',
              style: TextStyle(color: Colors.white, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          background: image1(),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 1),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 40.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$direction',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis),
                  Text('$celphone',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis),
                  Text(
                    '$schedule',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.star_border,
                    color: Colors.red,
                    size: 40.0,
                  ),
                  onPressed: () {
                    final route = MaterialPageRoute(builder: (context) {
                      return Subscriptions(idRest: idRest);
                    });
                    Navigator.push(context, route);
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                FlatButton(
                  onPressed: () {
                    final route = MaterialPageRoute(builder: (context) {
                      return Subscriptions(idRest: idRest);
                    });
                    Navigator.push(context, route);
                  },
                  child: Text(
                    "(SUSCRIBETE)",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget fooditem(
    String imagen,
    String name,
    String price,
    String menuId,
  ) {
    final food = Container(
      child: Column(children: <Widget>[
        Divider(color: Colors.black, height: 25.6, thickness: 0.7),
        ListTile(
          title: Text(
            name,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'VALOR: ' + price,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 17.0,
              color: Colors.grey,
            ),
            overflow: TextOverflow.fade,
          ),
          leading: Container(
            child: FadeInImage(
              image: NetworkImage(imagen),
              placeholder: AssetImage('assets/img2/vacio.png'),
              fit: BoxFit.cover,
              height: 50.0,
              width: 50.0,
            ),
          ),
          trailing: Icon(
            Icons.add_box,
            size: 35,
            color: Color(0xFFF44336),
          ),
        )
      ]),
    );
    return GestureDetector(
      child: food,
      onTap: () {
        if (restid == restIdListRestaurant) {
          params(restIdListRestaurant, name, price, imagen, menuId,
              nameRestaurant);
        } else {
          if (restid == '') {
            params(restIdListRestaurant, name, price, imagen, menuId,
                nameRestaurant);
          } else {
            alerts.successAlert(
                context,
                'Por favor termina la orden pediente con el retaurante $restaurantName');
          }
        }
      },
    );
  }

  Widget card() {
    return Scaffold(
      body: AnimatedList(
        padding: EdgeInsets.all(16.0),
        key: _listkey,
        initialItemCount: itemMenuName.length,
        itemBuilder: (context, index, anim) {
          return Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
                child: Material(
                  borderRadius: BorderRadius.circular(5.0),
                  elevation: 3.0,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        SafeArea(
                          child: Container(
                              height: 40,
                              child: FadeInImage(
                                placeholder:
                                    AssetImage('assets/img2/vacio.png'),
                                image: NetworkImage(
                                  itemImage[index],
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SafeArea(
                                child: ListTile(
                                    title: Text(
                                      itemMenuName[index],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '\$' + itemPrice[index].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          final route = MaterialPageRoute(
                                              builder: (context) {
                                            return BasketDetailPage(
                                              menuName: listOrder[index]
                                                  ['menuName'],
                                              orderId: listOrder[index]
                                                      ['orderId']
                                                  .toString(),
                                              menuId: listOrder[index]['menuId']
                                                  .toString(),
                                              imagen: listOrder[index]['image'],
                                            );
                                          });
                                          Navigator.push(context, route);
                                        })),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 15,
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      orderProviders
                          .deleteOrderId(itemOrderId[index])
                          .then((res) {});
                      setState(() {
                        activate = 0;
                        Navigator.of(context);
                        _listkey.currentState.removeItem(index,
                            (context, animation) {
                          var price = int.parse(itemPrice[index]);
                          itemMenuName.removeAt(index);
                          itemImage.removeAt(index);
                          itemPrice.removeAt(index);
                          itemOrderId.removeAt(index);
                          value = value - price;
                          total.removeAt(0);
                          total.insert(0, value.toString());
                          amountBasket = total[0];
                          if (itemMenuName.length < 1) {
                            counter = 1;
                            token.setString('restId', '');
                            token.setString('restaurantName', '');
                            token.getString('restId').then((res) {
                              setState(() {
                                restid = res;
                              });
                            });
                          }
                          return SizeTransition(sizeFactor: animation);
                        });
                      });
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget amoutn() {
    return ListTile(
      title: Text(
        'CANASTA',
        style: TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      // trailing: Text(
      //   'VALOR: \$' + amountBasket != null ? 'VALOR: \$' + amountBasket : amountBasket,
      //   style: TextStyle(color: Colors.white, fontSize: 18),
      // ),
    );
  }

  void params(String restIdParams, String nameParams, String priceParams,
      String imagenParams, String menuIdParams, String nameRestaurantParams) {
    token.setString('restIdSelectMenu', '$restIdParams');
    token.setString('nameSelectMenu', '$nameParams');
    token.setString('priceSelectMenu', '$priceParams');
    token.setString('imageSelectMenu', '$imagenParams');
    token.setString('menuIdSelectMenu', '$menuIdParams');
    token.setString('nameRestaurant', '$nameRestaurantParams');
    Navigator.pushNamed(context, 'select');
  }

  void _showModalSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: amoutn(),
                ),
                Expanded(
                  child: card(),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          height: 50.0,
                          color: Colors.red,
                          child: Text(
                            "COMPRAR".toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          onPressed: () {
                            if (counter < 1) {
                              final route =
                                  MaterialPageRoute(builder: (context) {
                                return PaymentMethod(value: this.total[0]);
                              });
                              Navigator.push(context, route);
                            } else {
                              alerts.successAlert(
                                  context, 'No hay pedidos pendientes');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
