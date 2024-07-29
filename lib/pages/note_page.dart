import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_keep_clone/theme/colors.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ignore: must_be_immutable
class NotePage extends StatefulWidget {
  NotePage(this.doc, {super.key});
  QueryDocumentSnapshot doc;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late int color_id;
  late bool isLightMode;
  late List<Color> cardsColors;
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    color_id = widget.doc['color_id'] is int ? widget.doc['color_id'] : 0;
    isLightMode = Theme.of(context).brightness == Brightness.light;
    cardsColors = isLightMode ? AppStyle.CardsColorsLight : AppStyle.CardsColorsDark;
    titleController = TextEditingController(text: widget.doc['note_title']);
    contentController = TextEditingController(text: widget.doc['note_content']);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> updateNoteColor(int newColorId) async {
    setState(() {
      color_id = newColorId;
    });

    await FirebaseFirestore.instance.collection("Notes").doc(widget.doc.id).update({
      "color_id": color_id,
    });

    print('Note color updated to ID: $color_id');
  }

  Future<void> saveNote() async {
    await FirebaseFirestore.instance.collection("Notes").doc(widget.doc.id).update({
      "note_title": titleController.text,
      "note_content": contentController.text,
      "color_id": color_id,
    });

    print('Note saved');
  }

    Future<void> deleteNote() async {
    await FirebaseFirestore.instance.collection("Notes").doc(widget.doc.id).delete();
    print('Note deleted');
  }


  void showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Pick a color",
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              letterSpacing: -0.4,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: cardsColors[color_id],
            availableColors: cardsColors,
            onColorChanged: (Color color) {
              int newColorId = cardsColors.indexOf(color);
              if (newColorId != -1) {
                updateNoteColor(newColorId);
              }
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isLightMode = Theme.of(context).brightness == Brightness.light;
    cardsColors = isLightMode ? AppStyle.CardsColorsLight : AppStyle.CardsColorsDark;

    return Scaffold(
      backgroundColor: cardsColors[color_id],
      appBar: getAppBar(context, color_id, cardsColors),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: -0.4,
                  ),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: contentController,
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: -0.3,
                  ),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: getFooter(context, color_id, cardsColors),
    );
  }

  AppBar getAppBar(context, color_id, List<Color> cardsColors) {
    return AppBar(
      backgroundColor: cardsColors[color_id],
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 22, color: Theme.of(context).colorScheme.primary),
        onPressed: () async {
          await saveNote();
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.push_pin_outlined, size: 22, color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notification_add_outlined, size: 22, color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.archive_outlined, size: 22, color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.delete_outline, size: 22, color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
          onPressed: () async {
            await deleteNote();
            Navigator.pop(context); 
          },
        ),
      ],
    );
  }


  Widget getFooter(context, color_id, List<Color> cardsColors) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(
        color: cardsColors[color_id],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.7,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_box_outlined,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showColorPicker(context);
                      },
                      icon: Icon(
                        Icons.palette_outlined,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  await saveNote();
                },
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
