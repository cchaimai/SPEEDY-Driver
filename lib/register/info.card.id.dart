import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speedy/register/card.driver.dart';
import 'package:speedy/register/info.dart';

import '../firebase/auth.dart';
import '../widgets/widgets.dart';

class cardIDScreen extends StatefulWidget {
  const cardIDScreen({super.key, required User user});

  @override
  State<cardIDScreen> createState() => _cardIDScreenState();
}

class _cardIDScreenState extends State<cardIDScreen> {
  final cardIDController = TextEditingController();
  final driverCardController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthService>(context, listen: true).isLoading;
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              nextScreenReplace(context, informationScreen(user: user));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.green,
            )),
        title: Text(
          "Sign up",
          style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.language,
              )),
        ],
        toolbarHeight: 80,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            color: Color.fromARGB(255, 31, 31, 31),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 60,
                              ),
                              Icon(
                                Icons.horizontal_rule,
                                color: Colors.green,
                                size: 25,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 60,
                              ),
                              Icon(
                                Icons.horizontal_rule,
                                color: Colors.grey,
                                size: 25,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.grey,
                                size: 60,
                              ),
                              Icon(
                                Icons.horizontal_rule,
                                color: Colors.grey,
                                size: 25,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.grey,
                                size: 60,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 330,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'เอกสาร/ใบอนุญาตสำคัญทางกฎหมาย',
                                style: GoogleFonts.prompt(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'เราจะเก็บเลขประจำตัวประชาชนและ',
                                style: GoogleFonts.prompt(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'รายละเอียดใบอนุญาตขับขี่ของคุณไว้เป็นความลับ',
                                style: GoogleFonts.prompt(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'เลขบัตรประจำตัวประชาชน',
                                style: GoogleFonts.prompt(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                cursorColor: Colors.green,
                                controller: cardIDController,
                                autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '1-234567890-01-2',
                                  labelStyle: GoogleFonts.prompt(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกเลขบัตรประจำตัวประชาชน';
                                  } else if (value.length < 13) {
                                    return 'กรุณากรอกให้ครบ 13 หลัก';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'หมายเลขประกันสังคมหรือหมายเลขยืนยันตัวตนในประเทศของคุณ (เช่น BVN)',
                                style: GoogleFonts.prompt(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'ใบอนุญาตขับขี่',
                                style: GoogleFonts.prompt(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                cursorColor: Colors.green,
                                controller: driverCardController,
                                autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '12345678',
                                  labelStyle: GoogleFonts.prompt(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกเลขใบอนุญาตขับขี่';
                                  } else if (value.length < 8) {
                                    return 'กรุณากรอกให้ครบ 8 หลัก';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'เลขที่ใบอนุญาตขับขี่ของคุณ',
                                style: GoogleFonts.prompt(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        InkWell(
                          onTap: () => saveCardID(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ถัดไป ',
                                      style: GoogleFonts.prompt(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )
                                  ],
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
      ),
    );
  }

  void saveCardID() async {
    String cardID = cardIDController.text.trim();
    String driverCard = driverCardController.text.trim();
    User user = FirebaseAuth.instance.currentUser!;

    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('dUsers')
          .doc(user.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          // เจอเอกสารที่ค้นหา ทำการอัปเดตข้อมูลได้
          FirebaseFirestore.instance.collection('dUsers').doc(user.uid).update({
            'cardID': cardID,
            'driverCard': driverCard,
          }).then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const cardDriverScreen(),
              ),
              (route) => false));
        } else {
          // ไม่เจอเอกสารที่ค้นหา สร้างเอกสารใหม่
          FirebaseFirestore.instance.collection('dUsers').doc(user.uid).set({
            'cardID': cardID,
            'driverCard': driverCard,
          }).then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const cardDriverScreen(),
              ),
              (route) => false));
        }
      });
    }
  }
}
