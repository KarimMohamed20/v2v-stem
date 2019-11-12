import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (RegExp(email.text).hasMatch(
            "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$") &&
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
          "carNumber": carNumber.text
        });
        await _prefs.setString("uid", currentUser.user.uid);
      });

      // Save USER ID from Firebase in SharedPreferences

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("V2V STEM"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            textInput(name, hintText: "Enter your name"),
            textInput(email, hintText: "Enter your email"),
            textInput(password,
                hintText: "Enter your password", password: true),
            //   textInput(carNumber, hintText: "Enter your Car Number"),
            RaisedButton(
              onPressed: () {
                createUser();
              },
              child: Text("SignUp"),
            ),
          ],
        ),
      ),
    );
  }

  textInput(TextEditingController controller,
      {String hintText, bool password}) {
    return TextFormField(
      obscureText: password ?? false,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
