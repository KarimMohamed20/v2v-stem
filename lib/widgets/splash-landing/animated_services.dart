import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_maps/widgets/splash-landing/animated_text.dart';

enum AnimationType {
  Character,
  SlideDown
}

class AnimatedServicesText extends StatefulWidget {

  final int delayInMilliseconds;

  AnimatedServicesText(this.delayInMilliseconds);

  @override
  State createState() => new _AnimationState();
}

class _AnimationState extends State<AnimatedServicesText>
    with SingleTickerProviderStateMixin {

  AnimationController animationController;
  Animation<Alignment> locationSlideOut;
  Animation<double> locationFadeOut;

  Animation<Alignment> speedSlideIn;
  Animation<double> speedFadeIn;
  Animation<Alignment> speedSlideOut;
  Animation<double> speedFadeOut;

  Animation<Alignment> vehiclesSlideIn;
  Animation<double> vehiclesFadeIn;

  String firstService = "Location";
  String secondService = "Live Speed";
  String thirdService = "Nearby Vehicles";

  @override
  void initState() {
    super.initState();

    animationController =
    new AnimationController(vsync: this, duration: new Duration(seconds: 6));

    locationSlideOut = new AlignmentTween(
        begin: new Alignment(-1.0, 0.0), end: new Alignment(-1.0, 1.0))
        .animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.4, 0.45, curve: Curves.easeIn)));
    locationFadeOut = new Tween<double>(begin: 1.0, end: 0.0)
        .animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.42, 0.45, curve: Curves.easeIn)));

    speedSlideIn = new AlignmentTween(
      begin: new Alignment(-1.0, -1.0), end: new Alignment(-1.0, 0.0),
    ).animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.42, 0.45, curve: Curves.easeIn)));
    speedFadeIn = new Tween<double>(begin: 0.0, end: 1.0)
        .animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.42, 0.45)));

    speedSlideOut = new AlignmentTween(
        begin: new Alignment(-1.0, 0.0), end: new Alignment(-1.0, 1.0))
        .animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.8, 0.85, curve: Curves.easeIn)));
    speedFadeOut = new Tween<double>(begin: 1.0, end: 0.0)
        .animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.82, 0.85)));

    vehiclesSlideIn = new AlignmentTween(
        begin: new Alignment(-1.0, -1.0), end: new Alignment(-1.0, 0.0))
        .animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.8, 0.85, curve: Curves.easeIn)));
    vehiclesFadeIn = new Tween<double>(begin: 0.0, end: 1.0)
        .animate(new CurvedAnimation(parent: animationController,
        curve: new Interval(0.82, 0.85)));

    locationFadeOut.addListener(() {
      locationSlideOut.addListener(() {
        setState(() {});
      });
      setState(() {});
    });

    speedSlideIn.addListener(() {
      setState(() {});
    });
    speedFadeIn.addListener(() {
      setState(() {});
    });

    speedSlideOut.addListener(() {
      setState(() {});
    });
    speedFadeOut.addListener(() {
      setState(() {});
    });

    vehiclesSlideIn.addListener(() {
      setState(() {});
    });
    vehiclesFadeIn.addListener(() {
      setState(() {});
    });

    new Future.delayed(
        new Duration(milliseconds: widget.delayInMilliseconds + 500))
        .then((_) {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: 40.0,
      child: new Stack(
        children: <Widget>[
          // London
          new Align(
            alignment: locationSlideOut.value,
            child: new Opacity(
              opacity: locationFadeOut.value,
              child: new AnimatedText("London", widget.delayInMilliseconds,
                durationInMilliseconds: 500,
                textStyle: new TextStyle(color: Colors.green,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500),),
            ),
          ),
          // New York
          new AlignTransition(
            alignment: !(speedSlideIn.value.y == 0.0)
                ? speedSlideIn
                : speedSlideOut,
            child: new Opacity(
              opacity: !(speedFadeIn.value == 1.0)
                  ? speedFadeIn.value
                  : speedFadeOut.value,
              child: new Text(secondService, style: new TextStyle(
                  color: Colors.lightBlue.withOpacity(0.7),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // Los Angeles
          new Align(
            alignment: vehiclesSlideIn.value,
            child: new Opacity(
              opacity: vehiclesFadeIn.value,
              child: new Text(thirdService, style: new TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500),),
            ),
          ),

        ],
      ),
    );
  }

}