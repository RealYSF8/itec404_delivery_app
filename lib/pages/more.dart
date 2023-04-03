import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  String name = "";

  @override
  void initState() {
    super.initState();
    getNameFromSharedPreferences();
  }

  void getNameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "More",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.grey[800],
          size: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30, width: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/account');
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg'),
                    backgroundColor: Colors.red.withOpacity(0.53),
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Edit Personal Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.grey[600], size: 18),
                ],
              ),
            ),
            SizedBox(height: 10),
            buildRowWithIconAndText(
              icon: Icons.wb_sunny_outlined,
              iconColor: Colors.white,
              iconBackgroundColor: Colors.grey[700]!,
              text: "Dark Mode",
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: buildRowWithIconAndText(
                icon: Icons.article,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.orange,
                text: "Apply to be a courier",
                showTrailingIcon: true,
              ),
            ),
            SizedBox(height: 10),
            buildRowWithIconAndText(
              icon: Icons.build,
              iconColor: Colors.white,
              iconBackgroundColor: Colors.lightBlue[800]!,
              text: "Change password",
              showTrailingIcon: true,
            ),
            SizedBox(height: 10),
            buildRowWithIconAndText(
              icon: Icons.info_outline,
              iconColor: Colors.white,
              iconBackgroundColor: Colors.lightGreen,
              text: "About us",
              showTrailingIcon: true,
            ),
            SizedBox(height: 10),
            buildRowWithIconAndText(
              icon: Icons.call,
              iconColor: Colors.white,
              iconBackgroundColor: Colors.purple,
              text: "Contact Us",
              showTrailingIcon: true,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
                SharedPreferences prefs = await SharedPreferences.getInstance();

                // Set the isLoggedIn value to false
                await prefs.setBool("isLoggedIn", false);
              },
              child: buildRowWithIconAndText(
                icon: Icons.logout,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.amber,
                text: "Logout",
                showTrailingIcon: true,
              ),
            ),
            SizedBox(height: 10),
            buildRowWithIconAndText(
              icon: Icons.build,
              iconColor: Colors.white,
              iconBackgroundColor: Colors.lightBlue[800]!,
              text: "Change password",
              showTrailingIcon: true,
            ),
          ],
        ),
      ),
    );
  }

  Row buildRowWithIconAndText({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String text,
    bool showTrailingIcon = false,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: iconBackgroundColor,
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        if (showTrailingIcon)
          Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 18),
      ],
    );
  }
}