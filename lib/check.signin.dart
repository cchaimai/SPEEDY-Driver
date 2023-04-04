import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speedy/register/verification.dart';
import 'package:speedy/test/home.dart';
import 'package:speedy/test/login.dart';

import 'map.dart';

class checkSignInScreen extends StatefulWidget {
  const checkSignInScreen({super.key});

  @override
  State<checkSignInScreen> createState() => _checkSignInScreenState();
}

class _checkSignInScreenState extends State<checkSignInScreen> {
  @override
  void initState() {
    super.initState();
    checkSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }

  Future<void> checkSignIn() async {
    String? _uid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('dUsers').doc(_uid).get();
    final role = userDoc.data()?['role'];
    if (role == 'user_driver') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => verificationScreen()));
    } else if (role == 'driver') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MapScreen()));
    }
  }
}
