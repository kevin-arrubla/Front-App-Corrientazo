import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Subscriptions.dart';
import 'package:front_app_corrientazo/src/pages/search_Delegate.dart';
import 'package:front_app_corrientazo/src/providers/ListRestaurant_Provider.dart';
import 'package:front_app_corrientazo/src/providers/Profile_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';
import 'dart:async';

class ListRestaurantPage extends StatefulWidget {
  @override
  _ListRestaurantState createState() => _ListRestaurantState();
}

class _ListRestaurantState extends State<ListRestaurantPage> {
  ListRestaurantProviders restaurants;
  ProfileProvider profileProvider;
  TextEditingController find;
  TextEditingController addressInput;
  TextEditingController cityInput;
  Token token;
  Alerts alerts;

  String city;
  String lastCity;
  String cityUser;

  List directions;
  List listRestaurant;

  _ListRestaurantState() {
    listRestaurant = [];
    restaurants = ListRestaurantProviders();
    profileProvider = ProfileProvider();
    addressInput = TextEditingController();
    cityInput = TextEditingController();
    find = TextEditingController();
    token = Token();
    alerts = Alerts();
  }

  Future listRestaurantuser() async {
    await token.getString('city').then((res) {
      setState(() {
        cityUser = res;
      });
    });
    await restaurants.getRestaurantByCity(cityUser).then((res) {
      setState(() {
        listRestaurant = res;
        if (listRestaurant.toString() == '[]') {
          alerts.errorAlert(
              context, 'No hay Restaurantes Registrados en esta Ciudad');
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
      listRestaurantuser();
    });
    return Future.delayed(duration);
  }

  @override
  void initState() {
    super.initState();
    listRestaurantuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Container(
          child: Image.asset('assets/img1/logotipo3.png'),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
                setState(() {});
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, 'search');
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
        child: RefreshIndicator(
          onRefresh: refresh,
          child: CustomScrollView(
            slivers: <Widget>[
              Container(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildRooms(
                          listRestaurant[index]['image'],
                          listRestaurant[index]['namerestaurant'],
                          listRestaurant[index]['description'],
                          listRestaurant[index]['restid'].toString());
                    },
                    childCount:
                        listRestaurant == null ? 0 : listRestaurant.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
      ),
    );
  }

  Widget _buildRooms(
      String imagen, String title, String subtitle, String restid) {
    final food = Container(
      margin: EdgeInsets.all(15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.0),
        child: Container(
          child: Material(
            elevation: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(imagen),
                  placeholder: AssetImage('assets/img2/vacio.png'),
                  height: 200.0,
                  width: 500,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontSize: 17.0),
                      ),
                      SizedBox(
                        height: 10.0,
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
                              final route =
                                  MaterialPageRoute(builder: (context) {
                                return Subscriptions(idRest: restid);
                              });
                              Navigator.push(context, route);
                            },
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          FlatButton(
                            onPressed: () {
                              final route =
                                  MaterialPageRoute(builder: (context) {
                                return Subscriptions(idRest: restid);
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return GestureDetector(
      child: food,
      onTap: () {
        token.setString('resIdListRestaurant', '$restid');

        Navigator.pushNamed(context, 'menu');
      },
    );
  }
}
