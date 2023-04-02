import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:speedy/register/info.card.id.dart';
import 'package:speedy/register/verification.dart';

import '../firebase/auth.dart';
import '../widgets/widgets.dart';

class cardDriverScreen extends StatefulWidget {
  const cardDriverScreen({super.key});

  @override
  State<cardDriverScreen> createState() => _cardDriverScreenState();
}

class _cardDriverScreenState extends State<cardDriverScreen> {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final picker = ImagePicker();
  File? _imageFile;
  String? _imageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadImage(File file) async {
    User user = FirebaseAuth.instance.currentUser!;
    String _uid = user.uid;
    final Reference storageRef =
        FirebaseStorage.instance.ref().child(DateTime.now().toString());
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot downloadUrl = await uploadTask;
    final String url = await downloadUrl.ref.getDownloadURL();

    setState(() {
      _imageUrl = url;
    });
    final String driverCardUrl =
        await storeFileDataToStorage("driverCard/$_uid", file);

    await FirebaseFirestore.instance.collection('dUsers').doc(_uid).set({
      'driverCard': driverCardUrl,
    }, SetOptions(merge: true)).then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const verificationScreen(),
        ),
        (route) =>
            false)); // ใช้ SetOptions(merge: true) เพื่อไม่ลบฟิลด์ที่มีอยู่แล้วในเอกสาร
  }

  Future<String> storeFileDataToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthService>(context, listen: true).isLoading;
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              nextScreenReplace(context, cardIDScreen(user: user));
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
                              'เอกสารสำคัญ',
                              style: GoogleFonts.prompt(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'รับเฉพาะการสแกนเอกสารที่ถูกต้องและรูปถ่ายคุณภาพดีเท่านั้น',
                              style: GoogleFonts.prompt(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'ใบขับขี่',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () async {
                                final pickedFile = await ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    _imageFile = File(pickedFile
                                        .path); // กำหนดค่าให้กับ _imageFile
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 130,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 31, 31, 31),
                                  borderRadius: BorderRadius.circular(25),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'อัปโหลดไฟล์',
                                  style: GoogleFonts.prompt(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            InkWell(
                              onTap: () => _uploadImage(
                                  _imageFile!), // ใช้ _imageFile แทน file
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            const SizedBox(height: 30),
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
