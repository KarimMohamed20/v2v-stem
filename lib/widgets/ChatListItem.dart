import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final email;

  ChatMessageListItem({this.messageSnapshot, this.animation,this.email});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: email == messageSnapshot.value['email']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(messageSnapshot.value['senderName'],
                style: new TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Text(messageSnapshot.value['text'],
                style: new TextStyle(
                  fontSize: 19.5,
                  color: Colors.black,
                )),
            Divider()
          ],
        ),
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot.value['senderName'],
                style: new TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Text(messageSnapshot.value['text'],
                style: new TextStyle(
                  fontSize: 19.5,
                  color: Colors.black,
                )),
            Divider()
          ],
        ),
      ),
    ];
  }
}
