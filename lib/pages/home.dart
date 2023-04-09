import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Row(
          children: <Widget>[
            Text(
              "Swift",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 22,
                color: Color(0xffffffff),
              ),
            ),
            Text("Delivery",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 22,
                color: Color(0xfffba808),
              ),
            ),
          ]
      ),
      backgroundColor: Colors.blue,
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[400],
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                  child: Image.asset(
                    "assets/deliv-car.png",
                    height: 130,
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  "WELCOME!",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 120),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Color(0xff808080),
                    width: 3,
                  ),
                ),
                padding: EdgeInsets.all(16),
                minimumSize: Size(140, 40),
              ),
              child: Text(
                "Log In",
                style: TextStyle(
                  fontSize: 18,
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
                backgroundColor: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Color(0xff808080),
                    width: 3,
                  ),
                ),
                padding: EdgeInsets.all(16),
                minimumSize: Size(140, 40),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 18,
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
