import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late List<DocumentSnapshot> orders = [];

  String searchQuery = '';
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    Icon(
      Icons.people,
      size: 30,
    ),
    Icon(
      Icons.shopping_cart,
      size: 30,
    ),
    Icon(
      Icons.article,
      size: 30,
    ),
  ];

  Icon searchIcon = Icon(Icons.search);
  bool isSearching = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (isSearching) {
        searchIcon = Icon(Icons.close);
        // Perform any necessary search-related actions
      } else {
        searchIcon = Icon(Icons.search);
        searchQuery = ''; // Clear the search query
        // Cancel or clear the search
      }
    });
  }
  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('email') ?? '';

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .get();

    setState(() {
      orders = snapshot.docs;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching ? TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search by name',
          ),
        ) : Text('Admin Panel'),
        actions: [
          IconButton(
            icon: searchIcon,
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildUsersTab()
          : _selectedIndex == 1
          ? _buildOrdersTab()
          : _buildApplicationsTab(),
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
  Widget _buildApplicationsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .orderBy('status')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<DocumentSnapshot> applications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> applicationData =
            applications[index].data()! as Map<String, dynamic>;
            String email = applicationData['email'];
            String name = applicationData['name'];
            String phoneNumber = applicationData['phone_number'];
            String status = applicationData['status'];

            return ListTile(
              title: Text('Email: $email'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: $name'),
                  Text('Phone Number: $phoneNumber'),
                  Text('Status: $status'),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Application Status'),
                      content: Text('Choose an action:'),
                      actions: [
                        if (status != 'rejected') ...[
                          TextButton(
                            child: Text('Approve'),
                            onPressed: () async {
                              // Update status to "approved"
                              await FirebaseFirestore.instance
                                  .collection('applications')
                                  .doc(applications[index].id)
                                  .update({'status': 'approved'});

                              // Update user's role to "Courier" in the user's table
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                querySnapshot.docs.forEach((doc) async {
                                  await doc.reference.update({'role': 'Courier'});
                                });
                              });

                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Reject'),
                            onPressed: () {
                              // Delete the document from the table
                              FirebaseFirestore.instance
                                  .collection('applications')
                                  .doc(applications[index].id)
                                  .delete();

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
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

        // Filter users based on the search query
        final filteredUsers = users.where((user) {
          final String name = user['name'] ?? '';
          return name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot<Object?> user = filteredUsers[index];

            try {
              final String name = user['name'];
              final String phoneNumber = user['phone_number'];
              final String role = user['role'];
              final String address = user['address'];
              final String email = user['email'];
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(date),
              //     Text(status),
              //   ],
              // ),
              return ListTile(
                subtitle: Card(
                  child: ListTile(
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Account type:$role '),
                        Text('$phoneNumber | $address | $email'),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  if (role == 'deactivated') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(name),
                          content: Text('What would you like to do?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Activate'),
                              onPressed: () async {
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Activation'),
                                      content: Text(
                                          'Are you sure you want to activate this user?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Confirm'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.id)
                                      .update({'role': 'General'});
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Modify'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String selectedRole = role;
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                        title: Text('Modify User Role'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RadioListTile<String>(
                                              title: Text('General'),
                                              value: 'General',
                                              groupValue: selectedRole,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedRole = value!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              title: Text('Admin'),
                                              value: 'Admin',
                                              groupValue: selectedRole,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedRole = value!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              title: Text('Courier'),
                                              value: 'Courier',
                                              groupValue: selectedRole,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedRole = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Save'),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user.id)
                                                  .update(
                                                  {'role': selectedRole});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                );
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(name),
                          content: Text('What would you like to do?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Deactivate'),
                              onPressed: () async {
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Deactivation'),
                                      content: Text(
                                          'Are you sure you want to deactivate this user?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Confirm'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.id)
                                      .update({'role': 'deactivated'});
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Modify'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String selectedRole = role;
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                        title: Text('Modify User Role'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RadioListTile<String>(
                                              title: Text('General'),
                                              value: 'General',
                                              groupValue: selectedRole,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedRole = value!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              title: Text('Admin'),
                                              value: 'Admin',
                                              groupValue: selectedRole,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedRole = value!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              title: Text('Courier'),
                                              value: 'Courier',
                                              groupValue: selectedRole,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedRole = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Save'),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user.id)
                                                  .update(
                                                  {'role': selectedRole});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                );
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
                  }
                },
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final createdAt = (order['createdAt'] as Timestamp).toDate();
        final imageUrls = order['imageUrls'];

        String firstImageUrl = '';
        if (imageUrls != null && imageUrls.isNotEmpty) {
          if (imageUrls is String) {
            firstImageUrl = imageUrls;
          } else if (imageUrls is List<dynamic>) {
            firstImageUrl =
                imageUrls.firstWhere((url) => url is String, orElse: () => '');
          }
        }
  return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(firstImageUrl),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#" + order['orderNumber'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['status'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  thickness: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date: ${createdAt.toString().substring(0, 10)}",
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
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
                                        order.reference.update(
                                            {'status': 'Shipped'});
                                        Navigator.of(context).pop();
                                        fetchOrders();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delivered'),
                                      onPressed: () {
                                        order.reference.update(
                                            {'status': 'Delivered'});
                                        Navigator.of(context).pop();
                                        fetchOrders();
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
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Change Status",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the "/orderdetail" page with the document ID
                            Navigator.pushNamed(context, '/orderdetail',
                                arguments: order.id);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Order Detail",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
