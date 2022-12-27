import 'dart:html';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Get the current location of the user',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Homepage());
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String LocationMessage = 'Get Current Location';
  late String lat;
  late String long;

  // Future<void> _openMap(String lat, String long) async {
  //   String googleUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  //   await canLaunchUrlString(googleUrl)
  //       ? await launchUrlString(googleUrl)
  //       : throw 'Could not open the map.';
  // }
  Future<void> _openMap() async {
    Position position = await _getCurrentLocation();
    String lat = '${position.latitude}';
    String long = '${position.longitude}';
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleUrl)
        ? await launchUrlString(googleUrl)
        : throw 'Could not open the map.';
  }

//To check if service location is on or not.
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services vare disabled');
    }
    //To get the permission
    LocationPermission permission = await Geolocator.checkPermission();
    //We will request the permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location services vare disabled');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied we cant request location');
    }
    return await Geolocator.getCurrentPosition();
  }

  //Listen to local update

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        LocationMessage = 'Latitude:$lat , Longitude:$long';
      });
    });
  }

  // Future<void> _openMap(String lat,String long) async {
  //   String googleUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  //   await canLaunchUrlString(googleUrl)
  //       ? await launchUrlString(googleUrl)
  //       : throw 'Could not open the map.';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          centerTitle: true,
          title: (Text('Live Locator',
              style: GoogleFonts.dmSerifDisplay(
                  textStyle: const TextStyle(fontSize: 24)))),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              LocationMessage,
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize:
                          24)), // style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 24)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  _getCurrentLocation().then(((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    setState(() {
                      LocationMessage = 'Latitude:$lat , Longitude:$long';
                      // print('Latitude:$lat,Longitude:$long');
                    });
                    _liveLocation();
                  }));
                },
                label: const Text('Get Current Location'),
                icon: const Icon(Icons.location_searching_sharp)),
                const SizedBox(
              height: 20,
            ),
            
            // Create an elevated button
            ElevatedButton.icon(
                onPressed: () async {
                  await _openMap();
                },
                icon: const Icon(Icons.map_sharp),
                label: const Text('Open Google Maps')),
          ],
        )));
  }
}
