import 'package:flutter/material.dart';
class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account> {

  int ninjaLevel=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
            children: <Widget>[
              Text(
                "My",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xffffffff),
                ),
              ),
              Text("Account",
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            ninjaLevel+=1;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/ninja.png'),
                radius: 40.0,
              ),
            ),
            Divider(
              height: 60.0,
              color: Colors.grey[700],
            ),
            Text(
              'NAME',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,//pixels betwwen each letter to make it more readable when text it's small
              ),
            ),
            SizedBox(height: 10.0),//puts an invisible box between two texts
            Text(
              'Foad',
              style: TextStyle(
                color: Color(0xfffba808),
                letterSpacing: 2.0,
                fontSize: 28.0,//in pixels
                fontWeight: FontWeight.bold,
              ),
            ),SizedBox(height: 30.0),
            Text(
              'LAST NAME',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,//pixels betwwen each letter to make it more readable when text it's small
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Farahbod',
              style: TextStyle(
                color: Color(0xfffba808),
                letterSpacing: 2.0,
                fontSize: 28.0,//in pixels
                fontWeight: FontWeight.bold,
              ),
            ),SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 10.0),
                Text(
                  'Foad@yahoo.com',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.call,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 10.0),
                Text(
                  '05391142425',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}