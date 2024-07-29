import 'package:flutter/material.dart';
import 'package:google_keep_clone/json/side_menu_icon_json.dart';
import 'package:google_keep_clone/pages/settings_page.dart';
import 'package:google_keep_clone/pages/side_menu_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SideMenuPageIOS extends StatefulWidget {
  const SideMenuPageIOS({super.key});


  @override
  State<SideMenuPageIOS> createState() => _SideMenuPageIOSState();
}

class _SideMenuPageIOSState extends State<SideMenuPageIOS> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
        child: ListView(
          children: [
            header(context),
            sectionOne(),
            sectionTwo(),
            sectionThree(),
            sectionFour(),
          ],
        ) ,
      ),
    );
  }

  Widget header(BuildContext context) {
  bool isLightMode = Theme.of(context).brightness == Brightness.light;

  return Container(
    height: 65,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 23),
      child: Row(
        children: [
          if (isLightMode) ...[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "G",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.blue, 
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "o",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.red,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "o",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.yellow,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "g",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.blue,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "l",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.green, 
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "e ",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.red, 
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              "Google ",
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
          Text(
            "Keep",
            style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                letterSpacing: -0.4,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget sectionOne(){
    return Column(
      children: [
        Column(
          children: List.generate(2, (index) {
            return TextButton (
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 9, left: 9, bottom: 9),
                child: Row(
                  children: [
                    Icon(
                      sideMenuItem[index]["icon"], 
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      sideMenuItem[index]["text"],
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 72),
          child: Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        )
      ],
    );
  } 

  Widget sectionTwo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20, top:10, bottom: 10),
          child: Text("LABELS", style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: -0.4,
            ),
          ),),
        ),
        TextButton (
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.only(top: 9, left: 9, bottom: 9),
            child: Row(
              children: [
                Icon(
                  sideMenuItem[2]["icon"], 
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 25),
                Text(
                  sideMenuItem[2]["text"],
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 70),
          child: Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        )
      ],
    );
  } 

  Widget sectionThree(){
    return Column(
      children: [
        Column(
          children: List.generate(2, (index) {
            return TextButton (
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 9, left: 9, bottom: 9),
                child: Row(
                  children: [
                    Icon(
                      sideMenuItem[index+3]["icon"], 
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      sideMenuItem[index+3]["text"],
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 72),
          child: Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        )
      ],
    );
  } 

  Widget sectionFour(){
    return Column(
      children: [
        Column(
          children: List.generate(3, (index) {
            return TextButton (
              onPressed: () {
              if (index == 0) {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SettingsPage()));
              } else {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SideMenuDetailPage(
                    title: sideMenuItem[index+5]['text'],)));
              }
            },
              child: Padding(
                padding: const EdgeInsets.only(top: 9, left: 9, bottom: 9),
                child: Row(
                  children: [
                    Icon(
                      sideMenuItem[index+5]["icon"], 
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      sideMenuItem[index+5]["text"],
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  } 

}