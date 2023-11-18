// ignore_for_file: use_build_context_synchronously

import 'package:final_project/firebase/firebase_methods.dart';
import 'package:final_project/screens/signin.dart';
import 'package:final_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   clientId:
//       '178896080956-rb8sfav083ipvulr2im4m5jiv1q37r15.apps.googleusercontent.com',
// );

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  Future<void> register() async {
    // final String apiUrl = 'http://localhost:4000/register';

    final Map<String, String> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      setState(() {
        _isLoading = true;
      });
      await Firebase_Functions()
          .signup(emailController.text, passwordController.text, data);

      // final response = await http.post(
      //   Uri.parse(apiUrl),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(data),
      // );

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = jsonDecode(response.body);
      //   if (responseData['message'] == 'register') {
      //     _showSuccessAlert(context);
      //     // Clear form data
      //     nameController.clear();
      //     emailController.clear();
      //     passwordController.clear();
      //   } else if (responseData['message'] == 'already') {
      //     _showErrorAlert(context);
      //   }
      // } else {
      //   // Registration failed
      //   print('Registration failed with status code ${response.statusCode}');
      //   print('Response body: ${response.body}');
      // }
    } catch (error) {
      // Handle network or server errors
      Utils().showMessageBar(context, error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       print('Google Sign-In canceled by user.');
  //       return;
  //     }

  //     // Print user details
  //     print('Google User Details:');
  //     print('Display Name: ${googleUser.displayName}');
  //     print('Email: ${googleUser.email}');
  //     print('Google ID: ${googleUser.id}');

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Print authentication details
  //     print('Google Authentication Details:');
  //     print('Access Token: ${googleAuth.accessToken}');
  //     print('ID Token: ${googleAuth.idToken}');

  //     // You can use the Google user details for your authentication logic
  //     // For example, you might send the email to your server for verification
  //     // and handle the registration/login process.

  //     print('Google Sign-In successful');
  //   } catch (error) {
  //     print('Error during Google Sign-In: $error');
  //   }
  // }

  Future<void> _showSuccessAlert(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('You have been registered successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorAlert(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Already Exists'),
          content: const Text('You cannot register with this email again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
            Image.asset('assets/logo.png', height: 80.0, width: 80.0),
            const SizedBox(height: 16.0),
            const Text(
              'SIGN UP WITH',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // ElevatedButton.icon(
            //   onPressed: () => signInWithGoogle(context),
            //   icon: Image.network(
            //     'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
            //     height: 24.0,
            //     width: 24.0,
            //   ),
            //   label: Text('Sign Up with Google'),
            // ),
            const SizedBox(height: 16.0),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('OR'),
                ),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => register(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
              child: const Text(
                'Already have an account? Login',
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
