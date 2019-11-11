//import 'dart:async';
//
//import 'package:device_id/device_id.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//
//class Register extends StatefulWidget {
//  @override
//  _RegisterState createState() => _RegisterState();
//}
//
//class _RegisterState extends State<Register> {
//  static final databaseReference = FirebaseDatabase.instance.reference();
//
//  // Input Controllers
//  TextEditingController name = TextEditingController();
//  TextEditingController email = TextEditingController();
//  TextEditingController password = TextEditingController();
//
//  // TextEditingController carModel = TextEditingController();
//  // TextEditingController carNumber = TextEditingController();
//
//
//  Future createUser() async {
//    var r = await FirebaseAuth.instance
//        .createUserWithEmailAndPassword(email: email.text, password: password.text);
//
//    var u = r;
//    var info = UserUpdateInfo();
//    info.displayName = '$name';
//    return await u.updateProfile(info);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("V2V STEM"),
//      ),
//      body: Container(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            textInput(name, hintText: "Enter your name"),
//            textInput(email, hintText: "Enter your email"),
//            textInput(password, hintText: "Enter your password",password: true),
//         //   textInput(carNumber, hintText: "Enter your Car Number"),
//            RaisedButton(
//              onPressed: () {
//                createUser();
//              },
//              child: Text("SignUp"),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  textInput(
//    TextEditingController controller, {
//    String hintText,
//    bool password
//  }) {
//    return TextFormField(
//      obscureText: password ?? false,
//      controller: controller,
//      decoration: InputDecoration(
//        hintText: hintText,
//        border: OutlineInputBorder(),
//      ),
//    );
//  }
//}
