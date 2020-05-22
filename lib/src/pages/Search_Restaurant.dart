import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:front_app_corrientazo/src/pages/Ongoing_Orders.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';
import '../providers/Profile_Provider.dart';

class SearchRestaurantPage extends StatefulWidget {
  SearchRestaurantPage();

  @override
  _SearchRestaurantPageState createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  final Color divider = Colors.grey.shade600;
  final Color primary = Colors.white;

  ProfileProvider profileProvider;
  UserInformation userInformation;

  Map user;
  Token token;
  var city = '';
  var direction = '';
  var nameWelcome = '';
  Map userData;

  _SearchRestaurantPageState() {
    token = Token();
    userInformation = UserInformation();
    profileProvider = ProfileProvider();
    userData = {};
  }

  Future getUser() async {
    userData = await userInformation.getUserInformation();
    await token.getString('direction').then((res) {
      setState(() {
        direction = res;
      });
    });
    await token.getString('city').then((res) {
      setState(() {
        city = res;
      });
    });

    await profileProvider.getUserById(userData['userId']).then((res) {
      setState(() {
        user = res;
        nameWelcome = user['userName'].toString().split(' ')[0].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Widget imagCarousel = new Container(
      height: 200,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/img2/frijolada.jpg'),
          AssetImage('assets/img2/restaurantes1.jpg')
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Container(
            child: Center(
                child: Text('CASERITOS',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
                    overflow: TextOverflow.ellipsis)),
          ),
          subtitle: Container(
            child: Center(
                child: Text('$direction',
                    style: TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis)),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'newdirection');
              }),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.black.withOpacity(0.02),
        height: MediaQuery.of(context).size.height - 0,
        child: ListView(
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: imagCarousel,
            ),
            SizedBox(height: 15),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'LO QUE ESTABAS BUSCANDO',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                overflow: TextOverflow.ellipsis,
              ),
            )),
            SizedBox(height: 5),
            Container(
              child: _searchByRestaurant(
                  'assets/img1/logo2.png',
                  'Restaurantes ',
                  'Los Mejores Restaurantes, Corrientazo de la Ciudad',
                  'Ver Mas Restaurantes',
                  context),
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: Container(
        height: 50,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 44),
          child: FloatingActionButton.extended(
            elevation: 3.0,
            onPressed: () {
              final route = MaterialPageRoute(builder: (context) {
                return OrgoingOrdersPage();
              });
              Navigator.push(context, route);
            },
            icon: Icon(
              Icons.motorcycle,
              size: 30,
            ),
            backgroundColor: Color(0xFFF44336),
            label: Text('Pedido en curso',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _buildDrawer() {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: 160,
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                        title: Text(
                          'Hola,',
                          style: TextStyle(fontSize: 28),
                        ),
                        subtitle: Text('$nameWelcome',
                            style: TextStyle(fontSize: 25)),
                        trailing: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                          backgroundColor: Colors.red,
                          maxRadius: 50,
                        ))),
                _buildDivider(),
                ListTile(
                  leading: Icon(
                    Icons.recent_actors,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text('Ver mi Perfil', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pushNamed(context, 'profile');
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(
                    Icons.content_paste,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text('Mi historial de pedidos',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pushNamed(context, 'ordersHistory');
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading:
                      Icon(Icons.attach_money, color: Colors.red, size: 35),
                  title: Text(
                    'Ver Mis Pagos',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'detailpayment');
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading:
                      Icon(Icons.subscriptions, color: Colors.red, size: 35),
                  title: Text(
                    'Mis Suscripciones',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'userSubscription');
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red, size: 35),
                  title: Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () async {
                    userInformation.signOff(context);
                  },
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _searchByRestaurant(String imagen, String title, String subtitle,
      String buttom, BuildContext context) {
    context = context;
    final restaurant = Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
                image: AssetImage('assets/img1/fondo2.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.hardLight))),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 60),
                    child: ListTile(
                      title: Text('RESTAURANTES',
                          style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade),
                      subtitle: Text('Vive la Mejor experiencia',
                          style: TextStyle(fontSize: 21, color: Colors.white),
                          overflow: TextOverflow.fade),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return GestureDetector(
      child: restaurant,
      onTap: () {
        Navigator.pushNamed(context, 'list');
      },
    );
  }
}
