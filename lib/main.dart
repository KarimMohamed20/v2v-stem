import 'package:flutter/material.dart';

import 'Home.dart';
import 'splash_screen.dart';
import 'landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Home(),
      routes: {
          'splash_screen': (context) => new SplashPage(),
          'landing': (context) => new Home(),
      },
    );
  }
}

