// Manages state and Firebase operations for grocery items
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class GroceryProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  // Adds a new grocery item to Firestore with image
  Future<void> addGroceryItem(
      String name, String quantity, String imagePath) async {
    try {
      // Convert image to base64 for storage
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';

      // Create document in Firestore with item details
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

  // Stream of grocery items ordered by timestamp
  Stream<QuerySnapshot> fetchGroceries() {
    return _firestore
        .collection('groceries')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Updates the status of a grocery item
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