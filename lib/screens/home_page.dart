import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product_cart.dart';
import 'profile_page.dart';
import 'order_page.dart';
import 'setting_page.dart';
import 'logout_page.dart';
import 'painkillers_page.dart';
import 'antibiotics_page.dart';
import 'vitamins_page.dart';
import 'cough_syrups_page.dart';
import 'condoms_page.dart';
import 'lubricants_page.dart';
import 'supplements_page.dart';
import 'health_kits_page.dart';
import 'protein_powders_page.dart';
import 'multivitamins_page.dart';
import 'omega3_page.dart';
import 'herbal_supplements_page.dart';
import 'common_medicines_page.dart';
import 'sexual_wellness_page.dart';
import 'health_supplements_page.dart';
import 'favourite_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> favoriteItems = [];

  void updateCartItems(List<Map<String, dynamic>> newCartItems) {
    setState(() {
      cartItems = newCartItems;
    });
  }

  void updateFavoriteItems(List<Map<String, dynamic>> newFavoriteItems) {
    setState(() {
      favoriteItems = newFavoriteItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_placeholder.jpeg'),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search for medicines...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductCartPage(cartItems: cartItems)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage(favoriteItems: favoriteItems)),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile_placeholder.jpeg'),
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogoutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          return ListView(
            children: [
              _buildBannerSection(),
              _buildVendorSection(context),
              _buildCategorySection("Common Medicines", [
                "Painkillers",
                "Antibiotics",
                "Vitamins",
                "Cough Syrups",
              ], isMobile, context),
              _buildCategorySection("Sexual Wellness", [
                "Condoms",
                "Lubricants",
                "Supplements",
                "Health Kits",
              ], isMobile, context),
              _buildCategorySection("Health Supplements", [
                "Protein Powders",
                "Multivitamins",
                "Omega-3",
                "Herbal Supplements",
              ], isMobile, context),
              _buildFooter(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "Special Offers & Coupons!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildVendorSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              "Are you a Pharmacy?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PharmacyJoinPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Join Us"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<String> items, bool isMobile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: isMobile ? 120 : 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      if (title == "Common Medicines") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommonMedicinesPage()),
                        );
                      } else if (title == "Sexual Wellness") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SexualWellnessPage()),
                        );
                      } else if (title == "Health Supplements") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HealthSupplementsPage()),
                        );
                      }
                    },
                    child: Container(
                      width: isMobile ? 100 : 150,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "See More",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    if (items[index] == "Painkillers") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PainkillersPage(
                            updateCartItems: updateCartItems,
                            updateFavoriteItems: updateFavoriteItems,
                            initialCartItems: cartItems,
                            initialFavoriteItems: favoriteItems,
                          ),
                        ),
                      );
                    } else if (items[index] == "Antibiotics") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AntibioticsPage()),
                      );
                    } else if (items[index] == "Vitamins") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VitaminsPage()),
                      );
                    } else if (items[index] == "Cough Syrups") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CoughSyrupsPage()),
                      );
                    } else if (items[index] == "Condoms") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CondomsPage()),
                      );
                    } else if (items[index] == "Lubricants") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LubricantsPage()),
                      );
                    } else if (items[index] == "Supplements") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SupplementsPage()),
                      );
                    } else if (items[index] == "Health Kits") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HealthKitsPage()),
                      );
                    } else if (items[index] == "Protein Powders") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProteinPowdersPage()),
                      );
                    } else if (items[index] == "Multivitamins") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MultivitaminsPage()),
                      );
                    } else if (items[index] == "Omega-3") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Omega3Page()),
                      );
                    } else if (items[index] == "Herbal Supplements") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HerbalSupplementsPage()),
                      );
                    }
                  },
                  child: Container(
                    width: isMobile ? 100 : 150,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        items[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.blue[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Important Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "We are committed to providing you with the best healthcare experience. "
                "For any queries, contact us at support@medicineapp.com.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
          Text(
            "© 2023 Medicine App. All rights reserved.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class PharmacyJoinPage extends StatefulWidget {
  @override
  _PharmacyJoinPageState createState() => _PharmacyJoinPageState();
}

class _PharmacyJoinPageState extends State<PharmacyJoinPage> {
  final TextEditingController pharmacyNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isButtonDisabled = true;

  String? _nameError;
  String? _phoneError;
  String? _emailError;

  void _submitForm(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Thank you for contacting us! We will get back to you soon."),
        duration: Duration(seconds: 3),
      ),
    );

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _validateForm() {
    String name = pharmacyNameController.text.trim();
    String phone = contactNumberController.text.trim();
    String email = emailController.text.trim();

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      _nameError = "No numbers or special characters allowed";
    } else {
      _nameError = null;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _phoneError = "Enter a valid 10-digit number";
    } else {
      _phoneError = null;
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      _emailError = "Enter a valid email address (e.g., example@gmail.com)";
    } else {
      _emailError = null;
    }

    setState(() {
      _isButtonDisabled = _nameError != null || _phoneError != null || _emailError != null;
    });
  }

  @override
  void initState() {
    super.initState();
    _validateForm();
    pharmacyNameController.addListener(_validateForm);
    contactNumberController.addListener(_validateForm);
    emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    pharmacyNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Join Us"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join Us",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: pharmacyNameController,
                        decoration: InputDecoration(
                          labelText: "Pharmacy Name",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.business, color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorText: _nameError,
                          errorStyle: TextStyle(color: Colors.black),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: contactNumberController,
                        decoration: InputDecoration(
                          labelText: "Contact Number",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.phone, color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorText: _phoneError,
                          errorStyle: TextStyle(color: Colors.black),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorText: _emailError,
                          errorStyle: TextStyle(color: Colors.black),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _isButtonDisabled ? null : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}