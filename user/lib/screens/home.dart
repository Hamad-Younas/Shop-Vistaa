import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './details.dart';
import './cart.dart';
import './profile.dart';
import './history.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopVista'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapShot.hasData || snapShot.data!.docs.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            }
            return ListView.builder(
              itemCount: snapShot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors
                        .grey[200], // Setting gray as the background color
                    borderRadius:
                        BorderRadius.circular(10.0), // Adding a border radius
                    border: Border.all(color: Colors.orange), // Adding a border
                  ),
                  child: ListTile(
                    leading: Image.network(
                      snapShot.data!.docs[index]['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(snapShot.data!.docs[index]['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapShot.data!.docs[index]['description']),
                        Text('Price: \$${snapShot.data!.docs[index]['price']}'),
                        Text('Stock: ${snapShot.data!.docs[index]['stock']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Buy History',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation item taps
          if (index == 1) {
            // Navigate to the Cart screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          }
          if (index == 2) {
            // Navigate to the Cart screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
          if (index == 3) {
            // Navigate to the Cart screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuyHistory()),
            );
          }
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }
}

class TrendingProductWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;

  TrendingProductWidget(
      {required this.imageUrl, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl,
              height: 150.0, width: 150.0, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.0),
                Text(price,
                    style: TextStyle(fontSize: 14.0, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
