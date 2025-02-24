import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
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
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with actual number of orders
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Order #${index + 1}'),
            subtitle: Text('Delivered on 10/10/2023'), // Replace with actual date
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to order details page
            },
          );
        },
      ),
    );
  }
}