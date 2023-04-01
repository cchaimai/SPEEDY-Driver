import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speedy/register/documents.dart';
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
  final drivingCardController = TextEditingController();

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
      body: SafeArea(
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
                              'เลขประจำตัวประชาชน',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              cursorColor: Colors.green,
                              controller: cardIDController,
                              decoration: InputDecoration(
                                labelText: '1-234567890-12-3',
                                labelStyle: GoogleFonts.prompt(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
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
                              controller: drivingCardController,
                              decoration: InputDecoration(
                                labelText: '1-234567890-12-3',
                                labelStyle: GoogleFonts.prompt(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
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
                        onTap: () {
                          nextScreenReplace(context, const documentScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 55,
                              width: 150,
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
    );
  }
}
