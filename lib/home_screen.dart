import 'package:flutter/material.dart';
import 'add_grocery_dialogue.dart';
import 'grocery_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Grocery Manager',
          style: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 25,
            fontWeight: FontWeight.bold, // Corrected FontWeight
          ),
        ),
        centerTitle: true,
      ),
      body: const GroceryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddGroceryDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
