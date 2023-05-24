import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail extends StatefulWidget {
  final String documentId;

  const OrderDetail({required this.documentId, Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailPage();
}


class _OrderDetailPage extends State<OrderDetail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = "";
  String destination = "";
  double length = 0.0;
  double width = 0.0;
  double height = 0.0;
  double price = 0.0;
  String status = "";
  String documentId = ""; // Added variable to store the document ID

  @override
  void initState() {
    super.initState();
    fetchDocumentId();
  }


  Future<void> fetchDocumentId() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestore.collection('orders').get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            snapshot.docs.first;
        documentId = documentSnapshot.id; // Retrieve the document ID
        fetchOrderDetails(); // Fetch the order details using the document ID
      } else {
        print('No orders found');
      }
    } catch (error) {
      print('Error retrieving document ID: $error');
    }
  }

  Future<void> fetchOrderDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await firestore.collection('orders').doc(documentId).get();
      if (documentSnapshot.exists) {
        // Fetch the order details
        Map<String, dynamic>? data = documentSnapshot.data();
        if (data != null) {
          setState(() {
            name = data['from'];
            destination = data['to'];
            length = _parseDouble(data['length']);
            width = _parseDouble(data['width']);
            height = _parseDouble(data['height']);
            price = _parseDouble(data['height']);
            status = data['status'];
          });
        }
      } else {
        print('Order document does not exist');
      }
    } catch (error) {
      print('Error retrieving order details: $error');
    }
  }

  double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Row(children: <Widget>[
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
        ]),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => OrderDetail(documentId: documentId),
                  ),
                );
                print('Document ID: $documentId'); // Print the document ID
              },
              subtitle: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        "Order Details",
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
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                                fontSize: 18.0,
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
                            Text(
                              destination,
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
                              'Length:',
                              style: TextStyle(
                                color: Color(0xfffba808),
                                letterSpacing: 2.0,
                                fontSize: 25.0,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              length.toString(),
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
                              'Width:',
                              style: TextStyle(
                                color: Color(0xfffba808),
                                letterSpacing: 2.0,
                                fontSize: 25.0,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              width.toString(),
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
                              height.toString(),
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
                              price.toString(),
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
                              status,
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
        ),
      ),
    );
  }

}
