import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:google_keep_clone/theme/colors.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({Key? key}) : super(key: key);

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int color_id = 0;
  int note_id = 0; 
  Timer? _debounce;
  bool isNewNote = true; 

  @override
  void initState() {
    super.initState();
    _getNoteId(); 
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getNoteId() async {
    if (isNewNote) {
      DocumentSnapshot counterDoc = await FirebaseFirestore.instance
          .collection('Counters')
          .doc('note_counter')
          .get();

      if (counterDoc.exists) {
        note_id = counterDoc['current_id'] + 1;
      } else {
        note_id = 1;
        await FirebaseFirestore.instance
            .collection('Counters')
            .doc('note_counter')
            .set({'current_id': 0});
      }
      
      await FirebaseFirestore.instance
          .collection('Counters')
          .doc('note_counter')
          .update({'current_id': note_id});

      setState(() {}); 
    }
  }

  Future<void> saveNoteToDatabase() async {
    if (note_id == 0) return; 

    await FirebaseFirestore.instance.collection("Notes").doc(note_id.toString()).set({
      "note_title": titleController.text,
      "note_content": contentController.text,
      "color_id": color_id,
      "note_id": note_id,
    });

    print('Note saved with ID: $note_id');
  }

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    List<Color> cardsColors = isLightMode
        ? AppStyle.CardsColorsLight
        : AppStyle.CardsColorsDark;

    return Scaffold(
      backgroundColor: cardsColors[color_id],
      appBar: AppBar(
        backgroundColor: cardsColors[color_id],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            onPressed: saveNoteToDatabase,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onChanged: (text) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  saveNoteToDatabase();
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
              ),
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            SizedBox(height: 1.0),
            TextField(
              controller: contentController,
              onChanged: (text) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  saveNoteToDatabase();
                });
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note',
              ),
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
}
