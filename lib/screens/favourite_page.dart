import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems;

  FavoritesPage({required this.favoriteItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text('Favorites'),
      ),
      body: favoriteItems.isEmpty
          ? Center(
        child: Text(
          'No favorite products added yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final product = favoriteItems[index];
          return ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text(product['name']),
            subtitle: Text('Price: Rs. ${product['price']}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to product details page if needed
            },
          );
        },
      ),
    );
  }
}