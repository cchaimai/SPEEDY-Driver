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

class documentScreen extends StatefulWidget {
  const documentScreen({super.key});

  @override
  State<documentScreen> createState() => _documentScreenState();
}

class _documentScreenState extends State<documentScreen> {

  final _storage = FirebaseStorage.instance;
  List<File> _imageFiles = [];


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
                              onTap: () {
 
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
                            const Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              'ภาพภ่ายตนเอง',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'อัปโหลดรูปภาพใบหน้าของคุณด้วยพื้นหลังที่ชัดเจน',
                              style: GoogleFonts.prompt(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                         
                                
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
                            const Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              'บัตรประจำตัวประชาชน',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                         
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
                            const Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              'เอกสารการจดทะเบียนยานพาหนะ',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                              
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
                            const Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              'รูปยานพาหนะ',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                             
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
                            const Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              'การตรวจสอบประวัติอาชญากร',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                        
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
                            const Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              'สำเนาทะเบียนบ้าน',
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                         
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
                              onTap: () {},
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
