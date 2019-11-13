import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final int delayInMilliseconds;
  final int durationInMilliseconds;
  final TextStyle textStyle;

  AnimatedText(this.text, this.delayInMilliseconds,
      {this.durationInMilliseconds: 4000, this.textStyle});

  @override createState() => new AnimatedTextState(text);
}

class AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {

  String currentText = "";

  String text;

  AnimationController animationController;

  List<int> textRunes;
  int curIndex = 0;

  AnimatedTextState(this.text) {
    textRunes = text.runes.toList();
  }
  void initText() {
    animationController = new AnimationController(
        vsync: this,
        value: 0.0,
        lowerBound: 0.0,
        upperBound: textRunes.length.toDouble(),
        duration: new Duration(
            milliseconds: widget.durationInMilliseconds));

    animationController.addListener(() {
      if (animationController.value.toInt() == 0) {
        setState(() {
          currentText = new String.fromCharCode(textRunes[0]);
        });
      } else if (animationController.value.toInt() > curIndex &&
          animationController.value.toInt() < textRunes.length) {
        setState(() {
          curIndex = animationController.value.toInt();
          currentText += new String.fromCharCode(textRunes[curIndex]);
        });
      }
    });

    
    new Future.delayed(new Duration(milliseconds: widget.delayInMilliseconds));
    animationController.forward();
  }
  @override
   void initState()  {
    super.initState();
    initText();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Text(currentText, textAlign: TextAlign.left,
      style: widget.textStyle ??
          new TextStyle(fontWeight: FontWeight.w600, fontSize: 28.0),);
  }
}