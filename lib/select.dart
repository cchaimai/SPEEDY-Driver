import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/balance.dart';
import 'package:speedy/withdraw.dart';

import 'add.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("บัญชีธนาคาร", style: GoogleFonts.prompt()),
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
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          )
        ],
      ),
      body: StreamBuilder(
          stream: firestore
              .collection("banks")
              .where("owner", isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Color(0xff3BB54A),
                        size: 30,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("Speedy Driver - บัญชีธนาคาร",
                          style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w600, fontSize: 16))
                    ],
                  ),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.docs[index]['image']),
                                  ),
                                  title: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WithdrawScreen(
                                                    image: snapshot.data!
                                                        .docs[index]['image'],
                                                    name: snapshot.data!
                                                        .docs[index]['name'],
                                                    account: snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['account']
                                                            .substring(0, 6) +
                                                        "XXXX",
                                                  )));
                                    },
                                    child:
                                        Text(snapshot.data!.docs[index]['name'],
                                            style: GoogleFonts.prompt(
                                              fontWeight: FontWeight.w500,
                                            )),
                                  ),
                                  trailing: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      snapshot.data!.docs[index]['account']
                                              .substring(0, 6) +
                                          "XXXX",
                                      style: GoogleFonts.prompt(
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Container(
                                  width: 300,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "เพิ่มบัญชีธนาคาร",
                            style: GoogleFonts.prompt(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
