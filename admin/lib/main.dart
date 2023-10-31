import 'dart:async';

import 'package:admin/firebase_options.dart';
import 'package:admin/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/login.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/logo.png'),
        nextScreen: HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      if(FirebaseAuth.instance.currentUser==null){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignInPage()));
      }else{
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignInPage()));
       
      }
     });
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/logo.png', height: 270.0, width: 250.0),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),

            // Spacer to push buttons to the bottom
            Spacer(),

            // Orange Box with Buttons
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              child: Container(
                color: Colors.orange,
                padding: EdgeInsets.only(
                    top: 70.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 70.0), // Adjust padding for top and bottom
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 16.0), // Spacer between buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Change the button color
                        minimumSize: Size(double.infinity,
                            50.0), // Set button width and height
                      ),
                      child: Text('Admin Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
