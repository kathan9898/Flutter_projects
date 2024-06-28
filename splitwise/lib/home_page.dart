import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Focus nodes for text fields
  final FocusNode _groupNameFocus = FocusNode();
  final FocusNode _groupDescriptionFocus = FocusNode();

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _submitGroup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String apiUrl = 'https://splitwise1.000webhostapp.com/make_group/make_group.php';
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': widget.email,
          'group_name': _groupNameController.text,
          'group_description': _groupDescriptionController.text,
        },
      );

      if (response.statusCode == 200) {
        // Clear text fields
        _groupNameController.clear();
        _groupDescriptionController.clear();

        // Remove focus from text fields
        _groupNameFocus.unfocus();
        _groupDescriptionFocus.unfocus();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Circle is created.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error while creating circle, please try again'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose focus nodes when the widget is disposed
    _groupNameFocus.dispose();
    _groupDescriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'User: ${widget.email}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/home_page.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Text(
                  'Welcome to SplitWise!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black?.withOpacity(0.5),
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TabItem(text: 'Group', index: 0, onTap: _onTabSelected),
                    TabItem(text: 'Make Group', index: 1, onTap: _onTabSelected),
                    TabItem(text: 'Manage Groups', index: 2, onTap: _onTabSelected),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.40,
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 1:
        return _buildMakeGroupContent();
      default:
        return Center(
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
                widget.email,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildMakeGroupContent() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Card(
        color: Colors.white.withOpacity(0.8),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Initiate Your Circle',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                TextFormField(
                  controller: _groupNameController,
                  focusNode: _groupNameFocus,
                  decoration: InputDecoration(
                    labelText: 'Enter Circle Name',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.red), // Error text color
                  ),
                  style: TextStyle(color: Colors.black), // Regular text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a circle name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _groupDescriptionController,
                  focusNode: _groupDescriptionFocus,
                  decoration: InputDecoration(
                    labelText: 'Enter Circle Description',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.red), // Error text color
                  ),
                  style: TextStyle(color: Colors.black), // Regular text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a circle description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitGroup,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

}

class TabItem extends StatelessWidget {
  final String text;
  final int index;
  final ValueChanged<int> onTap;

  const TabItem({Key? key, required this.text, required this.index, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
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
