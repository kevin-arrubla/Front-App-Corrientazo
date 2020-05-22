import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Subscriptions.dart';
import 'package:front_app_corrientazo/src/pages/Today_Menu.dart';
import 'package:front_app_corrientazo/src/providers/ListRestaurant_Provider.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class DataSearch extends SearchDelegate {
  ListRestaurantProviders listRestaurantProviders;
  Token token;

  List listRestaurant;
  List<String> itemName;
  List find;

  String cityUser;
  String seleccion = '';

  DataSearch() {
    listRestaurantProviders = ListRestaurantProviders();
    token = Token();
    searchDelegateUser();
  }

  Future searchDelegateUser() async {
    await token.getString('city').then((res) {
      cityUser = res;
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    listRestaurantProviders.getRestaurantByCity(cityUser).then((res) {
      listRestaurant = res;
      itemName = [];
      find = [];
    });
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
                    width: 500.0,
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
                                //Navigator.pushReplacementNamed(context, 'search');
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
                                //Navigator.pushReplacementNamed(context, 'search');
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
          final route = MaterialPageRoute(builder: (context) {
            return TodayMenuPage();
          });
          Navigator.push(context, route);
          //Navigator.pushReplacementNamed(context, 'search');
        },
      );
    }
    // Son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      generateListSuggestions(query);

      return ListView.builder(
          // physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: find == null ? 0 : find.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildRooms(
                find[index]['image'],
                find[index]['namerestaurant'],
                find[index]['description'],
                find[index]['restid'].toString());
          });
    }
  }

  void generateListSuggestions(query) {
    for (int i = 0; i < listRestaurant.length; i++) {
      if (listRestaurant[i]['namerestaurant']
          .toString()
          .contains(query.toUpperCase())) {
        if (verificateExist(listRestaurant[i]['namerestaurant'].toString())) {
          find.insert(find.length, listRestaurant[i]);
          itemName.add(listRestaurant[i]['namerestaurant']);
        }
      }
    }
  }

  bool verificateExist(String name) {
    bool resp;

    if (itemName.length == 0) {
      itemName.insert(itemName.length, name);
      resp = true;
    } else {
      for (int i = 0; i < itemName.length; i++) {
        if (itemName[i] == name) {
          resp = false;
        } else {
          resp = true;
        }
      }
    }
    return resp;
  }
}
