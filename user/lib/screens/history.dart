import 'package:final_project/Shareperference/sharedPreference.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase_methods.dart';
import '../utils/utils.dart';
import './cart.dart';
import './buy.dart';
import './profile.dart';

class BuyHistory extends StatefulWidget {
  @override
  _BuyHistoryState createState() => _BuyHistoryState();
}

class _BuyHistoryState extends State<BuyHistory> {
  int totalPrice = 0;
  final Firebase_Functions firebaseFunctions = Firebase_Functions();
  List<Map<String, dynamic>> productList = [];

  Future<void> getProducts() async {
    List<Map<String, dynamic>> updatedProductList = [];
    try {
      updatedProductList = await firebaseFunctions.getMoreBuyProduct();
      updateTotalPrice(updatedProductList);
      Utils().showMessageBar(context, "Data fetched successfully.");
    } catch (error) {
      print(error);
      Utils().showMessageBar(context, "Error fetching data: $error");
    }
    setState(() {
      productList = updatedProductList;
    });
  }

  void updateTotalPrice(List<Map<String, dynamic>> products) {
    int total = 0;
    for (final product in products) {
      total += int.parse(product['price']);
    }
    setState(() {
      totalPrice = total;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts(); // Fetch data when the page is loaded
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
        child: SingleChildScrollView(
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
                  final imageUrl = product['image'];
                  final productName = product['productName'];
                  final productPrice = product['price'];
                  final productStock = product['stock'];

                  return buildCartItem(
                    imageUrl: product['image'],
                    productName: product['productName'],
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
            ],
          ),
        ),
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
      ),
    );
  }
}
