import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  final uid;
  Home({@required this.uid});
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  var databaseReference = FirebaseDatabase.instance.reference();
  MapType _currentMapType = MapType.satellite;

  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;

  static GoogleMapController mapController;

  StreamSubscription subscription;

  Location location = new Location();
  String error;

  Map<String, double> currentLocation = new Map();


  void updateDatabase() {
    databaseReference.child(widget.uid).update({
      "latitude":currentLocation['latitude'],
      "longitude": currentLocation['longitude']
    });
  }

  Future sendMyLocation() async {
    initPlatformState();
    location.onLocationChanged().listen((result) {
      setState(() {
        currentLocation = {
          "latitude": result.latitude,
          "longitude": result.longitude
        };
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    currentLocation['latitude'], currentLocation['longitude']),
                zoom: 20),
          ),
        );
        updateDatabase();
      });
    });
    return null;
  }

  var uidMarkers = [];
  Set<Marker> markers = {};
  void mergePostandGet() async {
    await sendMyLocation();
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> snapValue = snapshot.value;

      snapValue.forEach((key, values) {
        print(key);
        subscription = FirebaseDatabase.instance
            .reference()
            .child(key)
            .onValue
            .listen((event) async {
          print(event.snapshot.key);
          if (uidMarkers.contains(event.snapshot.key) == true) {
            markers.removeWhere(
                (marker) => marker.markerId.value == event.snapshot.key);
            uidMarkers.add(event.snapshot.key);
            print("Added: ${event.snapshot.key}");
            markers.add(
              Marker(
                  markerId: MarkerId(
                    event.snapshot.key,
                  ),
                  
                  position: LatLng(
                      double.parse(event.snapshot.value['latitude'].toString()),
                      double.parse(
                          event.snapshot.value['longitude'].toString())),
                  infoWindow: InfoWindow(

                      title: event.snapshot.value['name'] ,
                      snippet: event.snapshot.value['carModel'] )),
            );
            print(
              LatLng(double.parse(event.snapshot.value['latitude'].toString()),
                  double.parse(event.snapshot.value['longitude'].toString())),
            );
          } else {
            uidMarkers.add(event.snapshot.key);

            markers.add(Marker(
              markerId: MarkerId(
                event.snapshot.key,
              ),
              position: LatLng(
                  double.parse(event.snapshot.value['latitude'].toString()),
                  double.parse(event.snapshot.value['longitude'].toString())),
            ));
          }
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
      appBar: AppBar(
        title: const Text(
          'Cars in street',
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: markers,
            initialCameraPosition: CameraPosition(
                target: LatLng(currentLatitude, currentLongitude), zoom: 20),
            compassEnabled: true,
            mapType: _currentMapType,
            onMapCreated: _onMapCreated,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onMapTypeButtonPressed,
        child: Icon(Icons.satellite),
        backgroundColor: Colors.indigoAccent,
        hoverColor: Colors.white,
        elevation: 20,
        isExtended: true,
      ),
    );
  }

  buttons() {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 80,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FlatButton(
            color: Colors.white70,
            onPressed: _onMapTypeButtonPressed,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            // backgroundColor: Colors.green,
            child: const Icon(
              Icons.satellite,
              size: 25.0,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  map() {
    return null;
  }
}
