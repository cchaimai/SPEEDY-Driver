import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/firebase/firestore.dart';
import 'package:speedy/select.dart';
import 'package:speedy/withdraw2.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.account});
  final String image;
  final String name;
  final String account;

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final fromKey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("ถอนเงิน", style: GoogleFonts.prompt()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SelectScreen()));
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
      body: Form(
        key: fromKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ถอนเงินจาก Wallet ไปที่",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.image),
                  ),
                  title: Text(widget.name,
                      style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w500, fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.account,
                          style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectScreen()));
                          },
                          icon: const Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("ยอดการถอนเงิน",
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                Row(
                  children: [
                    Text("฿",
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator:
                            RequiredValidator(errorText: "กรุณากรอกจำนวนเงิน"),
                        onSaved: (value) {
                          amount = int.parse(value!);
                        },
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w500,
                          fontSize: 36,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "0",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("ถอนเงินทั้งหมดจากกระเป๋าหลัก (0.00)",
                    style: GoogleFonts.prompt(color: const Color(0xff989898))),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 120,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      if (fromKey.currentState!.validate()) {
                        fromKey.currentState!.save();
                        increaseScore(userId, amount).then((value) {
                          fromKey.currentState!.reset();
                          try {
                            bankHistory();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WithDraw2Screen()));
                          } catch (e) {
                            // ignore: avoid_print
                            print(e);
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3BB54A),
                      fixedSize: const Size(180, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      "ยืนยัน",
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void bankHistory() async {
    await DatabaseService(uid: userId)
        .createBankHistory(widget.account, amount);
  }

  Future<void> increaseScore(String userId, int points) async {
    final DocumentReference<Map<String, dynamic>> userRef =
        firestore.collection('driver').doc(userId);
    try {
      await userRef.update({'wallet': FieldValue.increment(-points)});
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
