
import 'package:flutter/material.dart';
import 'product_cart.dart';
import 'home_page.dart';
import 'favourite_page.dart';

class PainkillersPage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) updateCartItems;
  final Function(List<Map<String, dynamic>>) updateFavoriteItems;
  final List<Map<String, dynamic>> initialCartItems;
  final List<Map<String, dynamic>> initialFavoriteItems;

  PainkillersPage({
    required this.updateCartItems,
    required this.updateFavoriteItems,
    required this.initialCartItems,
    required this.initialFavoriteItems,
  });

  @override
  _PainkillersPageState createState() => _PainkillersPageState();
}

class _PainkillersPageState extends State<PainkillersPage> {
  late List<Map<String, dynamic>> cartItems;
  late List<Map<String, dynamic>> favoriteItems;

  final List<Map<String, dynamic>> products = [
    {
      "name": "Paracetamol 500mg",
      "price": 20,
      "image": "assets/images/paracetamol.jpg",
      "isFavorite": false,
    },
    {
      "name": "Ibuprofen 400mg",
      "price": 30,
      "image": "assets/images/ibuprofen.webp",
      "isFavorite": false,
    },
    {
      "name": "Dolo 650mg",
      "price": 25,
      "image": "assets/images/dolo.webp",
      "isFavorite": false,
    },
    {
      "name": "Combiflam",
      "price": 40,
      "image": "assets/images/combiflam.jpg",
      "isFavorite": false,
    },
    {
      "name": "Aspirin 75mg",
      "price": 15,
      "image": "assets/images/aspirin.webp",
      "isFavorite": false,
    },
    {
      "name": "Naproxen 250mg",
      "price": 50,
      "image": "assets/images/naproxen.jpeg",
      "isFavorite": false,
    },
    {
      "name": "Voveran 50mg",
      "price": 35,
      "image": "assets/images/voveran.jpg",
      "isFavorite": false,
    },
    {
      "name": "Crocin Advance",
      "price": 30,
      "image": "assets/images/crocin.jpg",
      "isFavorite": false,
    },
    {
      "name": "Disprin Tablet",
      "price": 10,
      "image": "assets/images/disprin.webp",
      "isFavorite": false,
    },
    {
      "name": "Flexon MR",
      "price": 45,
      "image": "assets/images/flexon.jpeg",
      "isFavorite": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.initialCartItems);
    favoriteItems = List.from(widget.initialFavoriteItems);
    _updateProductFavorites();
  }

  void _updateProductFavorites() {
    for (var product in products) {
      product['isFavorite'] = favoriteItems.any((item) => item['name'] == product['name']);
    }
  }

  void _addToCart(Map<String, dynamic> product, BuildContext context) {
    setState(() {
      bool found = false;
      for (var item in cartItems) {
        if (item["name"] == product["name"]) {
          item["quantity"] = (item["quantity"] ?? 0) + 1;
          found = true;
          break;
        }
      }
      if (!found) {
        cartItems.add({...product, "quantity": 1});
      }
    });
    widget.updateCartItems(cartItems);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product['name']} added to cart"),
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      products[index]['isFavorite'] = !products[index]['isFavorite'];
      if (products[index]['isFavorite']) {
        favoriteItems.add(products[index]);
      } else {
        favoriteItems.removeWhere((item) => item['name'] == products[index]['name']);
      }
    });
    widget.updateFavoriteItems(favoriteItems);

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
        title: TextField(
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
