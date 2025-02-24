import 'dart:async';

import 'package:flutter/material.dart';
import 'sign_up.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start auto-slide every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Breakpoints for responsiveness
    final bool isLargeScreen = screenWidth > 600; // Adjust breakpoint as needed
    final double imageSize = isLargeScreen ? screenWidth * 0.3 : screenWidth * 0.8; // Reduced image size for large screens
    final double titleFontSize = isLargeScreen ? screenWidth * 0.02 : screenWidth * 0.06; // Reduced font size by 30%
    final double subtitleFontSize = isLargeScreen ? screenWidth * 0.015 : screenWidth * 0.04; // Reduced font size by 30%
    final double buttonFontSize = isLargeScreen ? screenWidth * 0.018 : screenWidth * 0.04; // Reduced font size by 30%
    final double buttonPaddingHorizontal = isLargeScreen ? screenWidth * 0.1 : screenWidth * 0.2;
    final double buttonPaddingVertical = isLargeScreen ? screenHeight * 0.015 : screenHeight * 0.015;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildSlide("assets/images/slide1.png", "📦 Bijli Se Bhi Tez Delivery!", "Dawaiyan ab sirf kuch minute door!", imageSize, titleFontSize, subtitleFontSize, isLargeScreen),
              _buildSlide("assets/images/slide2.png", "🏪 Bharosemand Dawaai, Sirf Verified Dukaan Se!", "Hum sirf sahi aur trusted pharmacy se dawaai late hain!", imageSize, titleFontSize, subtitleFontSize, isLargeScreen),
              _buildSlide("assets/images/slide3.png", "💰 Paise Ki Chinta Chhodo, Payment Aasaan Karo!", "UPI, Cash, Card – Jo pasand ho, wahi use karo!", imageSize, titleFontSize, subtitleFontSize, isLargeScreen),
              _buildSlide("assets/images/slide4.png", "📞 Din Ho Ya Raat, Hum Hamesha Aapke Saath!", "24/7 Madad milegi, bas ek call par!", imageSize, titleFontSize, subtitleFontSize, isLargeScreen),
              _buildSlide("assets/images/slide5.png", "💡 Swasth Raho, Mast Raho – Roz Naye Health Tips!", "Sehat ke liye chhoti-chhoti baatein jo zaroori hain.", imageSize, titleFontSize, subtitleFontSize, isLargeScreen),
            ],
          ),
          Positioned(
            bottom: isLargeScreen ? screenHeight * 0.2 : screenHeight * 0.15, // Adjust position for large screens
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPage = index;
                      _pageController.animateToPage(
                        _currentPage,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300), // Smooth animation
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8, // Highlight current slide
                    height: _currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.blue : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                );
              }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: isLargeScreen ? screenHeight * 0.1 : screenHeight * 0.05), // Adjust button position
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup'); // Navigate to sign-up page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonPaddingHorizontal, // Responsive padding
                    vertical: buttonPaddingVertical,
                  ),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                child: Text("Get Started"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(String imagePath, String title, String subtitle, double imageSize, double titleFontSize, double subtitleFontSize, bool isLargeScreen) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image with smooth animation and no border
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500), // Slide transition animation
              child: Container(
                key: ValueKey<String>(imagePath), // Unique key for animation
                width: imageSize, // Responsive image size
                height: imageSize, // Square aspect ratio
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                  borderRadius: BorderRadius.circular(20), // Rounded corners for a clean look
                ),
              ),
            ),
            SizedBox(height: isLargeScreen ? 20 : 40), // Adjusted spacing for large screens
            // Main Heading
            Text(
              title,
              textAlign: TextAlign.center, // Center-align the text
              style: TextStyle(
                fontSize: titleFontSize, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isLargeScreen ? 5 : 10), // Adjusted spacing for large screens
            // Subheading
            Text(
              subtitle,
              textAlign: TextAlign.center, // Center-align the text
              style: TextStyle(
                fontSize: subtitleFontSize, // Responsive font size
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}