import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  Map<String,double> currentLocation = new Map();
  Stream<Map<String,double>> locationSubscription;

  //Location location = new Location();
  String error;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-0.169268, -78.471341),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-0.169268, -78.471341),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void initPlatformState() async {
    Map<String,double> whereAmI;
    try {
      whereAmI = null;//await location.getLocation();
      error = "";
    } on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED')
        error = 'GeoLocation permission denied';
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Geolocation permission denied - please ask the user to enable it in the app settings';
      whereAmI = null;
    }
    setState(() {
      currentLocation = whereAmI;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _irAlLugar,
        label: Text('Ir A  Ubicacion'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _irAlLugar() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

