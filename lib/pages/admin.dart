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
      body: _selectedIndex == 0 ? _buildUsersTab() : _selectedIndex == 1 ? _buildOrdersTab() : _buildApplicationsTab(), // use the updated method name here
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
                            onPressed: () {
                              // Update status to "approved"
                              FirebaseFirestore.instance
                                  .collection('applications')
                                  .doc(applications[index].id)
                                  .update({'status': 'approved'});

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
  }//


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
              final String date =
                  DateFormat.yMd().add_jm().format(order['createdAt'].toDate());
              final String status = order['status'];
              return ListTile(
                subtitle:Card(
                  child: ListTile(
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(date),
                        Text(status),
                      ],
                    ),
                    // isThreeLine: true,
                  ),
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
