import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatefulWidget {
  final String documentId;

  const OrderDetail({required this.documentId, Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetail> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> orderStream;
  bool _isDarkMode = false;
  List<double> ratings = [];

  @override
  void initState() {
    fetchRatingsFromDatabase();

    super.initState();
    getDarkModeStatusFromSharedPreferences();
    orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.documentId)
        .snapshots();
  }

  void fetchRatingsFromDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot orderSnapshot =
        await firestore.collection('orders').doc(widget.documentId).get();
    Map<String, dynamic>? orderData =
        orderSnapshot.data() as Map<String, dynamic>?;

    if (orderData != null && orderData['rating'] != null) {
      setState(() {
        ratings = [(orderData['rating'] as double).toDouble()];
      });
    }
  }

  double calculateAverageRating() {
    if (ratings.isEmpty) {
      return 0;
    }
    double sum = ratings.reduce((value, element) => value + element);
    double average = sum / ratings.length.toDouble();
    return average;
  }

  Widget buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 0; i < rating.floor(); i++) {
      stars.add(
        Icon(Icons.star, color: Colors.green, size: 16),
      );
    }
    if (rating % 1 != 0) {
      stars.add(
        Icon(Icons.star_half, color: Colors.green, size: 16),
      );
    }
    return Row(children: stars);
  }

  Future<void> toggleDarkMode(BuildContext context) async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', themeProvider.isDarkMode);
  }

  String getEstimatedDeliveryTime(Timestamp? acceptedDate) {
    if (acceptedDate != null) {
      final acceptedDateTime = acceptedDate.toDate();
      final deliveryTime = acceptedDateTime.add(Duration(minutes: 30));
      final deliveryStartTime = DateFormat.jm().format(deliveryTime);
      final deliveryEndTime =
          DateFormat.jm().format(deliveryTime.add(Duration(minutes: 15)));
      return '$deliveryStartTime - $deliveryEndTime';
    }
    return '';
  }

  void getDarkModeStatusFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/order');
        return true;
      },
      child: Scaffold(
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
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
          padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
          child: SingleChildScrollView(
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
                final imageUrl = orderData?['imageUrls'] as String?;
                final status = orderData?['status'] as String?;
                final acceptedBy = orderData?['acceptedBy'] as String?;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      onTap: () {},
                      subtitle: Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Column(
                            children: [
                              if (imageUrl != null)
                                ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        25.0, 0.0, 25.0, 0.0),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              child: Image.network(
                                                imageUrl,
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "Order #" +
                                                (orderData?['orderNumber'] ??
                                                        '')
                                                    .toString(),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Divider(
                                        thickness: 3,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Product Name:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Flexible(
                                            child: Text(
                                              orderData?['productName'] ?? '',
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
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Source:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
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
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Destination:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
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
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Length:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            orderData?['length'] ?? '',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 2.0,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            ' CM',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 2.0,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Width:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
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
                                          Text(
                                            ' CM',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 2.0,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Height:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
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
                                          Text(
                                            ' CM',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 2.0,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Price:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            orderData?['price'] ?? '',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 2.0,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            ' TL',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 2.0,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Status:',
                                            style: TextStyle(
                                              color: Color(0xfffba808),
                                              letterSpacing: 2.0,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            status ?? '',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 2.0,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      if (['Processing', 'Shipped', 'Delivered']
                                          .contains(status))
                                        StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .where('email',
                                                  isEqualTo: acceptedBy)
                                              .snapshots(),
                                          builder: (context, userSnapshot) {
                                            if (userSnapshot.hasError) {
                                              return Text(
                                                  'Error: ${userSnapshot.error}');
                                            }

                                            if (userSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            if (!userSnapshot.hasData ||
                                                userSnapshot.data == null) {
                                              return Text('No data available');
                                            }

                                            final userData = userSnapshot
                                                .data!.docs.first
                                                .data() as Map<String, dynamic>;
                                            final userName =
                                                userData['name'] as String?;
                                            print(userName);

                                            return Visibility(
                                              visible: userName != null,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Courier:',
                                                    style: TextStyle(
                                                      color: Color(0xfffba808),
                                                      letterSpacing: 2.0,
                                                      fontSize: 24.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  Flexible(
                                                    child: Text(
                                                      userName ??
                                                          'N/A' +
                                                              '${calculateAverageRating().toStringAsFixed(1)}',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        letterSpacing: 2.0,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      SizedBox(height: 10.0),
                                      if (['Processing', 'Shipped', 'Delivered']
                                          .contains(status))
                                        StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .where('email',
                                                  isEqualTo: acceptedBy)
                                              .snapshots(),
                                          builder: (context, userSnapshot) {
                                            if (userSnapshot.hasError) {
                                              return Text(
                                                  'Error: ${userSnapshot.error}');
                                            }

                                            if (userSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            if (!userSnapshot.hasData ||
                                                userSnapshot.data == null) {
                                              return Text('No data available');
                                            }

                                            final userData = userSnapshot
                                                .data!.docs.first
                                                .data() as Map<String, dynamic>;
                                            final userName =
                                                userData['name'] as String?;
                                            print(userName);

                                            return Visibility(
                                              visible: userName != null,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Rating:',
                                                    style: TextStyle(
                                                      color: Color(0xfffba808),
                                                      letterSpacing: 2.0,
                                                      fontSize: 24.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  SizedBox(height: 20.0),
                                                  if (calculateAverageRating() >
                                                      0)
                                                    buildRatingStars(
                                                        calculateAverageRating()),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      SizedBox(height: 10.0),
                                      Visibility(
                                        visible: ['Processing', 'Shipped']
                                            .contains(status),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Estimated Delivery Time:',
                                              style: TextStyle(
                                                color: Color(0xfffba808),
                                                letterSpacing: 2.0,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                            SizedBox(height: 20.0),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Visibility(
                                        visible: ['Processing', 'Shipped']
                                            .contains(status),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                orderData?['acceptedDate'] !=
                                                        null
                                                    ? getEstimatedDeliveryTime(
                                                        orderData?[
                                                                'acceptedDate']
                                                            as Timestamp)
                                                    : 'N/A',
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
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
