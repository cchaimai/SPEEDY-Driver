import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speedy/historybank.dart';
import 'package:speedy/select.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  num wallet = 0;

  Future<void> getUserData() async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('dUsers').doc(userId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    wallet = userDocSnapshot.get('wallet');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("กระเป๋าตัง", style: GoogleFonts.prompt()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('requests')
              .where("dUserID", isEqualTo: userId)
              .orderBy("eTimestamp", descending: true)
              .get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(children: [
                  Text(
                    "$wallet฿",
                    style: GoogleFonts.prompt(
                      fontSize: 64,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SelectScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3BB54A),
                          fixedSize: const Size(135, 65),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.currency_exchange),
                            Text(
                              "ถอนเงิน",
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HistoryBankScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3BB54A),
                          fixedSize: const Size(135, 65),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.receipt_long),
                            Text(
                              "ประวัติรายการ",
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "รายได้",
                              style: GoogleFonts.prompt(
                                fontSize: 20,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                              DateFormat('dd MMM yy', 'th')
                                                  .format(snapshot.data!
                                                      .docs[index]['eTimestamp']
                                                      .toDate()),
                                              style: GoogleFonts.prompt()),
                                          subtitle: Text(
                                              "${DateFormat('HH:mm').format(snapshot.data!.docs[index]['eTimestamp'].toDate())} น.",
                                              style: GoogleFonts.prompt()),
                                          trailing: Text(
                                              "+${(snapshot.data!.docs[index]['price'] * 0.85).toStringAsFixed(0)} ฿",
                                              style: GoogleFonts.prompt(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16)),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            );
          }),
    );
  }
}
