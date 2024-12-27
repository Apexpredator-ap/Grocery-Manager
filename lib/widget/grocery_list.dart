// Widget for displaying the list of grocery items
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/grocery_provider.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GroceryProvider>(
      builder: (context, groceryProvider, _) {
        return StreamBuilder<QuerySnapshot>(
          stream: groceryProvider.fetchGroceries(),
          builder: (context, snapshot) {
            // Show loading indicator while data is being fetched
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Show empty state when no items exist
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_basket_outlined,
                        size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No grocery items found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final groceries = snapshot.data!.docs;

            // Build list of grocery items
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groceries.length,
              itemBuilder: (context, index) {
                final grocery = groceries[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Item image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: grocery['imageUrl'] != null
                              ? Image.memory(
                            base64Decode(
                                grocery['imageUrl'].split(',').last),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Item details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                grocery['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Quantity: ${grocery['quantity']}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Status: ${grocery['status']}',
                                style: TextStyle(
                                  color: grocery['status'] == 'Pending'
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Purchase status button
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline),
                          color: Colors.green,
                          onPressed: () {
                            groceryProvider.updateStatus(
                              groceries[index].id,
                              'Purchased',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
