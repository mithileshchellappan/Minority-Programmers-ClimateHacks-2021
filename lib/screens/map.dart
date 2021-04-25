import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lo;
import 'package:lottie/lottie.dart' as lottie;

const EVENTS_KEY = "fetch_events";

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

const fetchBackground = "fetchBackground";
String _mapStyle;

class MapSampleState extends State<MapSample> {
  bool _enabled = true;
  int _status = 0;
  List<String> _events = [];
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool syncExists;

  LatLng _center;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.2189, 78.1674),
    zoom: 1,
  );
  Position userPoss = Position();
  Future<bool> isDisabled;
  bool isDisabledNotFu;
  lo.Location location;
  Timer timer;
  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((value) {
      _mapStyle = value;
    });
    addMarker();

    super.initState();
    // initPlatformState();
  }

  GoogleMapController mapController;

  addMarker() {
    _database.collection('posts')
      ..get().then((value) {
        if (value.docs.isNotEmpty) {
          for (int i = 0; i < value.docs.length; i++) {
            print(value.docs.length);
            print(value.docs[i].data()['location'].latitude);
            initMarker(
                value.docs[i].data()['location'],
                value.docs[i].data()['post-id'],
                value.docs[i].data()['caption']);
          }
        }
      });
  }
  List<LatLng> latlngs = [
      LatLng(31.633210000045406, 86.89264979213476),
      LatLng(24.152493812219426, 76.46366022527218),
      LatLng(22.73045683553091, 97.21838738769293),
      LatLng(23.8693176011034, 45.8994871750474),
      LatLng(17.689955422233577, 30.617423616349697),
      LatLng(51.54114117436186, -2.218409813940525),
      LatLng(60.55155623434634, 9.243156127631664)
    ];

  addMarkerOn() {
    print('running add marker on');
    
    for (LatLng x in latlngs) {
      initMarker(GeoPoint(x.latitude, x.longitude), '${x.hashCode}', 'random');
    }
  }

  removeMarkerOn() {
   print('in remove');
      for(LatLng x in latlngs){
        print('in for');
      markers.removeWhere((key, value) => value.markerId.toString() == x.hashCode.toString());
      }  
      setState(() {
        
      });
    
  }

  void initMarker(GeoPoint geoPoint, String uid, String caption) {
    var markerIdVal = uid;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        onTap: () {
          print('tapped');
        },
        markerId: markerId,
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
        infoWindow: InfoWindow(title: caption));
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: lottie.Lottie.asset("assets/loading.json"));
            }
            return Stack(
              children: [
                GoogleMap(
                  markers: Set<Marker>.of(markers.values),
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    controller.setMapStyle(_mapStyle);
                  },
                ),
              ],
            );
          }),
      floatingActionButton: SpeedDial(
        icon: Icons.leaderboard,
        backgroundColor: Colors.lightGreen,
        curve: Curves.easeIn,
        children: [
          SpeedDialChild(child: Icon(Icons.public), onTap: addMarkerOn),
          SpeedDialChild(child: Icon(Icons.people),onTap: removeMarkerOn)
        ],
      ),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
