import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/login_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool emailValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6e6e6),
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
                    //fit: BoxFit.cover,
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
                  child: TextButton(
                    onPressed: () {},
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
                          Navigator.pushReplacementNamed(context, '/');
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            errorMessage = e.message!;
                          });
                        }
                      } else {
                        setState(() {
                          errorMessage = 'Invalid email or password';
                        });
                      }
                    } else {
                      setState(() {
                        errorMessage = 'Please enter a valid email';
                      });
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
