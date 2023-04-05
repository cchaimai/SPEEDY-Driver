import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'map.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({super.key, required this.workID});
  final String workID;

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f1f1f),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("requests").get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/car.png",
                    width: 500,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "No.${snapshot.data!.docs.singleWhere((doc) => doc.id == widget.workID)['workID']}",
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time Available",
                            style: GoogleFonts.prompt(color: Colors.grey),
                          ),
                          Text(
                            DateFormat('HH:mm').format(snapshot.data!.docs
                                .singleWhere((doc) => doc.id == widget.workID)[
                                    'sTimestamp']
                                .toDate()),
                            style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time End",
                            style: GoogleFonts.prompt(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(snapshot.data!.docs
                                .singleWhere((doc) => doc.id == widget.workID)[
                                    'eTimestamp']
                                .toDate()),
                            style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Energy",
                            style: GoogleFonts.prompt(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${snapshot.data!.docs.singleWhere((doc) => doc.id == widget.workID)['energy']} kWh',
                            style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 330,
                    height: 230,
                    decoration: BoxDecoration(
                        color: const Color(0xff1f1f1f),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset.zero)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Text(
                            "${(snapshot.data!.docs.singleWhere((doc) => doc.id == widget.workID)['price'] * 0.85).toStringAsFixed(0)}฿",
                            style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w600,
                              fontSize: 50,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "รายได้สุทธิ",
                            style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff3BB54A),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              increaseWallet(
                                      userId,
                                      (snapshot.data!.docs.singleWhere((doc) =>
                                                  doc.id ==
                                                  widget.workID)['price'] *
                                              0.85)
                                          .toInt())
                                  .then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MapScreen(),
                                  ),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff3BB54A),
                              fixedSize: const Size(180, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              "จบงาน",
                              style: GoogleFonts.prompt(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<void> increaseWallet(String userId, int amount) async {
    final DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('dUsers').doc(userId);

    await userRef.update({'wallet': FieldValue.increment(amount)});
  }
}
