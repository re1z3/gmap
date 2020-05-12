import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:latlong/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Hello',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        //brightness: Brightness.dark,
      ),
      home: MapClass(),
    );
  }
}

class MapClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapClassState();
  }
}

class MapClassState extends State<MapClass> {
  GoogleMapController googleMapController;
  String searchAddress;
  var currentLocation;
  bool mapToggle = false;
  List<Marker> allMarkers = [];

  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('my marker'),
      draggable: true,
      onTap: () {
        debugPrint('Marker Tapped');
      },
      position: LatLng(currentLocation.latitude,currentLocation.longitude),
    ));
    Geolocator().getCurrentPosition().then((currentLoc) {
      setState(() {
        currentLoc = currentLocation;
        mapToggle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map Finder'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Colors.deepOrange,
                  Colors.deepOrangeAccent,
                ])),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Material(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Image.asset('image/googlemaps.png',
                                width: 80, height: 80),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'LocationFinderApp',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 80.0,
                    width: MediaQuery.of(context).size.width,
                    child: mapToggle
                        ? GoogleMap(
                            mapType: MapType.normal,
                            onMapCreated: OnMapCreated,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                zoom: 10.0),
                            markers: Set.from(allMarkers),
                          )
                        : Center(
                            child: Text(
                              'Loading....please wait..',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          )),
                Positioned(
                  top: 15,
                  right: 15,
                  left: 15,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Input Desired Address',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: searchAndNavigate,
                            iconSize: 30.0,
                          )),
                      onChanged: (val) {
                        searchAddress = val;
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () {
            debugPrint('FAB button pressed');
          },
        ));
  }

  // ignore: non_constant_identifier_names
  void OnMapCreated(controller) {
    setState(() {
      googleMapController = controller;
    });
  }

  void searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((result) {
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(result[0].position.latitude, result[0].position.longitude),
        zoom: 10.0,
      )));
    });
  }

  void liveLocation() {
    GoogleMap(
      onMapCreated: OnMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 10.0,
      ),
    );
  }
}
