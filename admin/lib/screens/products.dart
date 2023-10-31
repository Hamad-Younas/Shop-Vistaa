import 'dart:io';

import 'package:admin/firebase/firebase.dart';
import 'package:admin/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './addproduct.dart';
import './products.dart';
import './productdetail.dart';
import 'homepage.dart';

class Productpage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<Productpage> {
  final Firebase_Functions firebaseFunctions = Firebase_Functions();
  List<Map<String, dynamic>> productList = [];
  Future<void> ProductDelete(id) async {
    try {
      await firebaseFunctions.deleteProduct(id);
      Utils().showMessageBar(context, "Data fetched successfully.");
    } catch (error) {
      print(error);
      Utils().showMessageBar(context, "Error fetching data: $error");
    }
  }

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

  @override
  void initState() {
    super.initState();
    getProducts(); // Fetch data when the page is loaded
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
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
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductScreen()),
                  );
                },
                child: Text('Add Product'),
              ),

              SizedBox(height: 16.0),

              // Product Cards
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  final productId = product['id'];
                  return ProductCard(
                    productId: productId,
                    imageUrl: product['image'],
                    productName: product['name'],
                    productPrice: product['price'],
                    productCategory: product['category'],
                    productStock: product['stock'],
                    productDescription: product['description'],
                  );
                  getProducts();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;
  final String productId;
  final String productCategory;
  final String productStock;
  final String productDescription;

  ProductCard({
    required this.productId,
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.productCategory,
    required this.productStock,
    required this.productDescription,
  });

  @override
  State<ProductCard> createState() => _ProductCardState(
      imageUrl,
      productName,
      productPrice,
      productId,
      productCategory,
      productStock,
      productDescription);
}

class _ProductCardState extends State<ProductCard> {
  final String imageUrl;
  final String productName;
  final String productPrice;
  final String productId;
  final String productCategory;
  final String productStock;
  final String productDescription;
  final Firebase_Functions firebaseFunctions = Firebase_Functions();

  _ProductCardState(
      this.imageUrl,
      this.productName,
      this.productPrice,
      this.productId,
      this.productCategory,
      this.productStock,
      this.productDescription);

  Future<void> ProductDelete(String id) async {
    try {
      await firebaseFunctions.deleteProduct(id);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminHomePage()));
      Utils().showMessageBar(context, "Product deleted");
      print("Deleted");
    } catch (error) {
      print("Error deleting: $error");
      // Handle error message display or any other action.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with error widget
          Image(
            image: NetworkImage(imageUrl),
            height: 150.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  productPrice,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 8.0), // Add space between price and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Inside _AdminHomePageState
                    ElevatedButton(
                      onPressed: () async {
                        // Navigate to the update product screen and await the result
                        final bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProductScreen(
                              productId: productId,
                              productName: productName,
                              productPrice: productPrice,
                              productCategory: productCategory,
                              productStock: productStock,
                              productDescription: productDescription,
                              imageUrl: imageUrl,
                            ),
                          ),
                        );

                        // If the result is true, refresh the product list
                        if (result == true) {
                          _AdminHomePageState().getProducts();
                        }
                      },
                      child: Text('Update'),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Utils()
                            .showMessageBar(context, "Product is deleting...");
                        ProductDelete(productId);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateProductScreen extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String productName;
  final String productCategory;
  final String productPrice;
  final String productStock;
  final String productDescription;

  UpdateProductScreen({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productPrice,
    required this.productStock,
    required this.productDescription,
    required this.imageUrl,
  });

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // For image file
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.productName;
    _categoryController.text = widget.productCategory;
    _priceController.text = widget.productPrice;
    _stockController.text = widget.productStock;
    _descriptionController.text = widget.productDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _imageFile != null
                        ? Image.file(_imageFile!)
                        : Container(),
                  ),
                  _imageFile == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Product Category'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Product Stock'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Product Description'),
            ),
            ElevatedButton(
              onPressed: () {
                Utils().showMessageBar(context, "Product is updating...");
                _updateProduct();
              },
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProduct() async {
    try {
      String url = await Firebase_Functions().uploadPost(
          'images/', DateTime.now().toString() + "pic", _imageFile!);

      final Map<String, dynamic> updatedData = {
        'id': widget.productId, // Use the existing ID
        'name': _productNameController.text,
        'category': _categoryController.text,
        'price': _priceController.text,
        'stock': _stockController.text,
        'description': _descriptionController.text,
        'image': url, // Replace with the new image URL
      };

      // Implement the logic to update the product in Firebase
      // For example, if using Firestore:
      await FirebaseFirestore.instance
          .collection('products') // Replace with your collection name
          .doc(widget.productId)
          .update(updatedData);

      Utils().showMessageBar(context, "Product is updated");
      // After a successful update, you may want to notify the previous screen to refresh the data.
      // Example using Navigator.pop with a result
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } catch (error) {
      print("Error updating product: $error");
      // Handle error, show a message, etc.
    }
  }
}



// bottomNavigationBar: BottomNavigationBar(
//   selectedItemColor: Colors.orange,
//   unselectedItemColor: Colors.black,
//   showUnselectedLabels: true,
//   items: [
//     BottomNavigationBarItem(
//       icon: Icon(Icons.home),
//       label: 'Home',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.shopping_cart),
//       label: 'Products',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.people),
//       label: 'Users',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.person),
//       label: 'Profile',
//     ),
//   ],
// ),


// Future<void> ProductDelete(id) async {
//   try {
//     await firebaseFunctions.deleteProduct(id);
//     // Utils().showMessageBar(context, "Data fetched successfully.");
//   } catch (error) {
//     print(error);
//     // Utils().showMessageBar(context, "Error fetching data: $error");
//   }
// }