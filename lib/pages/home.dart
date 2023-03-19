import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff436ddc),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Delivery App",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 14,
            color: Color(0xffffffff),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            height: 250,
            decoration: BoxDecoration(
              color: Color(0x1f000000),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: Color(0x4d9e9e9e), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:

                    ///***If you have exported images you must have to copy those images in assets/images directory.
                    Image(
                      image: AssetImage("assets/deliv-car.png"),
                      height: 150,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  "WELCOME!",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    color: Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 140, 0, 0),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              color: Color(0xff270ce0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Color(0xff808080), width: 1),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                "Log In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              textColor: Color(0xffffffff),
              height: 40,
              minWidth: 140,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              color: Color(0xff270ce0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Color(0xff808080), width: 1),
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
              textColor: Color(0xffffffff),
              height: 40,
              minWidth: 140,
            ),
          ),
        ],
      ),
    );
  }
}


///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/



