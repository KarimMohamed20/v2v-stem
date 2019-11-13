import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static final databaseReference = FirebaseDatabase.instance.reference();

  // Input Controllers
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController carModel = TextEditingController();
  TextEditingController carNumber = TextEditingController();

  void createUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (
        password.text != "") {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((currentUser) async {
        databaseReference.child(currentUser.user.uid).set({
          "uid": currentUser.user.uid,
          "name": name.text,
          "age": age.text,
          "email": email.text,
          "carModel": carModel.text,
          "carNumber": carNumber.text,
          "latitude":"0.0",
          "longitude":"0.0"
        });
        // Save USER ID from Firebase in SharedPreferences

        await _prefs.setString("uid", currentUser.user.uid);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(uid: currentUser.user.uid)));
      });
    } else {
      print('Wrong Email or Password Format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("V2V STEM"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            textInput(name, hintText: "Enter your name"),
            textInput(age, hintText: "Enter your age"),
            textInput(email, hintText: "Enter your email"),
            textInput(password,
                hintText: "Enter your password", password: true),
            textInput(carModel, hintText: "Enter your Car Model"),
            textInput(carNumber, hintText: "Enter your Car Number"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
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
                      "Sign Up",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                onTap: () {
                  createUser();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  textInput(TextEditingController controller,
      {String hintText, bool password = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: password,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
