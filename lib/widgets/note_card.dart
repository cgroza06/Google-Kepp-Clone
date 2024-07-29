import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_keep_clone/theme/colors.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc, BuildContext context) {

  int colorId = doc['color_id'] is int ? doc['color_id'] : 0;
  String noteTitle = doc['note_title'] ?? 'No Title';
  String noteContent = doc['note_content'] ?? 'No Content';
  bool isLightMode = Theme.of(context).brightness == Brightness.light;
  List<Color> cardsColors = isLightMode
      ? AppStyle.CardsColorsLight
      : AppStyle.CardsColorsDark;

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: cardsColors[colorId],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            noteTitle,
            style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            noteContent,
            style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
