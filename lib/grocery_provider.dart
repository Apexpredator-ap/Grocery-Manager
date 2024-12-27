import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class GroceryProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addGroceryItem(
      String name, String quantity, String imagePath) async {
    try {
      // Convert image to base64
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';

      // Save to Firestore
      await _firestore.collection('groceries').add({
        'name': name,
        'quantity': quantity,
        'imageUrl': base64Image,
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add grocery item: $e');
    }
  }

  Stream<QuerySnapshot> fetchGroceries() {
    return _firestore
        .collection('groceries')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> updateStatus(String documentId, String newStatus) async {
    try {
      await _firestore
          .collection('groceries')
          .doc(documentId)
          .update({'status': newStatus});
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}
