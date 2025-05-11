import 'package:flutter/material.dart';
import 'package:listify/screen/home_screen.dart';
import 'package:listify/screen/splash_screen.dart';
import 'screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized(); // <-- Important for Firebase!
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const ListifyApp());
  }

class ListifyApp extends StatelessWidget {
  const ListifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}