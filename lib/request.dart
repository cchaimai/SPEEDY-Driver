import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/detail.dart';
import 'package:speedy/map.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key, required this.lat, required this.long});
  final double lat;
  final double long;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        centerTitle: true,
        title: Text("request", style: GoogleFonts.prompt()),
        backgroundColor: const Color(0xff1f1f1f),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("requests")
              .where("status", isEqualTo: 'Wait')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.data!.docs.isNotEmpty) {
              return Center(
                child: Text("ยังไม่มีงานในขณะนี้",
                    style: GoogleFonts.prompt(fontSize: 22)),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                        leading: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff3BB54A),
                          radius: 30,
                          child: Text(
                            "${calculateDistance(widget.lat, widget.long, snapshot.data!.docs[index]['Ulatitude'], snapshot.data!.docs[index]['Ulongitude']).toStringAsFixed(1)} \nกม.",
                            style: GoogleFonts.prompt(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        title: Text(
                            "No.${snapshot.data!.docs[index]['workID']}",
                            style: GoogleFonts.prompt()),
                        subtitle: Text(
                          "${snapshot.data!.docs[index]['chargetype']}  รายรับ: ${(snapshot.data!.docs[index]['price'] * 0.85).toStringAsFixed(0)}฿",
                          style: GoogleFonts.prompt(),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              sendTime(snapshot, index).then((value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      workID: snapshot.data!.docs[index].id,
                                      distance: calculateDistance(
                                          widget.lat,
                                          widget.long,
                                          snapshot.data!.docs[index]
                                              ['Ulatitude'],
                                          snapshot.data!.docs[index]
                                              ['Ulongitude']),
                                    ),
                                  ),
                                );
                              });
                            },
                            icon: const Icon(Icons.arrow_forward_ios))),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: () {
        sendData();
      }),
    );
  }

  Future<void> sendTime(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(snapshot.data!.docs[index].id)
        .set({
      "sTimestamp": FieldValue.serverTimestamp(),
      'dlatitude': widget.lat,
      'dlongitude': widget.long,
    }, SetOptions(merge: true));
  }

  Future<void> sendData() async {
    await FirebaseFirestore.instance.collection('requests').doc().set({
      'Uname': "earth",
      'chargetype': "Type 2",
      'energy': "7.2",
      'Ulatitude': 13.11533244163535,
      'Ulongitude': 100.92545502431265,
      'price': 100,
      'status': 'Wait',
      'workID': 'SDBASE',
      'UcarID': 'กก 5555',
      'cartype': 'tesla',
      'UPhone': '0836064300'
    }, SetOptions(merge: true));
  }
}
