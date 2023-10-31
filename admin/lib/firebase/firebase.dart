import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Firebase_Functions {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  signup(email, password) async {
    UserCredential _user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firebaseFirestore.collection('users').doc(_user.user!.uid).set({
      "name": "name",
      'id': _user.user!.uid,
    });
  }

  Future<UserCredential> login(email, password) async {
    try {
      UserCredential _user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addDataToFirestore(dataToAdd) async {
    try {
      // Access Firestore instance and add data to a collection
      await FirebaseFirestore.instance.collection('products').add(dataToAdd);
      print("Data added successfully!");
    } catch (e) {
      print("Error adding data: $e");
    }
  }
  
  Future<String> uploadPost(String path, String name, File file) async {
    Reference ref = _storage.ref().child('$path/$name');
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => null); // Wait for upload to complete
    String link = await ref.getDownloadURL();
    return link;
  }

  Future<void> deleteProduct(String id) async {
    await _firebaseFirestore.collection('products').doc(id).delete();
  }

  Future<void> deleteUser(String id) async {
    await _firebaseFirestore.collection('users').doc(id).delete();
  }
  
  Future<List<Map<String, dynamic>>> getMoreProduct() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('products').get();
    // Mapping the QuerySnapshot to a List<Map<String, dynamic>>
    List<Map<String, dynamic>> productList = data.docs.map((doc) => doc.data()).toList();
print(productList.length);    
    return productList;
  }

  Future<List<Map<String, dynamic>>> getMoreBuyProduct() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('buy_history').get();
    // Mapping the QuerySnapshot to a List<Map<String, dynamic>>
    List<Map<String, dynamic>> productList = data.docs.map((doc) => doc.data()).toList();
    print(productList.length);
    return productList;
  }
  Future<List<Map<String, dynamic>>> getMoreUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userQuerySnapshot = await _firebaseFirestore.collection('users').get();
      List<Map<String, dynamic>> userList = userQuerySnapshot.docs.map((userDoc) => userDoc.data()).toList();
      return userList;
    } catch (error) {
      print("Error fetching users: $error");
      throw error;
    }
  }
  Future<List<Map<String, dynamic>>> searchProductByName(String productName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
          .collection('products')
          .where('productName', isEqualTo: productName)
          .get();

      List<Map<String, dynamic>> productList = data.docs.map((doc) => doc.data()).toList();
      return productList;
    } catch (error) {
      print("Error searching products by name: $error");
      throw error;
    }
  }
}
