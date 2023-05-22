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
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
                subtitle: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10), //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
                        child: Text(
                          "Order Details",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 35,
                            // color: Color(0xffffffff),
                          ),
                        ),
                      ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Divider(
                      thickness: 3,
                    ),
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Source:',
                            style: TextStyle(
                              color: Color(0xfffba808),
                              letterSpacing: 2.0,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(width: 10.0),//puts an invisible box between two texts
                          Text(
                            'Blank',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                              fontSize: 18.0,
                            ),
                          ),SizedBox(height: 20.0),
                        ],
                      ),SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Destination:',
                            style: TextStyle(
                              color: Color(0xfffba808),
                              letterSpacing: 2.0,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(width: 10.0),//puts an invisible box between two texts
                          Text(
                            'Blank',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                              fontSize: 18.0,
                            ),
                          ),SizedBox(height: 20.0),
                        ],
                      ),SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Length:',
                            style: TextStyle(
                              color: Color(0xfffba808),
                              letterSpacing: 2.0,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(width: 10.0),//puts an invisible box between two texts
                          Text(
                            'Blank',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                              fontSize: 18.0,
                            ),
                          ),SizedBox(height: 20.0),
                        ],
                      ),SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                              Text(
                                'Width:',
                                style: TextStyle(
                                  color: Color(0xfffba808),
                                  letterSpacing: 2.0,
                                  fontSize: 25.0,
                                ),
                              ),
                              SizedBox(width: 10.0),//puts an invisible box between two texts
                              Text(
                                'Blank',
                                style: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 2.0,
                                  fontSize: 18.0,
                                ),
                              ),SizedBox(height: 20.0),
                            ],
                          ),SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Height:',
                                style: TextStyle(
                                  color: Color(0xfffba808),
                                  letterSpacing: 2.0,
                                  fontSize: 25.0,
                                ),
                              ),
                              SizedBox(width: 10.0),//puts an invisible box between two texts
                              Text(
                                'Blank',
                                style: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 2.0,
                                  fontSize: 18.0,
                                ),
                              ),SizedBox(height: 20.0),
                            ],
                          ),SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Price:',
                                style: TextStyle(
                                  color: Color(0xfffba808),
                                  letterSpacing: 2.0,
                                  fontSize: 25.0,
                                ),
                              ),
                              SizedBox(width: 10.0),//puts an invisible box between two texts
                              Text(
                                'Blank',
                                style: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 2.0,
                                  fontSize: 18.0,

                                ),
                              ),SizedBox(height: 20.0),
                            ],
                          ),SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Status:',
                                style: TextStyle(
                                  color: Color(0xfffba808),
                                  letterSpacing: 2.0,
                                  fontSize: 25.0,
                                ),
                              ),
                              SizedBox(width: 10.0),//puts an invisible box between two texts
                              Text(
                                'Blank',
                                style: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 2.0,
                                  fontSize: 18.0,
                                ),
                              ),SizedBox(height: 20.0),
                            ],
                      ),
                  ],
                ),
              ),
                    ),
              ),
            ),
          SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}