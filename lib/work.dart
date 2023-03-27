import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:speedy/end.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen(
      {super.key,
      required this.userid,
      required this.dlat,
      required this.dlong});
  final String userid;
  final double dlat;
  final double dlong;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  double distance = 0.0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLoc) {
        setState(() {
          currentLocation = newLoc;
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 15,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
        });
      },
    );
    getPolyPoints(LatLng(widget.dlat, widget.dlong));
  }

  void getPolyPoints(LatLng dst) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCdE_5Jk5nE3do7cWezCTL561MBCaGx9p0",
      PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      PointLatLng(dst.latitude, dst.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }
    setState(() {});
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/Vector.png")
        .then((icon) {
      sourceIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("map", style: GoogleFonts.prompt()),
        backgroundColor: const Color(0xff1f1f1f),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.menu),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          )
        ],
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: 15,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polylineCoordinates,
                        color: Colors.green,
                        width: 5,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                      ),
                      Marker(
                          markerId: const MarkerId("destination"),
                          position: LatLng(
                            widget.dlat,
                            widget.dlong,
                          ),
                          infoWindow: const InfoWindow(title: 'จุดหมาย'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(127)),
                    },
                    onMapCreated: (mapController) {
                      _controller.complete(mapController);
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset.zero)
                        ]),
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "You are",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Driving!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(
                          width: 30,
                          indent: 0,
                          endIndent: 0,
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Distance",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "${calculateDistance(currentLocation!.latitude!, currentLocation!.longitude!, widget.dlat, widget.dlong).toStringAsFixed(2)} Km",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xff3BB54A),
                          radius: 23,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.phone_enabled),
                            color: Colors.white,
                            iconSize: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundColor: const Color(0xff3BB54A),
                            radius: 23,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_bubble),
                              color: Colors.white,
                              iconSize: 27,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 15,
                  child: ElevatedButton(
                      onPressed: () async {
                        await launchUrl(Uri.parse(
                            'google.navigation:q=${widget.dlat}, ${widget.dlong}&key=AIzaSyCdE_5Jk5nE3do7cWezCTL561MBCaGx9p0'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Icon(
                        Icons.near_me_outlined,
                        color: Colors.black,
                        size: 30,
                      )),
                ),
                Positioned(
                  right: 85,
                  bottom: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      _sendETime();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EndScreen(
                                    userid: widget.userid,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1f1f1f),
                      fixedSize: const Size(160, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "ถึงจุดหมายแล้ว",
                          style:
                              GoogleFonts.prompt(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  _sendETime() async {
    await firestore.collection('requests').doc(widget.userid).set(
        {'ETime': DateFormat('HH:mm').format(DateTime.now())},
        SetOptions(merge: true));
  }
}