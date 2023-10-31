import 'package:admin/screens/userdetails.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase.dart';
import '../utils/utils.dart';
import './adduser.dart';

class UsersPage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<UsersPage> {
  int _currentIndex = 0;
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

  @override
  void initState() {
    super.initState();
    getUsers(); // Fetch data when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add Product Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddUsers()),
                  );
                },
                child: Text('Add User'),
              ),

              SizedBox(height: 16.0),

              // Integrating PlaningGrid with user data
              GridView.builder(
                itemCount: usersList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 16 / 4,
                  crossAxisCount: 1,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final user = usersList[index];
                  final userId = user['id'];
                  final userName = user['name'];
                  final userEmail = user['email'];
                  final userPassword = user['password'];

                  // Replace the icon with an admin icon
                  final adminIcon = Icon(Icons.admin_panel_settings);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetails(
                            userId: userId,
                            userName: userName,
                            userEmail: userEmail,
                            userPassword: userPassword,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.orange, // Change color as needed
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 55,
                                  width: 55,
                                  child: adminIcon,
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userName ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  userEmail ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
