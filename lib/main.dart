import 'dart:html';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

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
  late String lat;
  late String long;

  late String LocationMessage = 'Get Current Location';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          centerTitle: true,
          title: ( Text(
            'Live Locator', style: GoogleFonts.dmSerifDisplay(textStyle: TextStyle(fontSize: 24))
          )),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              LocationMessage,
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 24)), // style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 24)),
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
                  }));
                },
                label: Text('Get Current Location'),
                icon: Icon(Icons.location_searching_sharp)),
          ],
        )));
  }
}
