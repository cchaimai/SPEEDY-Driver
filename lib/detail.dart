import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:speedy/work.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.userid, required this.distance});
  final String userid;
  final num distance;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  LocationData? currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<DocumentSnapshot>? _documentStream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff292929),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff1f1f1f),
        elevation: 0,
        title: Text(
          "details",
          style: GoogleFonts.prompt(),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('requests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 600,
                height: 280,
                decoration: const BoxDecoration(
                  color: Color(0xff1f1f1f),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
              ),
              Text(
                "PowerBank",
                style: GoogleFonts.prompt(
                    color: const Color(0xff292929),
                    fontWeight: FontWeight.bold,
                    fontSize: 70),
              ),
              Image.network(
                "https://cdn.discordapp.com/attachments/956974071193698424/1076810278081146890/Tesla-PNG-Photos.png",
                width: 320,
                height: 260,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 220),
                child: Container(
                  width: 320,
                  height: 420,
                  decoration: const BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.all(
                      Radius.circular(19),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 320,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Color(0xffBBBABA),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(19),
                              topRight: Radius.circular(19)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 18),
                          child: Row(
                            children: [
                              Image.asset("assets/images/logo2.png"),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text("no."),
                                    Text(
                                      "xxxxxx",
                                      style: GoogleFonts.prompt(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "ระยะห่างจากคุณ ${widget.distance.toStringAsFixed(2)} กม.",
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Row(
                          children: [
                            Text(
                              "Time: ${snapshot.data!.docs.singleWhere((doc) => doc.id == widget.userid)['STime']}",
                              style: text1(),
                            ),
                            Expanded(
                              child: Text(
                                "Charger Type: ?",
                                textAlign: TextAlign.center,
                                style: text1(),
                              ),
                            ),
                            Text(
                              "Energy: ?",
                              style: text1(),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Color(0xff292929),
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Flex(
                                direction: Axis.horizontal,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  (constraints.constrainWidth() / 10).floor(),
                                  (index) => const SizedBox(
                                    height: 1,
                                    width: 5,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                color: Color(0xff292929),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                snapshot.data!.docs
                                    .singleWhere((doc) =>
                                        doc.id == widget.userid)['price']
                                    .toString(),
                                style: GoogleFonts.prompt(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 48,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "รายได้สุทธิ",
                                  style: GoogleFonts.prompt(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "+",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                "?",
                                style: GoogleFonts.prompt(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48,
                                  color: const Color(0xff26A400),
                                ),
                              ),
                              Text(
                                "โบนัสการรอ",
                                style: GoogleFonts.prompt(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff26A400),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //DatabaseService(uid: widget.userid).sendLocation();
                          _sendLocation();
                          _chagneStatus();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkScreen(
                                  userid: widget.userid,
                                  dlat: snapshot.data!.docs.singleWhere((doc) =>
                                      doc.id == widget.userid)['latitude'],
                                  dlong: snapshot.data!.docs.singleWhere(
                                      (doc) =>
                                          doc.id == widget.userid)['longitude'],
                                ),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3BB54A),
                          fixedSize: const Size(180, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          "รับงาน",
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _sendLocation() async {
    Location location = Location();
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      // ignore: avoid_print
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((currentLocation) async {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.userid)
          .set({
        'dlatitude': currentLocation.latitude,
        'dlongitude': currentLocation.longitude,
      }, SetOptions(merge: true));
    });
    _documentStream = FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.userid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        _stopLocation();
      }
    });
  }

  void _stopLocation() {
    _documentStream?.cancel();
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  Future<void> _chagneStatus() async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.userid)
        .set({
      //'status': true,
    }, SetOptions(merge: true));
  }

  TextStyle text1() => GoogleFonts.prompt(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );
}
