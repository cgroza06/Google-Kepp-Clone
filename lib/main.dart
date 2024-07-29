import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_keep_clone/firebase_options.dart';
import 'package:google_keep_clone/pages/home_page_ios.dart';
import 'package:google_keep_clone/pages/home_page_web.dart';
import 'package:google_keep_clone/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(), 
    ),
  ); 
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageWrapper(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return kIsWeb ? HomePageWeb() : HomePageIOS(); 
  }
}