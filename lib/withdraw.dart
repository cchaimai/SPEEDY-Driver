import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  String userId = FirebaseAuth.instance.currentUser!.uid;
  num? amount;
  bool _isChecked = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("ถอนเงิน", style: GoogleFonts.prompt()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SelectScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('dUsers').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            return Form(
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
                          backgroundImage: AssetImage(widget.image),
                        ),
                        title: Text(widget.name,
                            style: GoogleFonts.prompt(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${widget.account.substring(0, 6)}XXXX",
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
                              controller: _textEditingController,
                              validator: (value) {
                                if (value == "0") {
                                  return "กรุณากรอกจำนวนเงิน";
                                }
                                return null;
                              },
                              style: GoogleFonts.prompt(
                                fontWeight: FontWeight.w500,
                                fontSize: 36,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '0',
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
                      ListTileTheme(
                        contentPadding: EdgeInsets.zero,
                        child: CheckboxListTile(
                          title: Text(
                              "ถอนเงินทั้งหมดจากกระเป๋าหลัก (${snapshot.data!.docs.singleWhere((doc) => doc.id == userId)['wallet']}฿)",
                              style: GoogleFonts.prompt(
                                  color: const Color(0xff989898),
                                  fontSize: 12)),
                          value: _isChecked,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          activeColor: const Color(0xff3BB54A),
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                              if (_isChecked) {
                                amount = snapshot.data!.docs.singleWhere(
                                    (doc) => doc.id == userId)['wallet'];
                                _textEditingController.text = amount.toString();
                              } else {
                                _textEditingController.text = "";
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
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
                              withdraw(userId,
                                  num.parse(_textEditingController.text));
                              createBankHistory(widget.account,
                                  num.parse(_textEditingController.text));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WithDraw2Screen()));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
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
            );
          }),
    );
  }

  final snackBar = SnackBar(
    closeIconColor: Colors.white,
    showCloseIcon: true,
    content: Text(
      'ถอนเงินเสร็จสิ้น',
      style: GoogleFonts.prompt(),
    ),
    backgroundColor: const Color(0xff3BB54A),
    duration: const Duration(seconds: 2),
  );

  Future<void> createBankHistory(String account, num amount) async {
    DocumentReference bankHistoryDocumentReference =
        await FirebaseFirestore.instance.collection("bankhistory").add({
      "owner": userId,
      "account": account,
      "amount": amount,
      "timestamp": FieldValue.serverTimestamp(),
    });

    await bankHistoryDocumentReference.update({
      "id": bankHistoryDocumentReference.id,
    });
  }

  Future<void> withdraw(String userId, num points) async {
    final DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('dUsers').doc(userId);
    try {
      await userRef.update({'wallet': FieldValue.increment(-points)});
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
