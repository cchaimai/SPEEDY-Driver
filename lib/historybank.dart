import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speedy/balance.dart';

class HistoryBankScreen extends StatefulWidget {
  const HistoryBankScreen({super.key});

  @override
  State<HistoryBankScreen> createState() => _HistoryBankScreenState();
}

class _HistoryBankScreenState extends State<HistoryBankScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("ประวัติรายการ", style: GoogleFonts.prompt()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BalanceScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          )
        ],
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("bankhistory")
              .where("owner", isEqualTo: userId)
              .orderBy("timestamp", descending: true)
              .get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text("รายการถอน", style: GoogleFonts.prompt()),
                        subtitle: Text(
                            "เลขที่บัญชี ${snapshot.data!.docs[index]['account'].substring(0, 6)}XXXX\n${DateFormat('dd MMM yy', 'th').format(snapshot.data!.docs[index]['timestamp'].toDate())}  ${DateFormat('HH:mm').format(snapshot.data!.docs[index]['timestamp'].toDate())} น.",
                            style: GoogleFonts.prompt()),
                        trailing: Text(
                            "-${snapshot.data!.docs[index]['amount']} ฿",
                            style: GoogleFonts.prompt(fontSize: 20)),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}
