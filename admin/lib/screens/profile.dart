import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DatabaseHelper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      email = user.email ?? '';
      print('Current user email: $email');

      try {
        // Perform a query to find the user document with a matching email
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        // Check if any documents were found
        if (querySnapshot.docs.isNotEmpty) {
          // Retrieve the name from the first document found
          setState(() {
            name = querySnapshot.docs.first['name'];
            // Store user data in SQLite
            _storeUserDataInSQLite(name, email);
          });
          print('User name: $name');
        } else {
          print('No user document found for email: $email');
        }
      } catch (error) {
        print('Error fetching user data: $error');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  Future<void> _storeUserDataInSQLite(String name, String email) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.insertUser(name, email);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Avatar
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage(
                      'https://media.licdn.com/dms/image/D4D03AQFR944WBvuYxQ/profile-displayphoto-shrink_800_800/0/1677053137622?e=2147483647&v=beta&t=kHRDYUP8OUv_rBFzT5mOdyOlAJkaOi892MTyZMV0ZgE',
                    ),
                  ),
                ],
              ),
            ),

            // Profile Details
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $name',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),

            // Edit Profile Button with Padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Open edit modal
                  _showEditProfileModal(context);
                },
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the edit profile modal
  void _showEditProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

              // Image Upload Option
              ElevatedButton(
                onPressed: () {
                  // Handle image upload
                },
                child: const Text('Upload Profile Image'),
              ),
              const SizedBox(height: 16.0),

              // Change Name Option
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Change Name',
                ),
              ),
              const SizedBox(height: 16.0),

              // Change Email Option
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Change Email',
                ),
              ),
              const SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () {
                  // Handle save changes
                  Navigator.pop(context); // Close the modal
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }
}

