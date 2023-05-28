import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
Future<bool> validateLogin(String email, String password) async {
  try {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      return false;
    } else {
      throw e;
    }
  }
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool emailValid = true;
  String name = '';
  String phone_number = '';
  String address = '';
  String role = '';


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        name = userData['name'];
        phone_number = userData['phone_number'];
        address = userData['address'];
        role = userData['role'];
      });
      print('User name: $name');
      print('phone_number: $phone_number');
      print('address: $address');
      print('role: $role');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      await prefs.setString('phone_number', phone_number);
      await prefs.setString('address', address);
      await prefs.setString('role', role);


      final savedName = prefs.getString('name');
      if (savedName != null) {
        print('Saved name: $savedName');
      } else {
        print('Name not found in SharedPreferences');
      }
      final savedPhone = prefs.getString('phone_number');
      if (savedPhone != null) {
        print('Saved phone: $savedPhone');
      } else {
        print('phone not found in SharedPreferences');
      }
      final savedAddress = prefs.getString('address');
      if (savedAddress != null) {
        print('Saved address: $savedAddress');
      } else {
        print('address not found in SharedPreferences');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: Image.asset(
                    "assets/login.png",
                    height: 200,
                    width: 10,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Login",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Color(0xff000000),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Email",
                    errorText: emailValid ? null : "Please enter a valid email",
                  ),
                  onChanged: (value) {
                    setState(() {
                      emailValid =
                          RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter Password",
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/reset');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xff3a57e8),
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text;
                    String password = passwordController.text;
                    if (emailValid) {
                      bool isValid = await validateLogin(email, password);

                      if (isValid) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final userData = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .get();
                          String userRole = userData['role'];
                          if (userRole == 'deactivated') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Your account is deactivated. Please contact support.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            await FirebaseAuth.instance.signOut();
                          } else {
                            _loadUserData();
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('email', email);
                            prefs.setBool('isLoggedIn', true);
                            Navigator.pushReplacementNamed(context, '/mainPage');
                          }
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid email or password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a valid email'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
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