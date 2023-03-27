import 'package:flutter/material.dart';
import 'package:speedy/test/regis.dart';

import 'login.dart';

// ignore: camel_case_types
class homeScreen extends StatelessWidget {
  const homeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/logo.png"),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const loginScreen();
                      }));
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("Login")),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const regisScreen();
                      }));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Sign up")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
