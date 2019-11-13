import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  void signIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (password.text != "") {
      try{ await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((result) async {
        await _prefs.setString("uid", result.user.uid);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(uid: result.user.uid)));
      });} catch (e) {
        key.currentState.showSnackBar(SnackBar(
          content: Text("Incorrect Email or Password"),
        ));
      }
     
    } else {
      key.currentState.showSnackBar(SnackBar(
          content: Text("Incorrect Email or Password Format"),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.purple.withOpacity(0.1), BlendMode.dstATop),
            image: AssetImage('assets/mountains.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
        key: key,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 63.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30)),
                  gradient: LinearGradient(colors: [
                    Colors.purple.withAlpha(185),
                    Colors.purple,
                  ])),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text('Login'),
              ),
            ),
          ),
          body: loginPage()),
    ]);
  }

  Widget loginPage() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: new Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(90.0),
          child: Center(
            child: Icon(
              Icons.directions_car,
              color: Colors.purple,
              size: 60.0,
            ),
          ),
        ),
        new Row(
          children: <Widget>[
            new Expanded(
              child: new Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: new Text(
                  "EMAIL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Colors.purple, width: 0.5, style: BorderStyle.solid),
            ),
          ),
          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: TextField(
                  controller: email,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'example@example.com',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 24.0,
        ),
        new Row(
          children: <Widget>[
            new Expanded(
              child: new Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: new Text(
                  "PASSWORD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Colors.purple, width: 0.5, style: BorderStyle.solid),
            ),
          ),
          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: TextField(
                  controller: password,
                  obscureText: true,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '*********',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
        new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.purple.withAlpha(200)]),
              borderRadius: BorderRadius.circular(30)),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () => {signIn()},
                  child: new Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20.0,
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: Text(
                            "LOGIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
