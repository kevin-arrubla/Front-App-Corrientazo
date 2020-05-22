import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/Profile_Provider.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';
import 'dart:async';

class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserInformation userInformation;
  ProfileProvider profileProvider;

  Map user;
  Map userData;

  var nameUser = '';
  var phone = '';
  var adress;
  var city;

  _ProfilePageState() {
    userInformation = UserInformation();
    profileProvider = ProfileProvider();
    userData = {};
  }

  Future profileUser() async {
    userData = await userInformation.getUserInformation();
    await profileProvider.getUserById(userData['userId']).then(
      (res) {
        setState(() {
          user = res;
          nameUser = user['userName'].toString().split(' ')[0];
          phone = user['userPhone'];
          adress = user['nameDirection'];
          city = user['userCity'];

          if (user['userAdress'] == null) {
            user['userAdress'] = 'No registrado';
          }
          if (user['userCity'] == null) {
            user['userCity'] = 'No registrado';
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    profileUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Perfil',
          style: TextStyle(color: Colors.white),
        ),
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
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img1/fondo.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.hardLight)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 120,
                backgroundImage: AssetImage('assets/img1/avatar0.png'),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  '$nameUser',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 55.0,
                      fontFamily: 'Source Sans Pro'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$phone",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Source Sans Pro'),
                  )
                ],
              ),
              Divider(
                height: 40,
                color: Colors.white,
                endIndent: 65,
                indent: 65,
                thickness: 1,
              ),
              Container(
                child: information(),
              ),
              Container(
                child: config(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget information() {
    final buttonInformation = Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(7.0)),
            child: Row(
              children: <Widget>[
                IconButton(
                    color: Colors.white,
                    icon: Icon(
                      Icons.edit,
                      size: 33,
                    ),
                    onPressed: () {}),
                Spacer(),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'INFORMACION',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          )),
        ],
      ),
    );

    return GestureDetector(
      child: buttonInformation,
      onTap: () {
        Navigator.pushNamed(context, 'updateProfile');
      },
    );
  }

  Widget config() {
    final buttonConfig = Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 0, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(7.0)),
            child: Row(
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.security,
                    size: 33,
                  ),
                  onPressed: () {},
                ),
                Spacer(),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'SEGURIDAD',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          )),
        ],
      ),
    );
    return GestureDetector(
      child: buttonConfig,
      onTap: () {
        Navigator.pushNamed(context, 'changepasswordpage');
      },
    );
  }
}
