import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_keep_clone/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: getAppBar(context), 
      body: getBody(context),
    );
  }

  AppBar getAppBar(BuildContext context) { 
  return AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.background,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.close, 
        color: Theme.of(context).colorScheme.primary,
        size: 26,
      ),
    ),
    title: Row(
      children: [
        const SizedBox(width: 100), 
        Text(
          "Settings",
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: -0.4,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget getBody(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:15, top:15),
          child: Text("Display options", style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Theme.of(context).colorScheme.secondary,
              letterSpacing: -0.4,
            ),
          ),),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ 
              Text(
                "Dark mode",
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              CupertinoSwitch(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode, 
                onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              ),
            ],
          ),
        ),
      ],
    );
  } 
}
