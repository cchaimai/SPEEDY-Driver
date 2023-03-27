import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/add.dart';
import 'package:speedy/firebase/firestore.dart';
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
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String name = '';
  String account = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("เพิ่มบัญชีธนาคาร", style: GoogleFonts.prompt()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AddScreen()));
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
                          backgroundImage: NetworkImage(widget.image),
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
                          } else if (value.length != 10) {
                            return 'กรุณากรอกเลขบัญชีให้ครบ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          account = value!;
                        },
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "กรอกเลขบัญชีเลขบัญชี",
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
                          onPressed: () async {
                            if (fromKey.currentState!.validate()) {
                              fromKey.currentState!.save();
                              try {
                                await DatabaseService(uid: userId)
                                    .createBank(name, account, widget.image)
                                    .then((value) {
                                  fromKey.currentState!.reset();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SelectScreen()));
                                });
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                              }
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
}
