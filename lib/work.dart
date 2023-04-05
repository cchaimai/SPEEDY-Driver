import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedy/end.dart';
import 'package:speedy/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_page.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen(
      {super.key,
      required this.workID,
      required this.dlat,
      required this.dlong,
      required this.groupId,
      required this.phone});
  final String workID;
  final double dlat;
  final double dlong;
  final String groupId;
  final String phone;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  GoogleMapController? mapController;
  List<LatLng> polylineCoordinates = [];
  StreamSubscription<Position>? positionStream;
  Position? currentLocation;
  String name = '';
  String dName = '';
  String brand = '';
  String carID = '';
  String type = '';
  String energy = '';
  String phone = '';
  String uPhone = '';
  String chatID = '';

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

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
    getPolyPoints(LatLng(widget.dlat, widget.dlong));
  }

  void getPolyPoints(LatLng dst) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCdE_5Jk5nE3do7cWezCTL561MBCaGx9p0",
      PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
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

  Future<void> getUserData() async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('requests').doc(widget.workID);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    name = userDocSnapshot.get('Uname');
    dName = userDocSnapshot.get('dName');
    brand = userDocSnapshot.get('cartype');
    carID = userDocSnapshot.get('UcarID');
    type = userDocSnapshot.get('chargetype');
    energy = userDocSnapshot.get('energy');
    phone = userDocSnapshot.get('UPhone');
    uPhone = phone.replaceFirst('+66', '0');
    chatID = userDocSnapshot.get('chatID');
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
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
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude,
                          currentLocation!.longitude),
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
                        position: LatLng(currentLocation!.latitude,
                            currentLocation!.longitude),
                      ),
                      Marker(
                        markerId: const MarkerId("destination"),
                        position: LatLng(
                          widget.dlat,
                          widget.dlong,
                        ),
                        infoWindow: const InfoWindow(
                          title: 'จุดหมาย',
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(127),
                      ),
                    },
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 20),
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
                          width: 40,
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
                                "${calculateDistance(currentLocation!.latitude, currentLocation!.longitude, widget.dlat, widget.dlong).toStringAsFixed(2)} Km",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xff3BB54A),
                          radius: 25,
                          child: IconButton(
                            onPressed: () {
                              nextScreen(
                                context,
                                ChatPage(
                                  groupId: widget.groupId,
                                  groupName: widget.phone,
                                  userName: dName,
                                  phone: uPhone,
                                  uName: name,
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble),
                            color: Colors.white,
                            iconSize: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      popUb3(context, name, brand, carID, type, energy);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Icon(
                      Icons.list_alt,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(currentLocation!.latitude,
                                currentLocation!.longitude),
                            zoom: 15.0,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.black,
                      size: 30,
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
                    ),
                  ),
                ),
                Positioned(
                  right: 85,
                  bottom: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      // if (calculateDistance(
                      //         currentLocation!.latitude!,
                      //         currentLocation!.longitude!,
                      //         widget.dlat,
                      //         widget.dlong) <
                      //     0.1) {
                      //   popUb1(context);
                      // } else {
                      //   popUb2(context);
                      // }
                      popUb1(context);
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

  popUb1(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          backgroundColor: const Color(0xff1f1f1f),
          title: Center(
            child: Text(
              "ถึงจุดหมายแล้ว",
              style: GoogleFonts.prompt(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                sendETime().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EndScreen(
                        workID: widget.workID,
                      ),
                    ),
                    (route) => false,
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3BB54A),
                fixedSize: const Size(75, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                "ยืนยัน",
                style: GoogleFonts.prompt(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF21616),
                fixedSize: const Size(75, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                "ยกเลิก",
                style: GoogleFonts.prompt(),
              ),
            ),
          ],
        );
      },
    );
  }

  popUb2(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color(0xff1f1f1f),
          title: Center(
            child: Text(
              "กรุณาไปยังจุดหมาย",
              style: GoogleFonts.prompt(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  popUb3(BuildContext context, String name, String brand, String carID,
      String type, String energy) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color(0xff1f1f1f),
          title: Text(
            "ข้อมูลลูกค้า",
            style: GoogleFonts.prompt(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          content: Text(
              "ชื่อ : $name\nยี่ห้อรถ : $brand\nทะเบียน : $carID\nหัวชาร์จ : $type\nปริมาณ : $energy kWh",
              style: GoogleFonts.prompt(
                color: Colors.white,
              )),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  Future<void> sendETime() async {
    FirebaseFirestore.instance.collection('groups').doc(chatID).delete();
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.workID)
        .set({
      "eTimestamp": FieldValue.serverTimestamp(),
      "status": "Done",
    }, SetOptions(merge: true));
  }
}
