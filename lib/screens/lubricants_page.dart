import 'package:flutter/material.dart';
import 'product_cart.dart'; // Import the ProductCartPage
import 'home_page.dart'; // Import the HomePage for navigation
import 'favourite_page.dart'; // Import the FavoritesPage

class LubricantsPage extends StatefulWidget {
  @override
  _LubricantsPageState createState() => _LubricantsPageState();
}

class _LubricantsPageState extends State<LubricantsPage> {
  // List of lubricants with name, price, and image
  final List<Map<String, dynamic>> products = [
    {
      "name": "Durex Play Massage",
      "price": 250,
      "image": "assets/images/durex_play_massage.jpg",
      "isFavorite": false,
    },
    {
      "name": "Durex Play Tingling",
      "price": 280,
      "image": "assets/images/durex_play_tingling.jpg",
      "isFavorite": false,
    },
    {
      "name": "Durex Play Warming",
      "price": 300,
      "image": "assets/images/durex_play_warming.webp",
      "isFavorite": false,
    },
    {
      "name": "KamaSutra Water Based",
      "price": 220,
      "image": "assets/images/kamasutra_water_based.webp",
      "isFavorite": false,
    },
    {
      "name": "KamaSutra Strawberry",
      "price": 240,
      "image": "assets/images/kamasutra_strawberry.jpg",
      "isFavorite": false,
    },
    {
      "name": "KamaSutra Chocolate",
      "price": 240,
      "image": "assets/images/kamasutra_chocolate.webp",
      "isFavorite": false,
    },
    {
      "name": "KY Jelly",
      "price": 200,
      "image": "assets/images/ky_jelly.jpg",
      "isFavorite": false,
    },
    {
      "name": "ID Glide",
      "price": 260,
      "image": "assets/images/id_glide.jpeg",
      "isFavorite": false,
    },
  ];

  List<Map<String, dynamic>> cartItems = []; // List to store cart items
  List<Map<String, dynamic>> favoriteItems = []; // List to store favorite items

  // Function to add a product to the cart
  void _addToCart(Map<String, dynamic> product, BuildContext context) {
    setState(() {
      // Check if the product is already in the cart
      bool found = false;
      for (var item in cartItems) {
        if (item["name"] == product["name"]) {
          item["quantity"] = (item["quantity"] ?? 0) + 1; // Increase quantity if already in cart
          found = true;
          break;
        }
      }
      if (!found) {
        // Add new product to cart
        cartItems.add({...product, "quantity": 1});
      }
    });

    // Show a SnackBar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product['name']} added to cart"),
      ),
    );
  }

  // Function to toggle favorite status
  void _toggleFavorite(int index) {
    setState(() {
      products[index]['isFavorite'] = !products[index]['isFavorite'];
      if (products[index]['isFavorite']) {
        favoriteItems.add(products[index]);
      } else {
        favoriteItems.removeWhere((item) => item['name'] == products[index]['name']);
      }
    });

    // Show a SnackBar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          products[index]['isFavorite']
              ? "${products[index]['name']} added to favorites"
              : "${products[index]['name']} removed from favorites",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search for medicines...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductCartPage(cartItems: cartItems),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(favoriteItems: favoriteItems),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset(
                      product['image'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Rs. ${product['price']}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _addToCart(product, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        child: Text("Add to Cart"),
                      ),
                      IconButton(
                        icon: Icon(
                          product['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                          color: product['isFavorite'] ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(index),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}