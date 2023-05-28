import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String name = "";
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    getDarkModeStatusFromSharedPreferences();
  }

  Future<void> toggleDarkMode(BuildContext context) async {
    setState(() {
      _isDarkMode = !_isDarkMode; // Update the dark mode status
    });

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', themeProvider.isDarkMode);
  }

  void getDarkModeStatusFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a63e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),


    body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                NetworkImage(
                    "https://cdn1.iconfinder.com/data/icons/feather-2/24/message-circle-512.png"),
                size: 60,
                color: Color(0xffd81706),
              ),
              SizedBox(height: 30),
              Text(
                "Contact Us",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: _isDarkMode ? Colors.white : Colors.grey[900],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Abdallah Halimi (19700280) \nFoad Farahbod (19701110) \nMedhat Haddad (19700568) \nYoussef Binni (18700233)",

                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _isDarkMode ? Colors.white : Colors.grey[900],
                ),
              ),
              SizedBox(height: 30),
              Text(
                " 19700280@emu.edu.tr \n 19701110@emu.edu.tr \n 19700568@emu.edu.tr \n 18700233@emu.edu.tr",
                style: TextStyle(
                  fontSize: 14,
                  color: _isDarkMode ? Colors.white : Colors.grey[900],
                ),
              ),
              SizedBox(height: 34),
              Text(
                "+90 5349932875 \n+90 5228627608",
                style: TextStyle(
                  fontSize: 14,
                  color: _isDarkMode ? Colors.white : Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
