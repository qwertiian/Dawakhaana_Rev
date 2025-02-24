import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FinalPaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String address;
  final String city;
  final String state;
  final String pincode;

  FinalPaymentPage({
    required this.cartItems,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
  });

  @override
  _FinalPaymentPageState createState() => _FinalPaymentPageState();
}

class _FinalPaymentPageState extends State<FinalPaymentPage> {
  late Razorpay _razorpay;
  String? _orderId;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Calculate total amount here
    totalAmount = widget.cartItems.fold(0, (sum, item) => sum + (item["price"] * item["quantity"] as num));

    _createOrder(); // Create order when the page initializes
  }

  Future<void> _createOrder() async {
    try {
      _orderId = await createOrder(totalAmount);
      setState(() {}); // Update state to reflect order ID
    } catch (e) {
      print("Error creating order: $e");
      _showErrorDialog("Failed to create order. Please try again.");
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print('Payment Success: ${response.paymentId}');
    print('Order ID: $_orderId'); // Print order ID
    _showPaymentSuccessDialog();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    print('Payment Error: ${response.code} - ${response.message}');
    _showPaymentErrorDialog();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print('External Wallet Selected: ${response.walletName}');
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Your payment has been successfully processed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Failed'),
        content: Text('Your payment failed. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String> createOrder(double amount) async {
    String keyId = 'rzp_test_Og5vcL9JiYlxQu';  // Replace with your Key ID
    String keySecret = 'twmLT9kYlesRJiXQmLF3l5'; // Replace with your Key Secret

    // Combine Key ID and Key Secret
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));

    final url = Uri.parse('https://api.razorpay.com/v1/orders');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': basicAuth,
    };

    final body = {
      'amount': (amount * 100).toInt(), // Convert to paise
      'currency': 'INR',
      'receipt': 'receipt_#${DateTime.now().millisecondsSinceEpoch}', // Generate unique receipt ID
      'payment_capture': 1,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Order Created: ${jsonData['id']}');
      return jsonData['id'];
    } else {
      print('Failed to create order: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to create order');
    }
  }

  void _openCheckout() async {
    if (_orderId == null) {
      print("Order ID is null. Cannot proceed.");
      _showErrorDialog("Failed to initiate payment due to missing order ID.");
      return;
    }

    var options = {
      'key': 'rzp_test_Og5vcL9JiYlxQu', // Replace with your Razorpay Key ID
      'amount': totalAmount * 100, // Convert to paise
      'name': 'Your App Name',
      'description': 'Payment for ${widget.cartItems.length} items',
      'order_id': _orderId, // Use the created order ID
      'prefill': {
        'contact': '', // User's contact number
        'email': '', // User's email
      },
      'external': {
        'wallets': ['paytm'], // Optional, for adding support for wallets
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay: $e");
      _showErrorDialog("An error occurred while opening the payment gateway.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Payment",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Payment Options in a Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Credit/Debit Card Option
                    _buildPaymentOption(
                      icon: Icons.credit_card,
                      title: "Credit/Debit Card",
                      onTap: () {
                        _openCheckout();
                      },
                    ),
                    Divider(height: 20, thickness: 1),
                    // Net Banking Option
                    _buildPaymentOption(
                      icon: Icons.account_balance,
                      title: "Net Banking",
                      onTap: () {
                        _openCheckout();
                      },
                    ),
                    Divider(height: 20, thickness: 1),
                    // UPI Option
                    _buildPaymentOption(
                      icon: Icons.payment,
                      title: "UPI",
                      onTap: () {
                        _openCheckout();
                      },
                    ),
                    Divider(height: 20, thickness: 1),
                    // Cash on Delivery Option
                    _buildPaymentOption(
                      icon: Icons.money,
                      title: "Cash on Delivery",
                      onTap: () {
                        // Handle cash on delivery
                        _showCashOnDeliveryDialog();
                      },
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
                    SizedBox(height: 8),
                    Text(
                      "Shipping Address: ${widget.address}, ${widget.city}, ${widget.state} - ${widget.pincode}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    if (_orderId != null)
                      Text(
                        "Order ID: $_orderId",
                        style: TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a payment option
  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Icon(icon, size: 28, color: Colors.blue),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  void _showCashOnDeliveryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cash on Delivery'),
        content: Text('Your order will be processed for cash on delivery.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}