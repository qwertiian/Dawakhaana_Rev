import 'package:flutter/material.dart';
import 'checkout_details.dart'; // Import the CheckoutDetailsPage

class ProductCartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  ProductCartPage({this.cartItems = const []});

  @override
  _ProductCartPageState createState() => _ProductCartPageState();
}

class _ProductCartPageState extends State<ProductCartPage> {
  void addToCart(Map<String, dynamic> product) {
    setState(() {
      // Check if the product is already in the cart
      bool found = false;
      for (var item in widget.cartItems) {
        if (item["name"] == product["name"]) {
          item["quantity"] += 1; // Increase quantity if already in cart
          found = true;
          break;
        }
      }
      if (!found) {
        // Add new product to cart
        widget.cartItems.add({...product, "quantity": 1});
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      if (widget.cartItems[index]["quantity"] > 1) {
        widget.cartItems[index]["quantity"] -= 1; // Decrease quantity
      } else {
        widget.cartItems.removeAt(index); // Remove item if quantity is 1
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cartItems.fold(0, (sum, item) => sum + (item["price"] * item["quantity"]));

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Your Cart",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item["image"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item["name"],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Quantity: ${item["quantity"]}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: Text(
                      "₹${(item["price"] * item["quantity"]).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: widget.cartItems.isEmpty
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutDetailsPage(cartItems: widget.cartItems)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Proceed to Checkout",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}