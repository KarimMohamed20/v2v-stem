import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'widgets/Drawer.dart';

class Home extends StatefulWidget {
  final uid;

  Home({@required this.uid});

  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  var databaseReference = FirebaseDatabase.instance.reference();
  MapType _currentMapType = MapType.satellite;
  var name = '';
  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;
  int _page = 1;

  static GoogleMapController mapController;

  StreamSubscription subscription;

  Location location = new Location();
  String error;
  Map<String, double> currentLocation = new Map();

  void updateDatabase() {
    databaseReference.child(widget.uid).update({
      "latitude": currentLocation['latitude'],
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

  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: Size(30, 30));

    const AssetImage('assets/car.png')
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
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
          if (event.snapshot.key == widget.uid) {
            name = event.snapshot.value['name'];
          }
          if (uidMarkers.contains(event.snapshot.key) == true) {
            markers.removeWhere(
                (marker) => marker.markerId.value == event.snapshot.key);
            uidMarkers.add(event.snapshot.key);
            print("Added: ${event.snapshot.key}");
            markers.add(
              Marker(
                  icon: await _getAssetIcon(context),
                  markerId: MarkerId(
                    event.snapshot.key,
                  ),
                  position: LatLng(
                      double.parse(event.snapshot.value['latitude'].toString()),
                      double.parse(
                          event.snapshot.value['longitude'].toString())),
                  infoWindow: InfoWindow(
                      title: event.snapshot.value['name'],
                      snippet: event.snapshot.value['carModel'])),
            );
            print(
              LatLng(double.parse(event.snapshot.value['latitude'].toString()),
                  double.parse(event.snapshot.value['longitude'].toString())),
            );
          } else {
            uidMarkers.add(event.snapshot.key);

            markers.add(Marker(
              icon: await _getAssetIcon(context),
              markerId: MarkerId(
                event.snapshot.key,
              ),
              infoWindow: InfoWindow(
                  title: event.snapshot.value['name'],
                  snippet: event.snapshot.value['carModel']),
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
    LocationData myLocation;
    try {
      myLocation = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      myLocation = null;
    }
    setState(() {
      currentLocation = {
        "latitude": myLocation.latitude,
        "longitude": myLocation.longitude
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
      body: _page == 1
          ? Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Cars in street',
                ),
                centerTitle: true,
                backgroundColor: Colors.indigo,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _onMapTypeButtonPressed,
                child: Icon(Icons.satellite),
                backgroundColor: Colors.indigoAccent,
                hoverColor: Colors.white,
                elevation: 20,
                isExtended: true,
              ),
              drawer: SideDraw(
                name: name,
              ),
              body: Stack(
                children: <Widget>[
                  GoogleMap(
                    markers: markers,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLatitude, currentLongitude),
                        zoom: 20),
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    mapType: _currentMapType,
                    onMapCreated: _onMapCreated,
                  ),
                ],
              ),
            )
          : _page == 0
              ? Center(child: Text('First Page'))
              : ProfilePage(
                  uid: widget.uid,
                ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        index: _page,
        animationCurve: Curves.easeOutCubic,
        color: Colors.grey.shade50,
        buttonBackgroundColor: Colors.grey.shade100,
        items: <Widget>[
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.navigation, size: 30),
          Icon(Icons.person_pin, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
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
