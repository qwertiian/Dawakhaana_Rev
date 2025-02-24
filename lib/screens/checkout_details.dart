import 'package:flutter/material.dart';
import 'final_payment.dart'; // Import the FinalPaymentPage
import 'product_cart.dart'; // Import the ProductCartPage

class CheckoutDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CheckoutDetailsPage({required this.cartItems});

  @override
  _CheckoutDetailsPageState createState() => _CheckoutDetailsPageState();
}

class _CheckoutDetailsPageState extends State<CheckoutDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_updateButtonState);
    _cityController.addListener(_updateButtonState);
    _stateController.addListener(_updateButtonState);
    _pincodeController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _addressController.text.isNotEmpty &&
          _cityController.text.isNotEmpty &&
          _stateController.text.isNotEmpty &&
          _pincodeController.text.isNotEmpty;
    });
  }

  String? _validateCityAndState(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return "Only alphabets are allowed";
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your pincode";
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return "Pincode must be exactly 6 digits";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cartItems.fold(0, (sum, item) => sum + (item["price"] * item["quantity"]));

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Checkout Details",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: "City",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: _validateCityAndState,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: "State",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: _validateCityAndState,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _pincodeController,
                        decoration: InputDecoration(
                          labelText: "Pincode",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validatePincode,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display order summary
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Order Summary",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];
                          return ListTile(
                            title: Text(item["name"]),
                            trailing: Text("₹${(item["price"] * item["quantity"]).toStringAsFixed(2)}"),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FinalPaymentPage(
                            cartItems: widget.cartItems,
                            address: _addressController.text,
                            city: _cityController.text,
                            state: _stateController.text,
                            pincode: _pincodeController.text,
                          )),
                    );
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Proceed to Payment",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
