import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
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
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            trailing: Switch(
              value: true, // Replace with actual notification preference
              onChanged: (value) {
                // Update notification preference
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              // Navigate to change password page
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: Text('English'), // Replace with actual language
            onTap: () {
              // Navigate to language selection page
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () {
              // Navigate to help & support page
            },
          ),
        ],
      ),
    );
  }
}