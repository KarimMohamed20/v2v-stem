import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SideDraw extends StatelessWidget {
  final name;
  SideDraw({this.name});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'profile');
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: 113,
                    width: 113,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/profilepic.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$name',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.arrow_back_ios,
              size: 40,
              color: Colors.indigo,
            ),
            title: Text("Log Out"),
            subtitle: Text("End your session."),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("uid");
              Navigator.pushReplacementNamed(context, 'landing');
            },
          ),
        ],
      ),
    );
  }
}