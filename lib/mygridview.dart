import 'package:flutter/material.dart';

class GridViewExample extends StatelessWidget {
  final List<String> items = List.generate(5, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GridView with Extra Item")),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.9,
        ),
        itemCount: items.length + 1, // +1 for the extra fixed item
        itemBuilder: (context, index) {
          if (index == 0) {
            // Handle the extra fixed item
            return Card(
              color: Colors.blue,
              child: Center(
                child: Text(
                  "Fixed Item",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          }

          // Handle the remaining items
          // Adjust the index for the original list
          return Card(
            color: Colors.amber,
            child: Center(
              child: Text(
                "dfasd",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: GridViewExample()));
}
