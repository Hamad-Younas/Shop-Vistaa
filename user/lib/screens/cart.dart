import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../firebase/firebase_methods.dart';
import '../utils/utils.dart';
import './profile.dart';
import './history.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int totalPrice = 0;
  String email = "";
  String name = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firebase_Functions firebaseFunctions = Firebase_Functions();
  List<Map<String, dynamic>> productList = [];

  Future<void> getProducts() async {
    List<Map<String, dynamic>> updatedProductList = [];
    try {
      updatedProductList = await firebaseFunctions.getMoreProduct();
      Utils().showMessageBar(context, "Data fetched successfully.");
    } catch (error) {
      print(error);
      Utils().showMessageBar(context, "Error fetching data: $error");
    }
    setState(() {
      productList = updatedProductList;
    });
  }

  Future<void> _addBuyHistory(String productName,String image, String price, String quantity) async {
    try {

      // Generate the document ID using milliseconds since epoch
      String documentId = DateTime.now().millisecondsSinceEpoch.toString();

      final Map<String, dynamic> data = {
        'id': documentId,
        'userName': name,
        'productName': productName,
        'price': price,
        'stock': quantity,
        'image': image,
        'date': DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(), // Format the current date
      };

      // Get a reference to the Firestore document with the custom ID
      final DocumentReference documentReference = FirebaseFirestore.instance.collection('buy_history').doc(documentId);

      // Set data to Firestore with the provided document ID
      await documentReference.set(data);
      // Now you can use the document ID as needed
      print("Added product with document ID: $documentId");
      Utils().showMessageBar(context, "Item Bought");
    } catch (error) {
      print(error);
    }
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
  @override
  void initState() {
    super.initState();
    getProducts();
    fetchUserData(); // Fetch data when the page is loaded
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                final productId = product['id'];
                return buildCartItem(
                  imageUrl: product['image'],
                  productName: product['name'],
                  productPrice: product['price'],
                  productStock: product['stock'],
                );
              },

            ),
            // Total Price
            SizedBox(height: 16),
            Text(
              'Total Price: \$ $totalPrice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // Checkout Button
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle checkout
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
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

  Widget buildCartItem({
    required String productName,
    required String imageUrl,
    required String productPrice,
    required String productStock,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          imageUrl,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
        title: Text(productName),
        subtitle: Text('Price: $productPrice\nQuantity: $productStock'),
        trailing: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            setState(() {
              totalPrice = totalPrice + int.parse(productPrice);
            });
            _addBuyHistory(productName, imageUrl, productPrice,productStock);
          },
          child: Text("Buy Now", style: TextStyle(color: Colors.white)),

        ),
      ),
    );
  }

}



