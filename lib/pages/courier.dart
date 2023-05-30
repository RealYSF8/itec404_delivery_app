import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourierPage extends StatefulWidget {
  @override
  _CourierPageState createState() => _CourierPageState();
}

class _CourierPageState extends State<CourierPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? userEmail;
  DateTime? acceptedDate; // Added variable to store the accepted date and time

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getUserEmail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All Orders'),
            Tab(text: 'My Orders'),
          ],
        ),
        title: Row(children: <Widget>[
          Text(
            "Courier",
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
            "Panel",
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
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllOrdersTab(),
          _buildMyOrdersTab(),
        ],
      ),
    );
  }

  Widget _buildAllOrdersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot<Object?> order = orders[index];

            try {
              final String name = order['Name'];
              final String date =
              DateFormat.yMd().add_jm().format(order['createdAt'].toDate());
              final String status = order['status'];
              return ListTile(
                subtitle: Card(
                  child: ListTile(
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(date),
                        Text(status),
                      ],
                    ),
                  ),
                ),

                onTap: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  String? userEmail = prefs.getString('email');

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Order Options'),
                        content: Text('Do you want to accept this order?'),
                        actions: [
                          TextButton(
                            child: Text('Accept'),
                            onPressed: () {
                              // Set acceptedDate to the current date and time
                              acceptedDate = DateTime.now();

                              // Update order status, acceptedBy field, and acceptedDate field
                              order.reference.update({
                                'status': 'processing',
                                'acceptedBy': userEmail,
                                'acceptedDate': acceptedDate,
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            } catch (e, stackTrace) {
              print('Error accessing order fields: $e\n$stackTrace');
              return Text('Error accessing order fields');
            }
          },
        );
      },
    );
  }


  Widget _buildMyOrdersTab() {
    if (userEmail == null) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('acceptedBy', isEqualTo: userEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot<Object?> order = orders[index];

            try {
              final String name = order['Name'];
              final String date =
              DateFormat.yMd().add_jm().format(order['createdAt'].toDate());
              String status = order['status'];
              return ListTile(
                subtitle: Card(
                  child: ListTile(
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(date),
                        Text(status),
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Change Status'),
                        content: Text('Select the new status:'),
                        actions: [
                          TextButton(
                            child: Text('Shipped'),
                            onPressed: () {
                              order.reference.update({'status': 'Shipped'});
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Delivered'),
                            onPressed: () {
                              order.reference.update({'status': 'Delivered'});
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            } catch (e, stackTrace) {
              print('Error accessing order fields: $e\n$stackTrace');
              return Text('Error accessing order fields');
            }
          },
        );
      },
    );
  }
}
