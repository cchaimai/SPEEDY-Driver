import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speedy/work.dart';

import 'firebase/database_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.workID, required this.distance});
  final String workID;
  final num distance;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  StreamSubscription<Position>? positionStream;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String fname = '';
  String carID = '';
  String phone = '';
  String chat = '';
  String dProfile = '';
  String? groupId;

  Future<void> getUserData() async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('dUsers').doc(userId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    fname = userDocSnapshot.get('firstName');
    carID = userDocSnapshot.get('carID');
    phone = userDocSnapshot.get('phoneNumber');
    // chat = userDocSnapshot.get('chat');
    dProfile = userDocSnapshot.get('driverProfile');
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

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
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('requests').get(),
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
              Image.asset(
                "assets/images/Tesla.png",
                width: 320,
                height: 260,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEEEEE),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data!.docs.singleWhere(
                            (doc) => doc.id == widget.workID)['UcarID'],
                        style: GoogleFonts.prompt(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      // Text(
                      //   snapshot.data!.docs.singleWhere(
                      //       (doc) => doc.id == widget.workID)['province'],
                      //   style: GoogleFonts.prompt(
                      //       fontSize: 12, fontWeight: FontWeight.w500),
                      // ),
                    ],
                  ),
                ),
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
                                    Text(
                                      "no.",
                                      style: GoogleFonts.prompt(fontSize: 12),
                                    ),
                                    Text(
                                      snapshot.data!.docs.singleWhere((doc) =>
                                          doc.id == widget.workID)['workID'],
                                      style: GoogleFonts.prompt(
                                        fontWeight: FontWeight.w500,
                                      ),
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
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time",
                                  style: text1(),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(snapshot.data!.docs
                                      .singleWhere((doc) =>
                                          doc.id == widget.workID)['sTimestamp']
                                      .toDate()),
                                  style: text2(),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Brand",
                                  style: text1(),
                                ),
                                Text(
                                  snapshot.data!.docs.singleWhere((doc) =>
                                      doc.id == widget.workID)['cartype'],
                                  style: text2(),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Charger Type",
                                  textAlign: TextAlign.center,
                                  style: text1(),
                                ),
                                Text(
                                    snapshot.data!.docs.singleWhere((doc) =>
                                        doc.id == widget.workID)['chargetype'],
                                    textAlign: TextAlign.center,
                                    style: text2()),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Energy",
                                  style: text1(),
                                ),
                                Text(
                                  "${snapshot.data!.docs.singleWhere((doc) => doc.id == widget.workID)['energy']}kWh",
                                  style: text2(),
                                ),
                              ],
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
                                "${(snapshot.data!.docs.singleWhere((doc) => doc.id == widget.workID)['price'] * 0.85).toStringAsFixed(0)}฿",
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
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String groupId = await DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .createGroup(
                                  fname,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  phone);
                          sendData(groupId);
                          print(
                              '--------------------------$groupId---------------------------------------');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkScreen(
                                workID: widget.workID,
                                dlat: snapshot.data!.docs.singleWhere((doc) =>
                                    doc.id == widget.workID)['Ulatitude'],
                                dlong: snapshot.data!.docs.singleWhere((doc) =>
                                    doc.id == widget.workID)['Ulongitude'],
                                groupId: groupId,
                                phone: phone,
                              ),
                            ),
                            (route) => false,
                          );
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

  Future<void> sendData(String group) async {
    positionStream =
        Geolocator.getPositionStream().listen((currentLocation) async {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.workID)
          .set({
        'dlatitude': currentLocation.latitude,
        'dlongitude': currentLocation.longitude,
      }, SetOptions(merge: true));
    });

    await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.workID)
        .set({
      'dUserID': userId,
      'dName': fname,
      'dCarID': carID,
      'dPhone': phone,
      'dProfile': dProfile,
      'chatID': group,
      'status': 'Accepted',
    }, SetOptions(merge: true));

    DocumentReference requestDocRef =
        FirebaseFirestore.instance.collection('requests').doc(widget.workID);

    Stream<DocumentSnapshot> requestDocStream = requestDocRef.snapshots();

    requestDocStream.listen((event) {
      Map<String, dynamic> requestData = event.data() as Map<String, dynamic>;
      if (requestData['status'] == 'Done') {
        positionStream?.cancel();
        positionStream = null;
      }
    });
  }

  TextStyle text1() => GoogleFonts.prompt(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black45,
      );

  TextStyle text2() => GoogleFonts.prompt(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );
}
