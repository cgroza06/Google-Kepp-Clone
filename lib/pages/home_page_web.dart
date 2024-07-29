import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_keep_clone/pages/note_page.dart';
import 'package:google_keep_clone/pages/sidemenu_web.dart';
import 'package:google_keep_clone/widgets/note_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.white,
          primary: Colors.black,
          tertiary: Colors.grey[200],
        ),
      ),
      home: HomePageWeb(),
    );
  }
}

class HomePageWeb extends StatefulWidget {
  @override
  _HomePageWebState createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool isGridView = true;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  int colorId = 0;
  int noteId = 0;
  Timer? _debounce;
  bool isNewNote = true;
  bool _isWritingNote = false;

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
        noteId = counterDoc['current_id'] + 1;
      } else {
        noteId = 1;
        await FirebaseFirestore.instance
            .collection('Counters')
            .doc('note_counter')
            .set({'current_id': 0});
      }

      await FirebaseFirestore.instance
          .collection('Counters')
          .doc('note_counter')
          .update({'current_id': noteId});

      setState(() {});
    }
  }

  void clearFields() {
    titleController.clear();
    contentController.clear();
  }

  void _startWritingNote() {
    setState(() {
      _isWritingNote = true;
    });
  }

  Future<void> saveNoteToDatabase() async {
    if (noteId == 0 || (titleController.text.isEmpty && contentController.text.isEmpty)) return;

    await FirebaseFirestore.instance.collection("Notes").doc(noteId.toString()).set({
      "note_title": titleController.text,
      "note_content": contentController.text,
      "color_id": colorId,
      "note_id": noteId,
    });

    print('Note saved with ID: $noteId');
    clearFields();
    setState(() {
      _isWritingNote = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _buildAppBar(context),
      drawer: SideMenuPageWeb(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      toolbarHeight: 60,
      title: _buildSearchBar(context, MediaQuery.of(context).size),
      actions: [_buildIconsRow(context)],
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.primary,
          size: 30,
        ),
        onPressed: () {
          _drawerKey.currentState!.openDrawer();
        },
      ),
    );
  }

  

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _isWritingNote ? _buildNewNoteForm(context) : _buildInitialContainer(context),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No notes found'));
                }
                return isGridView ? _buildGridView(snapshot) : _buildListView(snapshot);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialContainer(BuildContext context) {
    return GestureDetector(
      onTap: _startWritingNote,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Text(
              'Note...',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewNoteForm(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 0.3),
              TextField(
                controller: titleController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
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
              SizedBox(height: 0.3),
              TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note',
                ),
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isWritingNote = false;
                    });
                    saveNoteToDatabase();
                  },
                  child: Text(
                    'Close',
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.5,
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildSearchIconWithText(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchIconWithText(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            "Search",
            style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                letterSpacing: -0.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconsRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isGridView ? Icons.view_agenda_outlined : Icons.grid_view,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            size: 23,
          ),
          onPressed: () {
            setState(() {
              isGridView = !isGridView;
            });
          },
        ),
        const SizedBox(width: 10),
        _buildUserAvatar(),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.network(
          "https://www.techjunkie.com/wp-content/uploads/2020/08/How-to-Add-Someone-to-Google-Keep-1280x720.jpg",
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Icon(Icons.account_circle, size: 30, color: Colors.grey);
          },
        ),
      ),
    );
  }

  Widget _buildGridView(AsyncSnapshot<QuerySnapshot> snapshot) {
    return StaggeredGrid.count(
      crossAxisCount: 10,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: List.generate(snapshot.data!.docs.length, (index) {
        var doc = snapshot.data!.docs[index];
        return StaggeredGridTile.fit(
          crossAxisCellCount: 2,
          child: noteCard(() {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => NotePage(doc),
            ));
          }, doc, context),
        );
      }),
    );
  }

  Widget _buildListView(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        var doc = snapshot.data!.docs[index];
        return noteCard(() {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => NotePage(doc),
          ));
        }, doc, context);
      },
    );
  }
}
