import 'package:admin/firebase/firebase.dart';
import 'package:admin/screens/homepage.dart';
import 'package:admin/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;


class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();

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


  Future<void> _addProduct() async {
    try {
      String url = await Firebase_Functions().uploadPost('images/', DateTime.now().toString() + "pic", _imageFile!);

      // Generate the document ID using milliseconds since epoch
      String documentId = DateTime.now().millisecondsSinceEpoch.toString();

      final Map<String, dynamic> data = {
        'id': documentId,
        'name': _productNameController.text,
        'category': _categoryController.text,
        'price': _priceController.text,
        'stock': _stockController.text,
        'description': _descriptionController.text,
        'image': url,
      };

      // Get a reference to the Firestore document with the custom ID
      final DocumentReference documentReference = FirebaseFirestore.instance.collection('products').doc(documentId);

      // Set data to Firestore with the provided document ID
      await documentReference.set(data);

      // Now you can use the document ID as needed
      print("Added product with document ID: $documentId");
      Utils().showMessageBar(context, "Product added");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } catch (error) {
      print(error);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
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
                    child: _imageFile != null ? Image.file(_imageFile!) : Container(),
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
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Utils().showMessageBar(context, "Product is adding...");
                _addProduct();
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}