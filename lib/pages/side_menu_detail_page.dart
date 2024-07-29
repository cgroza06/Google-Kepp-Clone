import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SideMenuDetailPage extends StatefulWidget {
  final String title;

  const SideMenuDetailPage({super.key, required this.title});

  
  @override
  State<SideMenuDetailPage> createState() => _SideMenuDetailPageState();
}

class _SideMenuDetailPageState extends State<SideMenuDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  AppBar getAppBar() {
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
    );
  }

  Widget getBody() {
    return Center(
      child: Text(
        widget.title,
        style: GoogleFonts.plusJakartaSans(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: -0.4,
          ),
        ),
      ),
    );
  }
}