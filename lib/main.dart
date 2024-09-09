import 'package:booker/Screens/Check_User.dart';
import 'package:booker/Screens/Home_Screen.dart';
import 'package:booker/firebase_options.dart';
import 'package:booker/userAuth/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/userHome': (context) => HomeScreen(),
        '/shopHome': (context) => LogIn(),
      },
    );
  }
}
