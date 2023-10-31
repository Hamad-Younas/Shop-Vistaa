import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase.dart';
import '../utils/utils.dart';
import 'homepage.dart';


class UserDetails extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String userPassword;

  const UserDetails({super.key, required this.userId, required this.userName, required this.userEmail, required this.userPassword});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState(userId,userName,userEmail,userPassword);
}

class _ProductDetailsScreenState extends State<UserDetails> {
  final String userId;
  final String userName;
  final String userEmail;
  final String userPassword;

  double selectedRating = 0;

  _ProductDetailsScreenState(this.userId, this.userName, this.userEmail, this.userPassword);
  final Firebase_Functions firebaseFunctions = Firebase_Functions();
  List<Map<String, dynamic>> usersList = [];

  Future<void> getUsers() async {
    List<Map<String, dynamic>> updatedUsersList = [];
    try {
      updatedUsersList = await firebaseFunctions.getMoreUsers();
      Utils().showMessageBar(context, "Data fetched successfully.");
    } catch (error) {
      print(error);
      Utils().showMessageBar(context, "Error fetching data: $error");
    }
    setState(() {
      usersList = updatedUsersList;
    });
  }

  Future<void> UserDelete(String id) async {
    try {
      await firebaseFunctions.deleteUser(id);
      print("Deleted");
      Utils().showMessageBar(context, "User deleted");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } catch (error) {
      print("Error deleting: $error");
      // Handle error message display or any other action.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Image.network(
                'https://media.licdn.com/dms/image/D4D03AQFR944WBvuYxQ/profile-displayphoto-shrink_800_800/0/1677053137622?e=2147483647&v=beta&t=kHRDYUP8OUv_rBFzT5mOdyOlAJkaOi892MTyZMV0ZgE',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 16),

              // Product Details
              Text(
                userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(userEmail),
              Column(
                children: [
                  SizedBox(height: 16.0), // Add space above the buttons

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateUsers(userId: userId, userName: userName, userEmail: userEmail, userPassword: userPassword,),));
                          getUsers();
                        },
                        style: ElevatedButton.styleFrom(
                          primary:
                              Colors.green, // Set the background color to green
                        ),
                        child: Text('Update'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Utils().showMessageBar(context, "User is deleting...");
                          UserDelete(userId);
                        },
                        style: ElevatedButton.styleFrom(
                          primary:
                              Colors.red, // Set the background color to red
                        ),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserReview({
    required String avatarUrl,
    required String username,
    required double rating,
    required String review,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text('$rating'),
                ],
              ),
              Text(review),
            ],
          ),
        ],
      ),
    );
  }

  void _showGiveReviewModal(BuildContext context) {
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
                'Give Review',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),

              // Rating Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rating'),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index + 1 <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          // Handle rating selection
                          setState(() {
                            selectedRating = index + 1.toDouble();
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              // Review Input Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Write your review...',
                ),
              ),

              SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () {
                  // Handle submit review
                  Navigator.pop(context); // Close the modal
                },
                child: Text('Submit Review'),
              ),
            ],
          ),
        );
      },
    );
  }
}


class UpdateUsers extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String userPassword;

  const UpdateUsers({super.key, required this.userId, required this.userName, required this.userEmail, required this.userPassword});


  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUsers> {
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  // For image picking


  void _updateUser() async {
    try {
      final Map<String, dynamic> updatedData = {
        'id': widget.userId,
        'name': _userNameController.text,
        'email': _userEmailController.text,
        'password': _userEmailController.text,
      };

      // Implement the logic to update the product in Firebase
      // For example, if using Firestore:
      await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(widget.userId)
          .update(updatedData);

      Utils().showMessageBar(context, "User updated");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } catch (error) {
      print("Error updating product: $error");
      // Handle error, show a message, etc.
    }
  }

  @override
  void initState() {
    _userNameController.text = widget.userName;
    _passwordController.text = widget.userPassword;
    _userEmailController.text = widget.userEmail;
    super.initState();
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
                Utils().showMessageBar(context, "User is updating...");
                _updateUser();
              },
              child: Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}
