import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: ManageGroupPage(
      email: 'user@example.com', // Replace with actual email
      groupName: 'Example Group', // Replace with actual group name
      groupDescription: 'Description of Example Group', // Replace with actual description
    ),
  ));
}

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
  List<String> _currentFriends = [];
  List<String> _selectedFriendsForRemoval = [];
  bool _isAddButtonEnabled = false;
  bool _isRemoveButtonEnabled = false;

  // HTTP client for API requests
  final http.Client _client = http.Client();

  @override
  void dispose() {
    _client.close(); // Close the HTTP client when disposing the state
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchFriendNames();
    _fetchCurrentFriends();
  }

  Future<void> _fetchFriendNames() async {
    if (!mounted) return; // Check if the widget is still mounted before proceeding

    setState(() {
      _isLoading = true;
    });

    final apiUrl =
        'https://splitwise1.000webhostapp.com/managed_group/add_friend.php';
    try {
      final response = await _client.post(Uri.parse(apiUrl), body: {
        'group_name': widget.groupName,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data is List) {
          List<String> names =
              data.map((dynamic e) => e.toString()).toList();
          if (mounted) {
            setState(() {
              _friendNames = names;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _friendNames = []; // Clear previous data if any
            });
            _showSnackBar('No friends found for this group.', Colors.red);
          }
        }
      } else if (response.statusCode == 404) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _friendNames = []; // Clear previous data if any
          });
          _showSnackBar('No friends found for this group.', Colors.red);
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _friendNames = []; // Clear previous data if any
          });
          _showSnackBar(
              'Failed to fetch friend names. Error ${response.statusCode}',
              Colors.red);
        }
      }
    } catch (e) {
      print('Error fetching friend names: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _friendNames = []; // Clear previous data if any
        });
        _showSnackBar('Failed to fetch friend names. Error: $e', Colors.red);
      }
    }
  }

  Future<void> _fetchCurrentFriends() async {
    if (!mounted) return; // Check if the widget is still mounted before proceeding

    setState(() {
      _isLoading = true;
    });

    final apiUrl = 'https://splitwise1.000webhostapp.com/managed_group/show_friend_for_remove.php';
    try {
      final response = await _client.post(Uri.parse(apiUrl), body: {
        'group_name': widget.groupName,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data is List) {
          List<String> names = data.map((dynamic e) => e.toString()).toList();
          if (mounted) {
            setState(() {
              _currentFriends = names;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _currentFriends = []; // Clear previous data if any
            });
            _showSnackBar('No friends found for this group.', Colors.red);
          }
        }
      } else if (response.statusCode == 404) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _currentFriends = []; // Clear previous data if any
          });
          _showSnackBar('No friends found for this group.', Colors.red);
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _currentFriends = []; // Clear previous data if any
          });
          _showSnackBar(
              'Failed to fetch current friends. Error ${response.statusCode}',
              Colors.red);
        }
      }
    } catch (e) {
      print('Error fetching current friends: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentFriends = []; // Clear previous data if any
        });
        _showSnackBar(
            'Failed to fetch current friends. Error: $e', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
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
      _isAddButtonEnabled = _selectedFriends.isNotEmpty;
    });
  }

  void _toggleRemovalSelection(String friendName) {
    setState(() {
      if (_selectedFriendsForRemoval.contains(friendName)) {
        _selectedFriendsForRemoval.remove(friendName);
      } else {
        _selectedFriendsForRemoval.add(friendName);
      }
      _isRemoveButtonEnabled = _selectedFriendsForRemoval.isNotEmpty;
    });
  }

  void _addFriends() async {
    if (!mounted) return; // Check if the widget is still mounted before proceeding

    setState(() {
      _isLoading = true;
    });

    final apiUrl =
        'https://splitwise1.000webhostapp.com/managed_group/insert_friend.php';
    try {
      final response = await _client.post(Uri.parse(apiUrl), body: {
        'group_name': widget.groupName,
        'friends': json.encode(_selectedFriends), // Encode selected friends list to JSON
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackBar('Friends added successfully!', Colors.green);
          // Clear selection and any other state updates as needed
          setState(() {
            _selectedFriends.clear();
            _isAddButtonEnabled = false; // Disable button after successful addition
          });
          _fetchFriendNames(); // Refresh the list of friends
          _fetchCurrentFriends(); // Refresh the list of current friends
        }
      } else {
        if (mounted) {
          _showSnackBar('Failed to add friends. Error ${response.statusCode}', Colors.red);
        }
      }
    } catch (e) {
      print('Error adding friends: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to add friends. Error: $e', Colors.red);
      }
    }
  }

  void _removeFriends() async {
    if (!mounted) return; // Check if the widget is still mounted before proceeding

    setState(() {
      _isLoading = true;
    });

    final apiUrl =
        'https://splitwise1.000webhostapp.com/managed_group/remove_friend.php';
    try {
      final response = await _client.post(Uri.parse(apiUrl), body: {
        'group_name': widget.groupName,
        'friends': json.encode(_selectedFriendsForRemoval), // Encode selected friends list to JSON
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackBar('Friends removed successfully!', Colors.green);
          // Clear selection and any other state updates as needed
          setState(() {
            _selectedFriendsForRemoval.clear();
            _isRemoveButtonEnabled = false; // Disable button after successful removal
          });
          _fetchFriendNames(); // Refresh the list of friends
          _fetchCurrentFriends(); // Refresh the list of current friends
        }
      } else {
        if (mounted) {
          _showSnackBar('Failed to remove friends. Error ${response.statusCode}', Colors.red);
        }
      }
    } catch (e) {
      print('Error removing friends: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to remove friends. Error: $e', Colors.red);
      }
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
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Add in Circle'),
                        Tab(text: 'Split Money'),
                        Tab(text: 'Remove from Circle'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : _buildAddFriendsContent(),
                          Center(child: Text('Split Money Content')), // Placeholder for Split Money tab
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : _buildRemoveFriendsContent(),
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
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

Widget? _buildFloatingActionButton() {
  if (_isAddButtonEnabled ?? false) {
    return FloatingActionButton(
      onPressed: _addFriends,
      tooltip: 'Add Friend!',
      child: Icon(Icons.add),
    );
  } else if (_isRemoveButtonEnabled ?? false) {
    return FloatingActionButton(
      onPressed: _removeFriends,
      tooltip: 'Remove Friend!',
      child: Icon(Icons.remove),
    );
  } else {
    return null;
  }
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

  Widget _buildRemoveFriendsContent() {
    return ListView.builder(
      itemCount: _currentFriends.length,
      itemBuilder: (context, index) {
        final friendName = _currentFriends[index];
        return CheckboxListTile(
          title: Text(friendName),
          value: _selectedFriendsForRemoval.contains(friendName),
          onChanged: (bool? selected) {
            _toggleRemovalSelection(friendName);
          },
        );
      },
    );
  }
}
