import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/firebase/auth.dart';
import 'package:speedy/register/verification.dart';
import 'package:speedy/test/home.dart';
import 'package:speedy/test/proflie.dart';
import '../map.dart';
import '../widgets/widgets.dart';

// ignore: camel_case_types
class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

// ignore: camel_case_types
class _loginScreenState extends State<loginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => nextScreenReplace(context, const homeScreen()),
          icon: const Icon(Icons.arrow_back, color: Colors.green, size: 25),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.language,
                color: Colors.green,
                size: 25,
              ))
        ],
        toolbarHeight: 100,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/images/logo-driver.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        'อีเมล์',
                        style: GoogleFonts.prompt(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.green,
                    onSaved: (value) {
                      email = value!;
                      print(email);
                    },
                    style: GoogleFonts.prompt(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'example@gmail.com',
                      labelStyle: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกอีเมล์';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        'รหัสผ่าน',
                        style: GoogleFonts.prompt(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    cursorColor: Colors.green,
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) {
                      password = value!;
                      print(value);
                    },
                    style: GoogleFonts.prompt(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'A-Z,a-z,0-9',
                      labelStyle: GoogleFonts.prompt(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      InkWell(
                        onTap: () => login(),
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 55,
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              'Login',
                              style: GoogleFonts.prompt(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
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
                              nextScreenReplace(context, const MapScreen());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        String _uid = userCredential.user!.uid; // ดึง uid จาก user object
        final userDoc = await FirebaseFirestore.instance
            .collection('dUsers')
            .doc(_uid)
            .get();

        final role = userDoc.data()?['role'];

        // Display different screens depending on the user's role
        if (role == 'user_driver') {
          nextScreenReplace(context, const verificationScreen());
        } else if (role == 'driver') {
          nextScreenReplace(context, const MapScreen());
        }

        formKey.currentState!.reset();
      } on FirebaseAuthException catch (e) {
        // Handle the FirebaseAuthException.
        Fluttertoast.showToast(msg: 'Failed to register: ${e.message}');
      } catch (e) {
        // Handle other exceptions.
        Fluttertoast.showToast(msg: 'Failed to register: $e');
      }
    }
  }
}
