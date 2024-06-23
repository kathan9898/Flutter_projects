import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove elevation
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.white), // Adjust icon color
                SizedBox(width: 8),
                Text(
                  'User: $email',
                  style: TextStyle(color: Colors.white), // Adjust text color
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/home_page.jpg', // Adjust path as per your project structure
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Transparent Title Box
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black.withOpacity(0.4), // Adjust opacity as needed
              child: Center(
                child: Text(
                  'Welcome to SplitWise!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
          ),
          // Tabs Row
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.pink[200]?.withOpacity(0.8), // Conditional access
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TabItem(text: 'Group'), // Custom TabItem widget
                    TabItem(text: 'Make Group'), // Custom TabItem widget
                    TabItem(text: 'Manage Groups'), // Custom TabItem widget
                  ],
                ),
              ),
            ),
          ),
          // Main Content Area
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.40,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Content for Selected Tab',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Logged in as:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String text;

  const TabItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap on the tab
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(text),
      ),
    );
  }
}
