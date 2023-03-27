import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speedy/detail.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key, required this.lat, required this.long});
  final double lat;
  final double long;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("requests")
              .where("status", isEqualTo: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff3BB54A),
                    radius: 30,
                    child: FittedBox(
                      child: Text(
                          "${calculateDistance(widget.lat, widget.long, snapshot.data!.docs[index]['latitude'], snapshot.data!.docs[index]['longitude']).toStringAsFixed(1)} กม.",
                          style: GoogleFonts.prompt()),
                    ),
                  ),
                  title: Text(snapshot.data!.docs[index]['user'],
                      style: GoogleFonts.prompt()),
                  subtitle: Text(
                    snapshot.data!.docs[index]['price'].toString(),
                    style: GoogleFonts.prompt(),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3BB54A)),
                    onPressed: () {
                      sendTime(snapshot, index);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              userid: snapshot.data!.docs[index].id,
                            ),
                          ));
                    },
                    child: Text(
                      "รับงาน",
                      style: GoogleFonts.prompt(),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _sendData();
      }),
    );
  }

  Future<void> sendTime(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(snapshot.data!.docs[index].id)
        .set({
      'STime': DateFormat('HH:mm').format(DateTime.now()),
      'distance': calculateDistance(
              widget.lat,
              widget.long,
              snapshot.data!.docs[index]['latitude'],
              snapshot.data!.docs[index]['longitude'])
          .toStringAsFixed(2)
    }, SetOptions(merge: true));
  }

  Future<void> _sendData() async {
    await FirebaseFirestore.instance.collection('requests').doc().set({
      'user': "earth",
      'latitude': 13.11533244163535,
      'longitude': 100.92545502431265,
      'price': 100,
      'status': false
    }, SetOptions(merge: true));
  }
}
