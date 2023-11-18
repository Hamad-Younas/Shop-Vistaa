import 'dart:convert';
import 'package:final_project/firebase/firebase_methods.dart';
import 'package:final_project/screens/home.dart';
import 'package:final_project/screens/signup.dart';
import 'package:final_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String email;
  final String password;

  User({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final user = User(
      email: emailController.text,
      password: passwordController.text,
    );
    try {
    UserCredential user=  await Firebase_Functions()
          .login(emailController.text, passwordController.text);
   if(user.user!=null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
   }
   else{
      Utils().showMessageBar(context, "error".toString());
    
   }
    } catch (error) {
      Utils().showMessageBar(context, error.toString());
    }
    // final response = await http.post(
    //   Uri.parse(
    //       'http://localhost:4000/login'), // Replace with your API endpoint
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(user.toJson()),
    // );

    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> responseData = jsonDecode(response.body);
    //   if (responseData['message'] == 'success') {
    //     await _saveEmailToPrefs(emailController.text);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //             'Saved email to SharedPreferences: ${emailController.text}'),
    //         duration: Duration(seconds: 3),
    //       ),
    //     );
    //     _navigateToHomePage(context);
    //   } else if (responseData['message'] == 'invalid') {
    //     _showErrorAlert(context);
    //   }
    // } else {
    //   // Failed login, handle the error response accordingly
    //   print('Login failed. Status code: ${response.statusCode}');
    //   print('Response body: ${response.body}');
    // }
  }

  void _navigateToHomePage(BuildContext context) {
    // Navigate to the home page or any other page you want to display after successful login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomeScreen(), // Replace HomePage with your desired widget
      ),
    );
  }

  Future<void> _saveEmailToPrefs(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  Future<String?> _getEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  Future<void> _showErrorAlert(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Login'),
          content: Text('Email or password is incorrect'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Image.asset('assets/logo.png', height: 80.0, width: 80.0),

            SizedBox(height: 16.0),

            // "SIGN UP WITH" text
            // Text(
            //   'SIGN IN WITH',
            //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),

            // SizedBox(height: 16.0),

            // Google signup option
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // Add your Google signup logic here
            //   },
            //   icon: Image.network(
            //     'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
            //     height: 24.0,
            //     width: 24.0,
            //   ),
            //   label: Text('Sign In with Google'),
            // ),

            SizedBox(height: 16.0),

            // OR line
            // Row(
            //   children: [
            //     Expanded(child: Divider()),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       child: Text('OR'),
            //     ),
            //     Expanded(child: Divider()),
            //   ],
            // ),

            SizedBox(height: 16.0),

            // Email input
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 8.0),

            // Password input
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            SizedBox(height: 16.0),

            // Login button
            ElevatedButton(
              onPressed: () async {
                await _login(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),

            SizedBox(height: 16.0),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                "Don't have an account? Register",
                style: TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
