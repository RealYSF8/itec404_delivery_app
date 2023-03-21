import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/register_validator.dart'; // import register_validator file

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                "https://cdn1.iconfinder.com/data/icons/borrow-book-flat/340/device_tablet_register_login_member_user-256.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                "Let's Get Started!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Create an account and get started.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                validator: (value) => validateName(value),
                decoration: InputDecoration(
                  hintText: "Name",
                  prefixIcon: Icon(Icons.person, color: Colors.black, size: 24),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                validator: (value) => validateEmail(value),
                decoration: InputDecoration(
                  hintText: "Email Address",
                  prefixIcon: Icon(Icons.mail, color: Colors.black, size: 24),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                validator: (value) => validatePassword(value),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon:
                      Icon(Icons.visibility, color: Colors.black, size: 24),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                validator: (value) =>
                    validateConfirmPassword(value, _passwordController.text),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon:
                      Icon(Icons.visibility, color: Colors.black, size: 24),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                validator: (value) => validateAddress(value),
                decoration: InputDecoration(
                  hintText: "House Address",
                  prefixIcon: Icon(Icons.home, color: Colors.black, size: 24),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                validator: (value) => validatePhoneNumber(value),
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(Icons.call, color: Colors.black, size: 24),
                ),
              ),
              SizedBox(height: 16),
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
// call register function from register_validator file
                    register(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                      _addressController.text,
                      _phoneNumberController.text,
                    );
// navigate to home screen
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                color: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blueAccent, width: 1),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Colors.white,
                height: 40,
                minWidth: 140,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
