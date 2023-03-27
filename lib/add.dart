import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedy/add2.dart';
import 'package:speedy/select.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f1f1f),
        centerTitle: true,
        title: Text("เพิ่มบัญชีธนาคาร", style: GoogleFonts.prompt()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SelectScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            bankList(
              context,
              "https://cdn.discordapp.com/attachments/956974071193698424/1087331970473795584/-removebg-preview.png",
              "กรุงศรี",
              const Color(0xff705F5F),
            ),
            horizontalline(),
            bankList(
              context,
              "https://cdn.discordapp.com/attachments/956974071193698424/1087332394111086622/Krung_Thai_Bank_logo.svg.png",
              "กรุงไทย",
              const Color(0xff13A1E4),
            ),
            horizontalline(),
            bankList(
              context,
              "https://cdn.discordapp.com/attachments/956974071193698424/1087332798588801085/280688579024211.png",
              "ไทยพาณิชย์",
              const Color(0xff4E2A82),
            ),
            horizontalline(),
            bankList(
              context,
              "https://cdn.discordapp.com/attachments/956974071193698424/1087334693285937202/fa4b4a6ef2f95136051607a7fba619ba.png",
              "ออมสิน",
              const Color(0xffFF36A0),
            ),
            horizontalline(),
            bankList(
              context,
              "https://cdn.discordapp.com/attachments/956974071193698424/1087334993279340644/logo.png",
              "กสิกรไทย",
              const Color(0xff00A950),
            ),
            horizontalline(),
            bankList(
              context,
              "https://cdn.discordapp.com/attachments/956974071193698424/1087336195165532240/images.png",
              "ทหารไทยธนชาต",
              const Color(0xff0050F0),
            ),
            horizontalline(),
            bankList(
              context,
              "https://cdn.discordapp.com/attachments/956974071193698424/1087336514079424512/1409170288-b60f8c1e0e-o.png",
              "กรุงเทพ",
              const Color(0xff013194),
            ),
            horizontalline(),
          ],
        ),
      ),
    );
  }

  ListTile bankList(
      BuildContext context, String image, String name, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(image),
      ),
      title: InkWell(
          highlightColor: color,
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Add2Screen(image: image, color: color, bank: name)));
          },
          child: Text(name,
              style: GoogleFonts.prompt(color: const Color(0xff898888)))),
    );
  }

  Container horizontalline() {
    return Container(
      width: 335,
      height: 1,
      color: Colors.grey,
    );
  }
}
