import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:speedy/register/info.card.id.dart';
import 'package:speedy/register/regis.dart';

import '../firebase/auth.dart';
import '../firebase/user.model.dart';
import '../widgets/widgets.dart';

class informationScreen extends StatefulWidget {
  const informationScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<informationScreen> createState() => _informationScreenState();
}

class _informationScreenState extends State<informationScreen> {
  String? _selectedBrand;
  String? _selectedProvince;
  String? _selectedYear;
  String? _selectedColors;
  bool _isChecked = false;
  File? image;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final carIDController = TextEditingController();
  final carColorController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    carIDController.dispose();
    carColorController.dispose();
  }

  static const List<String> years = [
    '2566',
    '2565',
    '2564',
    '2563',
    '2562',
    '2561',
    '2560',
    '2559',
    '2558',
    '2557',
    '2556',
    '2555',
  ];

  static const List<String> carColors = [
    'White',
    'Black',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Brown',
    'Beige',
    'Green',
  ];

  static const List<String> brands = [
    "Tesla",
    "Chevrolet",
    "Ford",
    "Porsche",
    "Mercedes-Benz",
    "BMW",
    "Nissan",
    "Honda",
    "Toyota",
    "Volkswagen",
    "Hyundai",
    "Jaguar",
    "Mini",
    "Audi",
    "Kia"
  ];

  static const List<String> provinces = [
    'กระบี่',
    'กรุงเทพมหานคร',
    'กาญจนบุรี',
    'กาฬสินธุ์',
    'กำแพงเพชร',
    'ขอนแก่น',
    'จันทบุรี',
    'ฉะเชิงเทรา',
    'ชลบุรี',
    'ชัยนาท',
    'ชัยภูมิ',
    'ชุมพร',
    'เชียงราย',
    'เชียงใหม่',
    'ตรัง',
    'ตราด',
    'ตาก',
    'นครนายก',
    'นครปฐม',
    'นครพนม',
    'นครราชสีมา',
    'นครศรีธรรมราช',
    'นครสวรรค์',
    'นนทบุรี',
    'นราธิวาส',
    'น่าน',
    'บึงกาฬ',
    'บุรีรัมย์',
    'ปทุมธานี',
    'ประจวบคีรีขันธ์',
    'ปราจีนบุรี',
    'ปัตตานี',
    'พระนครศรีอยุธยา',
    'พังงา',
    'พัทลุง',
    'พิจิตร',
    'พิษณุโลก',
    'เพชรบุรี',
    'เพชรบูรณ์',
    'แพร่',
    'ภูเก็ต',
    'มหาสารคาม',
    'มุกดาหาร',
    'แม่ฮ่องสอน',
    'ยโสธร',
    'ยะลา',
    'ร้อยเอ็ด',
    'ระนอง',
    'ระยอง',
    'ราชบุรี',
    'ลพบุรี',
    'ลำปาง',
    'ลำพูน',
    'เลย',
    'ศรีสะเกษ',
    'สกลนคร',
    'สงขลา',
    'สตูล',
    'สมุทรปราการ',
    'สมุทรสงคราม',
    'สมุทรสาคร',
    'สระแก้ว',
    'สระบุรี',
    'สิงห์บุรี',
    'สุโขทัย',
    'สุพรรณบุรี',
    'สุราษฎร์ธานี',
    'สุรินทร์',
    'หนองคาย',
    'หนองบัวลำภู',
    'อ่างทอง',
    'อุดรธานี',
    'อุทัยธานี',
    'อุตรดิตถ์',
    'อุบลราชธานี',
    'อำนาจเจริญ'
  ];

  //for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthService>(context, listen: true).isLoading;
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text('Are you sure you want to go back?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const registerScreen())),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ).then((value) {
                if (value == 'OK') {
                  Navigator.pop(context);
                }
              });
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
                              color: Colors.grey,
                              size: 25,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.grey,
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
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ข้อมูลส่วนบุคคลและรายละเอียดรถยนต์',
                                    style: GoogleFonts.prompt(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              // Column(
                              //   children: [
                              //     InkWell(
                              //       onTap: () => selectImage(),
                              //       child: image == null
                              //           ? const CircleAvatar(
                              //               backgroundColor: Colors.grey,
                              //               radius: 50,
                              //               child: Icon(
                              //                 Icons.account_circle,
                              //                 size: 50,
                              //                 color: Colors.white,
                              //               ),
                              //             )
                              //           : CircleAvatar(
                              //               backgroundImage: FileImage(image!),
                              //               radius: 50,
                              //             ),
                              //     ),
                              //     const SizedBox(height: 5),
                              //     InkWell(
                              //       onTap: () => selectImage(),
                              //       child: Text(
                              //         'เพิ่มรูปภาพ',
                              //         style: GoogleFonts.prompt(
                              //           color: Colors.grey.shade600,
                              //           fontSize: 12,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'ชื่อ',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                cursorColor: Colors.green,
                                controller: firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: GoogleFonts.prompt(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'นามสกุล',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                cursorColor: Colors.green,
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: GoogleFonts.prompt(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'เบอร์โทร',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                cursorColor: Colors.green,
                                keyboardType: TextInputType.phone,
                                controller: phoneNumberController,
                                decoration: InputDecoration(
                                  labelText: '0912345678',
                                  labelStyle: GoogleFonts.prompt(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
                                ),
                              ),
                              const SizedBox(height: 10),
                              CheckboxListTile(
                                title: Text(
                                  'ฉันมีรถยนต์ที่สามารถขับได้',
                                  style: GoogleFonts.prompt(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                value: _isChecked,
                                activeColor: Colors.green,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, // กำหนดให้ checkbox อยู่ด้านซ้ายของข้อความ title
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'แบรนด์ยานพาหนะ',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Brand',
                                  labelStyle: GoogleFonts.prompt(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
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
                                ),
                                value: _selectedBrand,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedBrand = newValue;
                                  });
                                  print(_selectedBrand);
                                },
                                items: brands.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' หากไม่พบรุ่นยานพาหนะของท่านในรายชื่อ',
                                    style: GoogleFonts.prompt(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        ' โปรดแจ้งให้เราทราบได้ที่ ',
                                        style: GoogleFonts.prompt(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          'info@speedy.th',
                                          style: GoogleFonts.prompt(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.lightGreen),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'ทะเบียนรถ',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: carIDController,
                                cursorColor: Colors.green,
                                decoration: InputDecoration(
                                  labelText: 'ab 1234',
                                  labelStyle: GoogleFonts.prompt(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'สีของยานพาหนะ',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Colors',
                                  labelStyle: GoogleFonts.prompt(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
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
                                ),
                                value: _selectedColors,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedColors = newValue;
                                  });
                                  print(_selectedColors);
                                },
                                items: carColors.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'ปีของยานพาหนะ',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Year',
                                  labelStyle: GoogleFonts.prompt(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
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
                                ),
                                value: _selectedYear,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedYear = newValue;
                                  });
                                  print(_selectedYear);
                                },
                                items: years.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'จังหวัดที่ลงทะเบียน',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'provinces',
                                  labelStyle: GoogleFonts.prompt(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                value: _selectedProvince,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedProvince = newValue;
                                  });
                                  print(_selectedProvince);
                                },
                                items: provinces.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () => storeData(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthService>(context, listen: false);
    User user = FirebaseAuth.instance.currentUser!;
    List<String> groups = [];
    UserModel userModel = UserModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        carID: carIDController.text.trim(),
        carColor: carColorController.text.trim(),
        carBrand: _selectedBrand.toString(),
        carYear: _selectedYear.toString(),
        provinces: _selectedProvince.toString(),
        email: "",
        wallet: 0,
        groups: [],
        role: "user_driver");
    ap.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        ap.saveUserDataToSP().then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => cardIDScreen(
                      user: user,
                    )),
            (route) => false));
      },
      groups: groups.toList(),
    );
  }
}
