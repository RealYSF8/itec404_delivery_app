import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    Icon(Icons.people, size: 30,),
    Icon(Icons.shopping_cart, size: 30,),
    Icon(Icons.article, size: 30,),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: _selectedIndex == 0
          ? _buildUsersTab()
          : _buildOrdersTab(), // use the updated method name here
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Applications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildUsersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot<Object?> user = users[index];

            try {
              final String name = user['name'];
              final String phoneNumber = user['phone_number'];
              final String role = user['role'];
              final String address = user['address'];
              final String email = user['email'];

              return Dismissible(
                key: Key(user.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text(
                            "Are you sure you want to delete this user?"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection(
                                    'users').doc(user.id).delete();
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Delete"))
                        ],
                      );
                    },
                  );
                },
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text('$role | $phoneNumber | $address | $email'),
                ),
              );
            } catch (e, stackTrace) {
              print('Error accessing user fields: $e\n$stackTrace');
              return Text('Error accessing user fields');
            }
          },
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    // add this method to build the orders tab
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
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
              final String date = DateFormat.yMd().add_jm().format(
                  order['createdAt'].toDate());
              final String status = order['status'];

              return ListTile(
                title: Text(name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    Text(status),
                  ],
                ),
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