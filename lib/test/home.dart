import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speedy/firebase/auth.dart';
import 'package:speedy/map.dart';
import 'package:speedy/register/regis.dart';
import 'package:speedy/widgets/global.color.dart';
import 'package:speedy/widgets/widgets.dart';

import '../register/verification.dart';
import 'login.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    super.initState();
    checkSignIn(context);
  }

  checkSignIn(context) async {
    String? _uid =
        FirebaseAuth.instance.currentUser?.uid; // ดึง uid จาก user object
    final userDoc =
        await FirebaseFirestore.instance.collection('dUsers').doc(_uid).get();

    final role = userDoc.data()?['role'];

    // Display different screens depending on the user's role
    if (role == 'driver' && FirebaseAuth.instance.currentUser != null) {
      nextScreenReplace(context, const MapScreen());
    }
    // ถ้าเป็นโรลไดร์เวอร์ และยังไม่ได้เข้าสู่ระบบ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      'assets/images/logo-driver.png',
                    ),
                  ),
                ),
                const SizedBox(height: 370),

                //Speedy
                InkWell(
                  onTap: () {
                    nextScreenReplace(context, const loginScreen());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          color: GlobalColors.speedyGreyColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Colors.grey),
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
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                'assets/images/logo3.png',
                              ),
                            ),
                            Text(
                              ' Log in with Speedy     ',
                              style: GoogleFonts.prompt(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a SPEEDY ? ',
                      style: GoogleFonts.prompt(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.prompt(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.lightGreen,
                        ),
                      ),
                      onPressed: () {
                        nextScreenReplace(context, const registerScreen());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
