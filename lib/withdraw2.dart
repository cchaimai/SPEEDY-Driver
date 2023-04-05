import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/balance.dart';
import 'package:speedy/select.dart';

class WithDraw2Screen extends StatefulWidget {
  const WithDraw2Screen({super.key});

  @override
  State<WithDraw2Screen> createState() => _WithDraw2ScreenState();
}

class _WithDraw2ScreenState extends State<WithDraw2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 270),
          child: Center(
            child: Column(
              children: [
                Image.network(
                    "https://cdn.discordapp.com/attachments/956974071193698424/1089075125690839112/Check.png"),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "รายการสำเร็จ",
                  style: GoogleFonts.prompt(fontSize: 20),
                ),
                const SizedBox(
                  height: 140,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BalanceScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3BB54A),
                    fixedSize: const Size(180, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    "กลับหน้าหลัก",
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectScreen()));
                    },
                    child: Text("ถอนเงินรายการอื่น",
                        style: GoogleFonts.prompt(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: const Color(0xff3BB54A))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
