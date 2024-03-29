import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speedy/firebase/user.model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/helper_function.dart';

class AuthService extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // Future loginWithUserNameandPassword(String email, String password) async {
  //   try {
  //     User user = (await _firebaseAuth.signInWithEmailAndPassword(
  //             email: email, password: password))
  //         .user!;

  //     // ignore: unnecessary_null_comparison
  //     if (user != null) {
  //       return true;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // Future registerUserWithEmailandPassword(String email, String password) async {
  //   try {
  //     await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // Future signOut() async {
  //   try {
  //     await _firebaseAuth.signOut();
  //   } catch (e) {
  //     return null;
  //   }
  // }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    //required File dProfilePic,
    required List<String> groups, // รับข้อมูล cards เป็น List<String>
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    User user = FirebaseAuth.instance.currentUser!;
    String _uid = user.uid;
    try {
      //uploading image to firebase storage
      // await storeFileDataToStorage("dProfilePic/$_uid", dProfilePic)
      //     .then((value) {
      //   userModel.dProfilePic = value;
      userModel.groups = groups;
      userModel.email = _firebaseAuth.currentUser!.email!;

      print(_uid);
      //});
      _userModel = userModel;
      await _firebaseFirestore
          .collection("dUsers")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileDataToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //Storing data locally
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  signOut() {}
}
