import 'dart:async';
import 'package:flutter/services.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  static final databaseReference = FirebaseDatabase.instance.reference();

  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;

  static GoogleMapController mapController;

  StreamSubscription subscription;

  Location location = new Location();
  String error;

  Map<String, double> currentLocation = new Map();

  String _deviceid = 'Unknown';

  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = await DeviceId.getID;

    if (!mounted) return;

    setState(() {
      _deviceid = deviceid;
    });
  }

  void updateDatabase() {
    databaseReference.child(_deviceid).set({
      'latitude': currentLocation['latitude'],
      'longitude': currentLocation['longitude'],
    });
  }

  Future sendMyLocation() async {
    initDeviceId();

    initPlatformState();
    location.onLocationChanged().listen((result) {
      setState(() async {
        currentLocation = {
          "latitude": result.latitude,
          "longitude": result.longitude
        };
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    currentLocation['latitude'], currentLocation['longitude']),
                zoom: 17),
          ),
        );
        updateDatabase();
      });
    });
    return null;
  }

  void mergePostandGet() async {
    await sendMyLocation();
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        subscription = FirebaseDatabase.instance
            .reference()
            .child(key)
            .onValue
            .listen((event) {
          setState(() {
            currentLatitude = event.snapshot.value['latitude'];
            currentLongitude = event.snapshot.value['longitude'];
          });
          mapController.clearMarkers();
          mapController.addMarker(
            MarkerOptions(
              position: LatLng(event.snapshot.value['latitude'],
                  event.snapshot.value['longitude']),
            ),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    mergePostandGet();
  }

  void initPlatformState() async {
    LocationData my_location;
    try {
      my_location = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      my_location = null;
    }
    setState(() {
      currentLocation = {
        "latitude": my_location.latitude,
        "longitude": my_location.longitude
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('V2V STEM')),
        body: Container(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(currentLatitude, currentLongitude), zoom: 17),
              onMapCreated: _onMapCreated,
            ),
          ),
        ));
  }
}
