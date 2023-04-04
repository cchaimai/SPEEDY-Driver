
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy/check.signin.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'firebase/auth.dart';

void main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        home: AnimatedSplashScreen(
          duration: 3000,
          splash: SizedBox(
            width: 400,
            height: 400,
            child: Image.asset(
              'assets/images/logo-driver.png',
            ),
          ),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white,
          nextScreen: const checkSignInScreen()
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
