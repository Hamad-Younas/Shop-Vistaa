import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Firebase_Functions {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> signup(email, password, Map<String, String> data) async {
    try {
      UserCredential _user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      data['id'] = _user.user!.uid;
      await _firebaseFirestore
          .collection('users')
          .doc(_user.user!.uid)
          .set(data);
    } catch (e) {
      rethrow;
    }
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

  get1Product() async {
    await _firebaseFirestore.collection('users').doc('id').get();
  }

  updateProduct() async {
    await _firebaseFirestore.collection('users').doc('id').update({});
  }

  deleteProduct() async {
    await _firebaseFirestore.collection('users').doc('id').delete();
  }

  Future<List<Map<String, dynamic>>> getMoreProduct() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection('products').get();
    // Mapping the QuerySnapshot to a List<Map<String, dynamic>>
    List<Map<String, dynamic>> productList =
        data.docs.map((doc) => doc.data()).toList();
    print(productList.length);
    return productList;
  }

  Future<List<Map<String, dynamic>>> getMoreBuyProduct() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('buy_history')
        .where('userName', isEqualTo: 'admin')
        .get();

    // Mapping the QuerySnapshot to a List<Map<String, dynamic>>
    List<Map<String, dynamic>> productList =
        data.docs.map((doc) => doc.data()).toList();

    print(productList.length);
    return productList;
  }

  Future<String> uploadPost(String path, String name, File file) async {
    Reference ref = _storage.ref().child('$path/$name');
    UploadTask uploadTask = ref.putFile(file);
    await Future.value(uploadTask);
    String link = await ref.getDownloadURL();

    return link;
  }

  Future<void> updateProfile(String newName, String newEmail) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update name and email in Firebase Authentication
        await user.updateDisplayName(newName);
        await user.updateEmail(newEmail);

        // Update name and email in Firestore
        await _firebaseFirestore.collection('users').doc(user.uid).update({
          'name': newName,
          'email': newEmail,
        });

        print('Profile updated successfully.');
      } else {
        print('User is not signed in. Unable to update profile.');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}
