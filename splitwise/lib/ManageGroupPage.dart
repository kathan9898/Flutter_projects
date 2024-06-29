import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageGroupPage extends StatefulWidget {
  final String email;
  final String groupName;
  final String groupDescription;

  ManageGroupPage({
    required this.email,
    required this.groupName,
    required this.groupDescription,
  });

  @override
  _ManageGroupPageState createState() => _ManageGroupPageState();
}

class _ManageGroupPageState extends State<ManageGroupPage> {
  bool _isLoading = false;
  List<String> _friendNames = [];
  List<String> _selectedFriends = [];
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchFriendNames();
  }

  Future<void> _fetchFriendNames() async {
    setState(() {
      _isLoading = true;
    });

    final apiUrl = 'https://splitwise1.000webhostapp.com/managed_group/add_friend.php';
    final response = await http.post(Uri.parse(apiUrl), body: {
      'group_name': widget.groupName,
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Convert List<dynamic> to List<String>
      List<String> names = data.map((dynamic e) => e.toString()).toList();

      setState(() {
        _friendNames = names;
        _isLoading = false;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        _isLoading = false;
        _friendNames = []; // Clear previous data if any
      });
      _showSnackBar('No friends found for this group.');
    } else {
      setState(() {
        _isLoading = false;
        _friendNames = []; // Clear previous data if any
      });
      _showSnackBar('Failed to fetch friend names. Error ${response.statusCode}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _toggleSelection(String friendName) {
    setState(() {
      if (_selectedFriends.contains(friendName)) {
        _selectedFriends.remove(friendName);
      } else {
        _selectedFriends.add(friendName);
      }
      _isButtonEnabled = _selectedFriends.isNotEmpty;
    });
  }

void _addFriends() async {
  setState(() {
    _isLoading = true;
  });

  final apiUrl = 'https://splitwise1.000webhostapp.com/managed_group/insert_friend.php';
  final response = await http.post(Uri.parse(apiUrl), body: {
    'group_name': widget.groupName,
    'friends': json.encode(_selectedFriends), // Encode selected friends list to JSON
  });

  setState(() {
    _isLoading = false;
  });

  if (response.statusCode == 200) {
    
    _showSnackBar('Friends added successfully!');
    // Clear selection and any other state updates as needed
    setState(() {
      _selectedFriends.clear();
      _isButtonEnabled = false; // Disable button after successful addition
    });
  } else {
    _showSnackBar('Failed to add friends. Error ${response.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group: ${widget.groupName}"), // Use groupName as the title
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/managed_group.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'User: ${widget.email}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.person, color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Add in Circle'),
                        Tab(text: 'Split Money'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : _buildAddFriendsContent(),
                          Center(child: Text('Split Money Content')), // Placeholder for Split Money tab
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isButtonEnabled
          ? FloatingActionButton(
              onPressed: _addFriends,
              tooltip: 'Add Friend!',
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildAddFriendsContent() {
    return ListView.builder(
      itemCount: _friendNames.length,
      itemBuilder: (context, index) {
        final friendName = _friendNames[index];
        return CheckboxListTile(
          title: Text(friendName),
          value: _selectedFriends.contains(friendName),
          onChanged: (bool? selected) {
            _toggleSelection(friendName);
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ManageGroupPage(
      email: 'user@example.com', // Replace with actual email
      groupName: 'Example Group', // Replace with actual group name
      groupDescription: 'Description of Example Group', // Replace with actual description
    ),
  ));
}
