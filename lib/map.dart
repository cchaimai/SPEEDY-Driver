import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedy/balance.dart';
import 'package:speedy/request.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<Position>? positionStream;
  Position? currentLocation;

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    currentLocation = await Geolocator.getCurrentPosition();
    positionStream = Geolocator.getPositionStream().listen((position) {
      currentLocation = position;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    print("--------------$userId----------------------");
  }

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('dUsers').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            return currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(children: [
                    GoogleMap(
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude,
                            currentLocation!.longitude),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("currentLocation"),
                          position: LatLng(currentLocation!.latitude,
                              currentLocation!.longitude),
                        ),
                      },
                      onMapCreated: (mapController) {
                        _controller.complete(mapController);
                      },
                    ),
                    Positioned(
                      top: 60,
                      left: 5,
                      child: PopupMenuButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: const Color(0xff3BB54A),
                        position: PopupMenuPosition.under,
                        icon: const Icon(Icons.savings),
                        iconSize: 40,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                                "รายได้ \n${snapshot.data!.docs.singleWhere((doc) => doc.id == userId)['wallet']} ฿",
                                style: GoogleFonts.prompt(color: Colors.white)),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BalanceScreen()));
                              break;
                          }
                        },
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 5,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!.docs
                                    .singleWhere((doc) => doc.id == userId)[
                                'driverProfile']),
                            radius: 30,
                          ),
                        ),
                      ),
                    )
                  ]);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff3BB54A),
        icon: const Icon(Icons.power_settings_new),
        label: Text(
          "START",
          style: GoogleFonts.prompt(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestScreen(
                    lat: currentLocation!.latitude,
                    long: currentLocation!.longitude),
              ));
        },
      ),
    );
  }
}
