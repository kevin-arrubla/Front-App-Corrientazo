import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/Profile_Provider.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class NewDirectionPage extends StatefulWidget {
  @override
  _NewDirectionState createState() => _NewDirectionState();
}

class _NewDirectionState extends State<NewDirectionPage> {
  TextEditingController addressInput = TextEditingController();
  TextEditingController cityInput = TextEditingController();
  ProfileProvider profileProvider;
  UserInformation userInformation;

  Map userData = {};
  List userDirections;
  Token token;
  String direction;
  int counter = 0;

  List<String> itemDirection;
  List<String> itemCity;
  List<String> itemDirectionId;

  Future locateMyAddress() async {
    userData = await userInformation.getUserInformation();
    await profileProvider.getDirectionsByUserId(userData['userId']).then((res) {
      setState(() {
        userDirections = res;
        if (userDirections.toString() == '[]') {
          counter = 1;
        } else {
          counter = 0;
        }
        for (var i = 0; i < userDirections.length; i++) {
          itemDirection.insert(
              itemDirection.length, userDirections[i]['nameDirection']);
          itemCity.insert(itemCity.length, userDirections[i]['userCity']);
          itemDirectionId.insert(itemDirectionId.length,
              userDirections[i]['directionId'].toString());
        }
      });
    });
  }

  @override
  void initState() {
    itemDirection = [];
    itemCity = [];
    itemDirectionId = [];
    super.initState();
  }

  _NewDirectionState() {
    profileProvider = ProfileProvider();
    userInformation = UserInformation();
    token = Token();
    locateMyAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            title: Center(
                child: Text(
              'Elija una direccion',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w900),
            )),
            subtitle: Center(
                child: Text(
              'o agregue una',
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w900),
              overflow: TextOverflow.ellipsis,
            )),
            trailing: Icon(Icons.location_on, color: Colors.white),
          ),
          backgroundColor: Color(0xFFF44336),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (3 == 1) {
                } else {
                  Navigator.popAndPushNamed(context, 'search');
                }
              }),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (counter <= 0) {
                    return _listDirections();
                  } else {
                    return Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/img1/ubicacion.png'),
                          Text(
                            'Bienvenido,',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w800),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Por favor ingresa una direccion',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ));
                  }
                },
                childCount: 1,
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white70,
          height: 95,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              newDirection(context);
            },
            label: Text('NUEVA DIRECCION',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            backgroundColor: Color(0xFFF44336),
          ),
        ),
      ),
    );
  }

  Widget _cardOrder(context, String address, String city, String directionId) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(5)),
          elevation: 3.0,
          child: Column(children: <Widget>[
            ListTile(
              title: Text('Dirección: $address',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              subtitle: Text('Ciudad:' '$city',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            ),
          ]),
        ),
      ),
    );
    return GestureDetector(
      child: list,
      onTap: () {
        token.setString('direction', '$address');
        token.setString('city', '$city');
        Navigator.pushReplacementNamed(context, 'search');
      },
    );
  }

  Widget _listDirections() {
    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemDirection == null ? 0 : itemDirection.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardOrder(context, itemDirection[index], itemCity[index],
              itemDirectionId[index].toString());
        });
  }

  Future newDirection(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            content: Container(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(
                    thickness: 2,
                  ),
                  TextField(
                    controller: addressInput,
                    decoration: InputDecoration(
                        hintText: '  Dirección*',
                        prefixIcon: Icon(Icons.location_on, color: Colors.red),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600)),
                    style: TextStyle(fontSize: 25),
                  ),
                  TextField(
                    controller: cityInput,
                    decoration: InputDecoration(
                        hintText: '  Ciudad*',
                        prefixIcon:
                            Icon(Icons.location_city, color: Colors.red),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600)),
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('CANCELAR',
                      style: TextStyle(color: Color(0xFFF44336))),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('ACEPTAR',
                      style: TextStyle(color: Color(0xFFF44336))),
                  onPressed: () {
                    profileProvider.saveDirection(
                      {
                        'nameDirection': addressInput.text,
                        'userCity': cityInput.text.toUpperCase(),
                        'userId': userData['userId'],
                      },
                    ).then((res) {
                      itemDirection.insert(
                          itemDirection.length, res['nameDirection']);
                      itemCity.insert(itemCity.length, res['userCity']);
                      itemDirectionId.insert(itemDirectionId.length,
                          res['directionId'].toString());
                      setState(() {
                        counter = 0;
                        addressInput.clear();
                        cityInput.clear();
                      });
                    });

                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }
}
