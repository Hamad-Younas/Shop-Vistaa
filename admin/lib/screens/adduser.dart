import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../firebase/firebase.dart';
import '../utils/utils.dart';
import 'homepage.dart';


class AddUsers extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddUsers> {
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  // For image picking

  Future<void> _addUser() async {
    try {
      // Generate the document ID using milliseconds since epoch
      String documentId = DateTime.now().millisecondsSinceEpoch.toString();

      final Map<String, dynamic> data = {
        'id': documentId,
        'name': _userNameController.text,
        'email': _userEmailController.text,
        'password': _userEmailController.text,
      };

      // Get a reference to the Firestore document with the custom ID
      final DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(documentId);

      // Set data to Firestore with the provided document ID
      await documentReference.set(data);

      // Now you can use the document ID as needed
      print("Added product with document ID: $documentId");
      Utils().showMessageBar(context, "User added");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: _userEmailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true, // Hide the entered text for passwords
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Utils().showMessageBar(context, "User is adding...");
                _addUser();
              },
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
