import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        backgroundColor: Color(0xff436ddc),
        title: Text(
          "Delivery App",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Image.asset(
                    "assets/deliv-car.png",
                    height: 150,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  "WELCOME!",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 140),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff270ce0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Color(0xff808080),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(16),
                minimumSize: Size(140, 40),
              ),
              child: Text(
                "Log In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff270ce0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Color(0xff808080),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(16),
                minimumSize: Size(140, 40),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
