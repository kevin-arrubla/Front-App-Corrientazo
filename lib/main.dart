import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Splash.dart';
import 'package:front_app_corrientazo/src/routes/Router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CORRIENTAZO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'splash',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => SplashScreenPage(),
        );
      },
    );
  }
}
