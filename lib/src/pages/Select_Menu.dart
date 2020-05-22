import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/TodayMenu_Provider.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class SelectMenuPage extends StatefulWidget {
  @override
  _SelectMenu createState() => _SelectMenu();
}

class _SelectMenu extends State<SelectMenuPage> {
  TodayMenuProvider option;
  OrdersProviders orderCreate;
  UserInformation userInformation;
  Token token;
  Alerts alerts;

  final Set<String> _saved = Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18, color: Colors.black);

  String restId;
  String menuName;
  String value;
  String imagen;
  String menuId;
  String nameRestaurant;
  String direction;

  List menuOption;
  List<String> itemOption;
  List<String> itemSubName;

  int counter;
  Map userData = {};

  _SelectMenu() {
    userInformation = UserInformation();
    option = TodayMenuProvider();
    orderCreate = OrdersProviders();
    token = Token();
    alerts = Alerts();
    itemOption = [];
    itemSubName = [];
    counter = 0;
  }

  Future menuUser() async {
    userData = await userInformation.getUserInformation();

    await token.getString('restIdSelectMenu').then((res) {
      setState(() {
        restId = res;
      });
    });

    await token.getString('nameSelectMenu').then((res) {
      setState(() {
        menuName = res;
      });
    });

    await token.getString('priceSelectMenu').then((res) {
      setState(() {
        value = res;
      });
    });

    await token.getString('direction').then((res) {
      setState(() {
        direction = res;
      });
    });

    await token.getString('imageSelectMenu').then((res) {
      setState(() {
        imagen = res;
      });
    });

    await token.getString('menuIdSelectMenu').then((res) {
      setState(() {
        menuId = res;
      });
    });
    await token.getString('nameRestaurant').then((res) {
      setState(() {
        nameRestaurant = res;
      });
    });

    await token.getString('direction').then((res) {
      setState(() {
        direction = res;
      });
    });

    await option.optionsBymenuId(menuId).then((res) {
      setState(() {
        menuOption = res;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    menuUser();
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
                  childCount: menuOption != null ? menuOption.length : 0,
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
                var newOrder = await orderCreate.createOrder({
                  'userId': userData['userId'],
                  'restId': restId,
                  'menuId': menuId,
                  'menuName': menuName,
                  'image': imagen,
                  'price': value,
                  'state': 'BASKET',
                  'address': direction.toString()
                });

                for (var i = 0; i < itemSubName.length; i++) {
                  orderCreate.createDetailOrder({
                    'orderId': newOrder['idOrders'],
                    'subName': itemSubName[i]
                  });
                }

                token.setString('restId', '$restId');
                token.setString('restaurantName', '$nameRestaurant');

                Navigator.pushReplacementNamed(context, 'menu');
                // Navigator.pushAndRemoveUntil(context, route,
                //     (Route<dynamic> route) {
                //   print(route);
                //   return false;
                // });
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

  Widget image2() {
    final icon = Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    );
    return GestureDetector(
      child: icon,
      onTap: () {
        Navigator.popAndPushNamed(context, 'menu');
      },
    );
  }

  Widget image1() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              imagen != null ? imagen : '',
            ),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.hardLight)),
      ),
    );
  }

  Widget createBar(BuildContext context) {
    return Container(
      child: SliverAppBar(
        leading: image2(),
        expandedHeight: 150.0,
        floating: false,
        pinned: true,
        elevation: 0,
        backgroundColor: Color(0xFFF44336),
        flexibleSpace: FlexibleSpaceBar(
          title: Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 148.5),
              child: Text(
                menuName != null ? menuName : '',
                overflow: TextOverflow.ellipsis,
              ),
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
