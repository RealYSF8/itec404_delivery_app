import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account> {
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
        onPressed: () => setState(() {}),
        child: const Icon(Icons.edit),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<String?>(
          future: _getEmail(),
          builder: (context, emailSnapshot) {
            return FutureBuilder<String?>(
              future: _getName(),
              builder: (context, nameSnapshot) {
                return FutureBuilder<String?>(
                  future: _getAddress(),
                  builder: (context, addressSnapshot) {
                    return FutureBuilder<String?>(
                      future: _getPhoneNumber(),
                      builder: (context, phoneSnapshot) {
                        if (nameSnapshot.hasData &&
                            addressSnapshot.hasData &&
                            phoneSnapshot.hasData &&
                            emailSnapshot.hasData) {
                          final name = nameSnapshot.data;
                          final address = addressSnapshot.data;
                          final phone = phoneSnapshot.data;
                          final email = emailSnapshot.data;

                          return Column(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    const AssetImage('assets/ninja.png'),
                                radius: 40.0,
                              ),
                              const SizedBox(height: 40),
                              buildTextField(
                                  Icons.email, 'Email/Username', email ?? '', enabled: false,),
                              buildTextField(Icons.person_outline_rounded,
                                  'Name', name ?? ''),
                              buildTextField(
                                  Icons.phone, 'Phone number', phone ?? ''),
                              buildTextField(
                                  Icons.location_on, 'Address', address ?? ''),
                            ],
                          );
                        } else if (nameSnapshot.hasError ||
                            addressSnapshot.hasError ||
                            phoneSnapshot.hasError ||
                            emailSnapshot.hasError) {
                          return const Center(
                              child: Text('Error loading data'));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String labelText, String initialValue,
      {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: TextFormField(
        initialValue: initialValue,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (value) {
          setState(() {
            // userInput.text = value.toString();
          });
        },
        enabled: enabled, // add enabled property
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
