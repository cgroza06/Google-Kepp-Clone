import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_keep_clone/pages/new_note_page.dart';
import 'package:google_keep_clone/pages/note_page.dart';
import 'package:google_keep_clone/pages/sidemenu_ios_page.dart';
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
      home: HomePageIOS(),
    );
  }
}

class HomePageIOS extends StatefulWidget {
  @override
  State<HomePageIOS> createState() => _HomePageIOSState();
}

class _HomePageIOSState extends State<HomePageIOS> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: SideMenuPageIOS(),
      body: getBody(context),
      bottomSheet: getFooter(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => NewNotePage(),
          ));
        },
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Center(
          child: SvgPicture.asset("assets/images/google_icon.svg",
            width: 40,
          ),
        )
      ),
    );
  }

  Widget getBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: searchBar(context, size),
          ),
          SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                      return isGridView ? StaggeredGrid.count(
                            crossAxisCount:  4,
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
                          )
                          : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListView.builder(
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
                              ),
                            );
                    },
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBar(BuildContext context, Size size) {
    return Container(
      width: size.width, 
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
              child: searchIconWithText(context),
            ),
            iconsRow(context),
          ],
        ),
      ),
    );
  }

  Widget searchIconWithText(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _drawerKey.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            "Search your notes",
            style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                letterSpacing: -0.4,
              ),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget iconsRow(BuildContext context) {
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
        userAvatar(),
      ],
    );
  }

  Widget userAvatar() {
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

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 20),
        child: Row(
          children: [
             Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check_box_outlined,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.brush_outlined,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.mic_none_rounded,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.photo_outlined,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
               ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
