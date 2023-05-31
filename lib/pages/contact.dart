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


      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Text(
                  "Contact Us",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 24,
                    color: Color(0xff3a57e8),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: 400,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  shape: BoxShape.rectangle,
                  borderRadius:
                  BorderRadius.only(topRight: Radius.circular(140.0)),
                  border: Border.all(color: Color(0xff3a57e8), width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.call,
                            color: Color(0xff3a57e8),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              "+90 5228627608",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.mail,
                              color: Color(0xff3a57e8),
                              size: 24,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                "swiftdelivery@gmail.com",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Color(0xff3a57e8),
                            size: 24,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                "Members:",
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Color(0xff3a56e5),
                              size: 24,
                            ),
                            Text(
                              "Abdallah Halimi (19700280)",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 1, 0, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Color(0xff3a57e8),
                              size: 24,
                            ),
                            Text(
                              "Medhat Haddad (19700568)",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Color(0xff3956e6),
                            size: 24,
                          ),
                          Text(
                            "Foad Farahbod (19701110)",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Color(0xff3956e6),
                              size: 24,
                            ),
                            Text(
                              "Youssef Binni (18700233)",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
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
      ),
    );
  }
}
