import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/add.dart';
import 'package:speedy/select.dart';

class Add2Screen extends StatefulWidget {
  const Add2Screen(
      {super.key,
      required this.image,
      required this.color,
      required this.bank});
  final String image;
  final String bank;
  final Color color;

  @override
  State<Add2Screen> createState() => _Add2ScreenState();
}

class _Add2ScreenState extends State<Add2Screen> {
  final fromKey = GlobalKey<FormState>();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String name = '';
  String account = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("เพิ่มบัญชีธนาคาร", style: GoogleFonts.prompt()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AddScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Form(
        key: fromKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 40),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: widget.color),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(widget.image),
                          radius: 17,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.bank,
                          style: GoogleFonts.prompt(
                              fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ชื่อ", style: GoogleFonts.prompt(fontSize: 18)),
                      TextFormField(
                        validator:
                            RequiredValidator(errorText: "กรุณากรอกชื่อ"),
                        onSaved: (value) {
                          name = value!;
                        },
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "กรอกชื่อ",
                          hintStyle:
                              GoogleFonts.prompt(color: Colors.grey.shade400),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text("เลขบัญชี", style: GoogleFonts.prompt(fontSize: 18)),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกเลขบัญชี';
                          } else if (widget.bank == 'ออมสิน' &&
                              value.length != 12) {
                            return 'กรุณากรอกเลขบัญชีให้ครบ';
                          } else if (widget.bank != 'ออมสิน' &&
                              value.length != 10) {
                            return 'กรุณากรอกเลขบัญชีให้ครบ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          account = value!;
                        },
                        maxLength: widget.bank == 'ออมสิน' ? 12 : 10,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "กรอกเลขบัญชี",
                          hintStyle:
                              GoogleFonts.prompt(color: Colors.grey.shade400),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                        ),
                      ),
                      const SizedBox(
                        height: 250,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            if (fromKey.currentState!.validate()) {
                              fromKey.currentState!.save();
                              createBank(name, account, widget.image)
                                  .then((value) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectScreen()));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  final snackBar = SnackBar(
    closeIconColor: Colors.white,
    showCloseIcon: true,
    content: Text(
      'เพิ่มบัญชีเสร็จสิ้น',
      style: GoogleFonts.prompt(),
    ),
    backgroundColor: const Color(0xff3BB54A),
    duration: const Duration(seconds: 2),
  );

  Future<void> createBank(String name, String account, String image) async {
    DocumentReference bankDocumentReference =
        await FirebaseFirestore.instance.collection("banks").add({
      "owner": userId,
      "name": name,
      "account": account,
      "image": image,
    });

    await bankDocumentReference.update({
      "id": bankDocumentReference.id,
    });
  }
}
