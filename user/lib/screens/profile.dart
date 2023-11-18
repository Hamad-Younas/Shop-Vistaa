import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/firebase/firebase_methods.dart';
import 'package:final_project/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';

import '../DatabseHelper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  String email = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    FirebaseAuth.User? user = _auth.currentUser;

    if (user != null) {
      email = user.email ?? '';
      print('Current user email: $email');

      try {
        // Perform a query to find the user document with a matching email
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: email)
                .get();

        name = querySnapshot.docs.first['name'];
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
        title: Text('Profile'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Avatar
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage('https://media.licdn.com/dms/image/C4D03AQHpy5omMOtxRA/profile-displayphoto-shrink_200_200/0/1659875739780?e=2147483647&v=beta&t=V33oLgkS3v_Pkd6rEscvzybz2e6_730AjV3b5NX1Ndo'),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),

            // Profile Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $name',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // Update button color
                  onPrimary: Colors.white, // Update text color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                onPressed: () {
                  // Open edit modal
                  _showEditProfileModal(context);
                },
                child: Text('Edit Profile'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Show logout confirmation dialog
                  _showLogoutConfirmation(context);
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pop();

                // Navigate to the SignInPage after logout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileModal(BuildContext context) {
    String newName = name; // Initialize with the current name
    String newEmail = email; // Initialize with the current email

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),

              // Change Name Option
              TextFormField(
                initialValue: name,
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Change Name',
                ),
              ),
              SizedBox(height: 16.0),

              // Change Email Option
              TextFormField(
                initialValue: email,
                onChanged: (value) {
                  newEmail = value;
                },
                decoration: InputDecoration(
                  labelText: 'Change Email',
                ),
              ),
              SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () async {
                  // Handle save changes
                  await Firebase_Functions().updateProfile(newName, newEmail);

                  // Update the UI with the new data
                  setState(() {
                    name = newName;
                    email = newEmail;
                  });

                  Navigator.pop(context); // Close the modal
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }
}