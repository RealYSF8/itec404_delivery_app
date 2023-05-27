import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail extends StatefulWidget {
  final String documentId;

  const OrderDetail({required this.documentId, Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetail> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> orderStream;

  @override
  void initState() {
    super.initState();
    // Retrieve the order details based on the document ID
    orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.documentId)
        .snapshots();
  }

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
            Text(
              "Orders",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 22,
                color: Color(0xfffba808),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: orderStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Text('No data available');
            }

            final orderData = snapshot.data!.data();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  onTap: () {},
                  subtitle: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            "Order #" +
                                (orderData?['orderNumber'] ?? '').toString(),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 35,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Divider(
                              thickness: 3,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Source:',
                                  style: TextStyle(
                                    color: Color(0xfffba808),
                                    letterSpacing: 2.0,
                                    fontSize: 25.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    orderData?['from'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                            SizedBox(height: 20.0),
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
                                SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    orderData?['to'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                            SizedBox(height: 15.0),
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
                                SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    orderData?['length'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  orderData?['width'] ?? '',
                                  style: TextStyle(
                                    color: Color(0xfffba808),
                                    letterSpacing: 2.0,
                                    fontSize: 25.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  orderData?['width'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                            SizedBox(height: 15.0),
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
                                SizedBox(width: 10.0),
                                Text(
                                  orderData?['height'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                            SizedBox(height: 15.0),
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
                                SizedBox(width: 10.0),
                                Text(
                                  orderData?['from'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                            SizedBox(height: 15.0),
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
                                SizedBox(width: 10.0),
                                Text(
                                  orderData?['status'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 20.0),

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
            );
          },
        ),
      ),
    );
  }
}
