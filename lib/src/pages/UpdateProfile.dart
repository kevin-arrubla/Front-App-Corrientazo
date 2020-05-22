import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/controllers/Profile_controller.dart';
import 'package:front_app_corrientazo/src/providers/Profile_Provider.dart';
import 'package:front_app_corrientazo/src/utils/UserInformation.dart';

class UpdateProfilePage extends StatefulWidget {
  UpdateProfilePage();

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  UserInformation userInformation;
  ProfileProvider profileProvider;
  ProfileController profileController;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  Map user;
  Map userData = {};

  var nameUser;
  var userphone;

  _UpdateProfilePageState() {
    userInformation = UserInformation();
    profileProvider = ProfileProvider();
    profileController = ProfileController();
  }

  Future updateProfileUser() async {
    userData = await userInformation.getUserInformation();
    profileProvider.getUserById(userData['userId']).then(
      (res) {
        setState(() {
          user = res;
          nameUser = user['userName'];
          userphone = user['userPhone'];
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateProfileUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Informacion'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              //   Navigator.pushNamedAndRemoveUntil(context, 'profile',
              //     (Route<dynamic> route) {
              //   print(route);
              //   return route.isFirst;
              // });
              Navigator.popAndPushNamed(context, 'profile');
            }),
        backgroundColor: Color(0xFFF44336),
      ),
      body: ListView(
        children: <Widget>[
          Icon(
            Icons.person,
            color: Colors.grey,
            size: 200.0,
          ),
          _createInputText(
              nameUser, Icon(Icons.person, color: Colors.red), name),
          _createInputText(
              userphone, Icon(Icons.phone, color: Colors.red), phone),
          _createButton(),
        ],
      ),
    );
  }

  Widget _createInputText(
      String hintext, Icon icon, TextEditingController control) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: TextFormField(
              controller: control,
              cursorColor: Colors.red,
              decoration: InputDecoration(
                hintText: hintext,
                icon: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createButton() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: OutlineButton(
          highlightedBorderColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          child: Text('Guardar Cambios'),
          onPressed: () async {
            await _validation();
            profileController.update(
                context, {'userName': name.text, 'userPhone': phone.text});
          },
        ),
      ),
    ]);
  }

  _validation() {
    if (name.text.isEmpty) {
      name.text = user['userName'];
    }
    if (phone.text.isEmpty) {
      phone.text = user['userPhone'];
    }
  }
}
