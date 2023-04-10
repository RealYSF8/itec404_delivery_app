import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatefulWidget {
  final FirebaseFirestore firestore;

  const Account({Key? key, required this.firestore}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<String?> _getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<String?> _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('address');
  }

  Future<String?> _getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone_number');
  }

  Future<String?> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  @override
  void initState() {
    super.initState();
    _getName().then((value) => _nameController.text = value ?? '');
    _getPhoneNumber().then((value) => _phoneController.text = value ?? '');
    _getAddress().then((value) => _addressController.text = value ?? '');
    _getEmail().then((value) => _emailController.text = value ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'My Account',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', _nameController.text);
          await prefs.setString('phone_number', _phoneController.text);
          await prefs.setString('address', _addressController.text);
          await prefs.setString('email', _emailController.text);

          final user = FirebaseAuth.instance.currentUser;
          final userId = user?.uid;
          if (userId != null) {
            await widget.firestore.collection('users').doc(userId).set({
              'name': _nameController.text,
              'phone_number': _phoneController.text,
              'address': _addressController.text,
              'email': _emailController.text,
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Edited successfully!'),
            ),
          );

          Navigator.popAndPushNamed(context, '/more');
        },
        child: const Icon(Icons.edit),
        backgroundColor: Colors.grey[800],
      ),

      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(10),
    child: FutureBuilder<String?>(
    future: _getEmail(),
    builder: (context, emailSnapshot) {
    if (emailSnapshot.hasData) {
    final email = emailSnapshot.data;

    return Column(
    children: [
    CircleAvatar(
    backgroundImage: const AssetImage('assets/ninja.png'),
    radius: 40.0,
    ),
    const SizedBox(height: 40),
    buildTextField(
    Icons.email,
    'Email/Username',
    _emailController.text,
    controller: _emailController,
    enabled: false,
    ),
    buildTextField(
    Icons.person_outline_rounded,
      'Name',
      _nameController.text,
      controller: _nameController,
    ),
      buildTextField(
        Icons.phone,
        'Phone number',
        _phoneController.text,
        controller: _phoneController,
      ),
      buildTextField(
        Icons.location_on,
        'Address',
        _addressController.text,
        controller: _addressController,
      ),
    ],
    );
    } else if (emailSnapshot.hasError) {
      return const Center(child: Text('Error loading data'));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
    },
    ),
        ),
        ),
    );
  }

  Widget buildTextField(
      IconData icon,
      String labelText,
      String initialValue, {
        bool enabled = true,
        TextEditingController? controller,
      }) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (value) {
          setState(() {});
        },
        enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: Colors.grey,
          hintText: labelText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'verdana_regular',
            fontWeight: FontWeight.w400,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontFamily: 'verdana_regular',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}