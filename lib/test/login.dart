import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:speedy/firebase/auth.dart';
import 'package:speedy/test/proflie.dart';
import '../map.dart';

// ignore: camel_case_types
class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

// ignore: camel_case_types
class _loginScreenState extends State<loginScreen> {
  final fromKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  AuthService authService = AuthService();
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
                  title: const Text("Login"),
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
                                  "Login",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () async {
                                  // fromKey.currentState!.save();
                                  // try {
                                  //   await authService
                                  //       .loginWithUserNameandPassword(
                                  //           profile.email, profile.password)
                                  //       .then((value) {
                                  //     fromKey.currentState!.reset();
                                  //     Navigator.pushReplacement(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 const MapScreen()));
                                  //   });
                                  // } on FirebaseAuthException catch (e) {
                                  //   // ignore: avoid_print
                                  //   print(e.message);
                                  // }
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
