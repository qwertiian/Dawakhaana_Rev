import 'package:flutter/material.dart';
import 'home_page.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  Set<String> healthIssues = {};
  Set<String> medicalConditions = {};
  String? medicinePreference;
  bool wantsReminders = false;
  String? ageGroup;
  TextEditingController otherHealthIssuesController = TextEditingController();
  TextEditingController otherMedicalConditionsController = TextEditingController();

  @override
  void dispose() {
    otherHealthIssuesController.dispose();
    otherMedicalConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Health Survey",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              _buildQuestion(
                "What health issues do you frequently face?",
                [
                  "Cold & Flu",
                  "Headache & Body Pain",
                  "Digestion Issues",
                  "Skin Problems",
                  "Allergy & Asthma",
                  "General Weakness",
                ],
                healthIssues,
                otherController: otherHealthIssuesController,
                otherOptionLabel: "Other",
              ),
              SizedBox(height: 20),
              _buildQuestion(
                "Do you have any ongoing medical conditions? (Optional)",
                [
                  "Diabetes",
                  "Hypertension (High BP)",
                  "Heart-related issues",
                  "None",
                ],
                medicalConditions,
                otherController: otherMedicalConditionsController,
                otherOptionLabel: "Other",
              ),
              SizedBox(height: 20),
              _buildRadioQuestion(
                "Do you prefer Ayurvedic, Homeopathic, or Allopathic medicines?",
                ["Ayurvedic", "Homeopathic", "Allopathic", "No Preference"],
                medicinePreference,
                    (value) {
                  setState(() {
                    medicinePreference = value;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildSwitchQuestion(
                "Would you like reminders for medicine refills and health tips?",
                wantsReminders,
                    (value) {
                  setState(() {
                    wantsReminders = value;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildRadioQuestion(
                "What age group do you belong to?",
                ["Below 18", "18-30", "31-50", "51+"],
                ageGroup,
                    (value) {
                  setState(() {
                    ageGroup = value;
                  });
                },
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text("Finish & Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(
      String question,
      List<String> options,
      Set<String> selectedOptions, {
        TextEditingController? otherController,
        String? otherOptionLabel,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        ...options.map((option) {
          return CheckboxListTile(
            title: Text(option),
            value: selectedOptions.contains(option),
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  selectedOptions.add(option);
                } else {
                  selectedOptions.remove(option);
                }
              });
            },
          );
        }).toList(),
        if (otherOptionLabel != null && otherController != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: otherController,
              decoration: InputDecoration(
                labelText: otherOptionLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRadioQuestion(
      String question,
      List<String> options,
      String? selectedValue,
      Function(String?) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedValue,
            onChanged: onChanged,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSwitchQuestion(
      String question,
      bool value,
      Function(bool) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        SwitchListTile(
          title: Text(value ? "Yes" : "No"),
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}