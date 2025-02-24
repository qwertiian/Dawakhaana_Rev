import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'survey_page.dart'; // Ensure this import is correct for your project

class LocationPage extends StatelessWidget {
  final bool isLoginFlow;

  const LocationPage({Key? key, this.isLoginFlow = false}) : super(key: key);

  Future<void> _getLocation(BuildContext context) async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt the user to enable location services
      bool enableService = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to use this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Enable'),
            ),
          ],
        ),
      );

      if (enableService == true) {
        // Open location settings
        await Geolocator.openLocationSettings();
        return;
      } else {
        // User canceled, do nothing
        return;
      }
    }

    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied. Please enable them in app settings.')),
      );
      // Open app settings to allow the user to enable permissions manually
      await Geolocator.openAppSettings();
      return;
    }

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition();
      print("Location: ${position.latitude}, ${position.longitude}");

      // Navigate to the next screen
      Navigator.pushReplacementNamed(context, isLoginFlow ? '/home' : '/survey');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Location Access",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "We need your location to provide better service.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _getLocation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Allow Location Access",
                    style: TextStyle(color: Colors.blue),
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