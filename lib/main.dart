import 'package:flutter/material.dart';
import 'package:flutter_maps/Home.dart';
import 'landing_page.dart';
import 'splash_screen.dart';
import 'landing_page.dart';
import'package:flutter_maps/Login.dart';
import 'Register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      routes: {
          'splash_screen': (context) => new SplashPage(),
          'landing': (context) => new LandingPage(),
          'login': (context) => new Login(),
          'register': (context) => new Register(),
          'home': (context)=> new Home(),
      },
    );
  }
}

