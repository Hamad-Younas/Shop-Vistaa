import 'package:flutter/material.dart';

import '../firebase/firebase.dart';
import '../utils/utils.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final Firebase_Functions firebaseFunctions = Firebase_Functions();
  List<Map<String, dynamic>> productList = [];
  TextEditingController searchController = TextEditingController();

  Future<void> getProducts() async {
    List<Map<String, dynamic>> updatedProductList = [];
    try {
      updatedProductList = await firebaseFunctions.getMoreBuyProduct();
      Utils().showMessageBar(context, "Data fetched successfully.");
    } catch (error) {
      print(error);
      Utils().showMessageBar(context, "Error fetching data: $error");
    }
    setState(() {
      productList = updatedProductList;
    });
  }
  Future<void> searchProducts(String productName) async {
    try {
      List<Map<String, dynamic>> searchResult = await firebaseFunctions.searchProductByName(productName);
      setState(() {
        productList = searchResult;
      });
      Utils().showMessageBar(context, "Search successful.");
    } catch (error) {
      print(error);
      Utils().showMessageBar(context, "Error searching: $error");
    }
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
        title: Text('Orders'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Call PlaningGrid with productList data
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter product name...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    String productName = searchController.text.trim();
                    if (productName.isNotEmpty) {
                      searchProducts(productName);
                    }
                  },
                  child: Text('Search'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: PlaningGrid(productList: productList),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaningGrid extends StatelessWidget {
  final List<Map<String, dynamic>> productList;

  const PlaningGrid({Key? key, required this.productList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: productList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Adjust as needed
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        final product = productList[index];
        final userName = product['userName'];
        final productName = product['productName'];
        final price = product['price'];
        final date = product['date'];

        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SizedBox(
            height: 200, // Adjust the height as needed
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Text(
                    'Buyer: $userName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Product: $productName',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    'Price: $price',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    'Date: $date',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
