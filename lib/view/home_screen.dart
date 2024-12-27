import 'package:flutter/material.dart';
import 'add_grocery_dialogue.dart';
import '../widget/grocery_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Grocery Manager',
          style: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // Main content showing list of groceries
      body: const GroceryList(),
      // FAB to add new items
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
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
