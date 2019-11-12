import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void signIn() async {
    if (RegExp(email.text).hasMatch(
            "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$") &&
        password.text != "") {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((result) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(uid: result.user.uid)));
      });
    } else {
      print('Wrong Email or Password Format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: "example@ex.com"),
              controller: email,
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "********"),
              controller: password,
              obscureText: true,
            ),
            new GestureDetector(
              child: new Material(
                child: new Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(5.0),
                    gradient: new LinearGradient(colors: <Color>[
                      Colors.green,
                      Colors.greenAccent,
                    ]),
                  ),
                  alignment: Alignment.center,
                  child: new Text(
                    "Login",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              onTap: () {
                signIn();
              },
            )
          ])),
    );
  }
}
