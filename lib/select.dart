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
  String userId = FirebaseAuth.instance.currentUser!.uid;

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("banks")
              .where("owner", isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.data!.docs.isNotEmpty) {
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
                      child: Center(
                        child: Text(
                          "กรุณาเพิ่มบัญชีธนาคาร",
                          style: GoogleFonts.prompt(fontSize: 16),
                        ),
                      ),
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
                                InkWell(
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
                                                  account: snapshot.data!
                                                      .docs[index]['account'],
                                                )));
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          snapshot.data!.docs[index]['image']),
                                    ),
                                    title:
                                        Text(snapshot.data!.docs[index]['name'],
                                            style: GoogleFonts.prompt(
                                              fontWeight: FontWeight.w500,
                                            )),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            "${snapshot.data!.docs[index]['account'].substring(0, 6)}XXXX ",
                                            style: GoogleFonts.prompt(
                                              fontWeight: FontWeight.w500,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              popUb1(
                                                  context,
                                                  snapshot
                                                      .data!.docs[index].id);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
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

  popUb1(BuildContext context, String id) {
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
              "ต้องการลบบัญชี",
              style: GoogleFonts.prompt(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('banks').doc(id).delete();
                Navigator.pop(context);
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
                Navigator.pop(context);
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
}
