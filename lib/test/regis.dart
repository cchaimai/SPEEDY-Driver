import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:speedy/test/home.dart';
import 'package:speedy/test/proflie.dart';

import '../firebase/auth.dart';

// ignore: camel_case_types
class regisScreen extends StatefulWidget {
  const regisScreen({super.key});

  @override
  State<regisScreen> createState() => _regisScreenState();
}

// ignore: camel_case_types
class _regisScreenState extends State<regisScreen> {
  final fromKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  AuthService authService = AuthService();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Sign up"),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      key: fromKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              onSaved: (String? email) {
                                profile.email = email!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Password",
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              onSaved: (String? password) {
                                profile.password = password!;
                              },
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () async {
                                  fromKey.currentState!.save();
                                  try {
                                    await authService
                                        .registerUserWithEmailandPassword(
                                            profile.email, profile.password)
                                        .then((value) {
                                      fromKey.currentState!.reset();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const homeScreen()));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    // ignore: avoid_print
                                    print(e.message);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                ));
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
