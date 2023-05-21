import 'package:flutter/material.dart';
class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailPage();
}

class _OrderDetailPage extends State<OrderDetail> {

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
              Text("Orders",
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

          });
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Order Details",
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 40,
                // color: Color(0xffffffff),
              ),
            ),SizedBox(height: 15.0),
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Source:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(width: 10.0),//puts an invisible box between two texts
              Text(
                'name',
                style: TextStyle(
                  color: Color(0xfffba808),
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),SizedBox(height: 20.0),
              ],
            ),SizedBox(height: 15.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Destination:',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(width: 10.0),//puts an invisible box between two texts
                Text(
                  'name',
                  style: TextStyle(
                    color: Color(0xfffba808),
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),SizedBox(height: 20.0),
              ],
            ),SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Length:',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(width: 10.0),//puts an invisible box between two texts
                Text(
                  'name',
                  style: TextStyle(
                    color: Color(0xfffba808),
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),SizedBox(height: 20.0),
              ],
            ),SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Width:',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(width: 10.0),//puts an invisible box between two texts
                Text(
                  'name',
                  style: TextStyle(
                    color: Color(0xfffba808),
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),SizedBox(height: 20.0),
              ],
            ),SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Height:',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(width: 10.0),//puts an invisible box between two texts
                Text(
                  'name',
                  style: TextStyle(
                    color: Color(0xfffba808),
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),SizedBox(height: 20.0),
              ],
            ),SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Price:',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(width: 10.0),//puts an invisible box between two texts
                Text(
                  'name',
                  style: TextStyle(
                    color: Color(0xfffba808),
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),SizedBox(height: 20.0),
              ],
            ),SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Status:',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(width: 10.0),//puts an invisible box between two texts
                Text(
                  'name',
                  style: TextStyle(
                    color: Color(0xfffba808),
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),SizedBox(height: 20.0),
              ],
            ),SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}