import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Courrier extends StatefulWidget {
  @override
  _CourrierState createState() => _CourrierState();
}

class _CourrierState extends State<Courrier> {
  late TextEditingController textEditingController;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    getThemeMode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void saveApplication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');
    String? phoneNumber = prefs.getString('phone_number');

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('applications')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Duplicate Application'),
            content: Text('An application with this email already exists.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      FirebaseFirestore.instance.collection('applications').add({
        'email': email,
        'name': name,
        'phone_number': phoneNumber,
        'status': 'pending',
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Application Submitted'),
            content: Text('Your application has been submitted successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        backgroundColor: isDarkMode ? Colors.grey[700] : const Color(0xff3a57e8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : const Color(0xff212435),
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "Become a Courier",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: isDarkMode ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
              Text(
                "Tell us about yourself and why you want to become a rider:",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.grey[700],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: textEditingController,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: "Enter Text",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(height: 66),
              MaterialButton(
                onPressed: saveApplication,
                color: isDarkMode ? const Color(0xfff80707) : const Color(0xff3a57e8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  "APPLY NOW!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
