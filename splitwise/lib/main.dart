import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart'; // Import the HomePage widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitwise',
      theme: ThemeData(
        brightness: Brightness.dark, // Apply dark theme
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'SplitWise',
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Card(
                    color: Colors.black.withOpacity(0.5),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              String email = emailController.text;
                              String phpFileUrl = "https://splitwise1.000webhostapp.com/login.php?email=$email";

                              http.get(Uri.parse(phpFileUrl)).then((response) {
                                if (response.statusCode == 200) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Enter Password'),
                                        content: TextField(
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.pink,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.pink,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              String password = passwordController.text;
                                              String verifyUrl = "https://splitwise1.000webhostapp.com/login_verify.php?email=$email&password=$password";

                                              http.get(Uri.parse(verifyUrl)).then((verifyResponse) {
                                                if (verifyResponse.statusCode == 200) {
                                                  Navigator.of(context).pop(); // Close the password dialog
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => HomePage(email: email), // Pass email to HomePage
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Password was incorrect or server not reachable'),
                                                      duration: Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                              }).catchError((error) {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error occurred while verifying password'),
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              });
                                            },
                                            child: Text('Verify'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (response.statusCode == 404) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(response.statusCode.toString() + ' User not found'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error occurred'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error occurred while verifying email'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              });
                            },
                            child: const Text('Verify Email'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
