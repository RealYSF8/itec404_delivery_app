import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  String name = "";
  String email = "";
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home Page',
      style: optionStyle,
    ),
    Text(
      'Order Page',
      style: optionStyle,
    ),
    Text(
      'Account',
      style: optionStyle,
    ),
  ];

  bool _isAdmin = false;
  bool _isCourier = false;
  bool _isDarkMode = false;
  List<double> ratings = [];

  @override
  void initState() {
    super.initState();
    getNameFromSharedPreferences();
    getEmailFromSharedPreferences();
    getDarkModeStatusFromSharedPreferences();
    _checkAdminStatus();
    _checkDeliveryStatus();
    print(_isAdmin);
    print(_isCourier);
    fetchRatingsFromDatabase();
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

  void getDarkModeStatusFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/mainPage');
        break;
      case 1:
        Navigator.pushNamed(context, '/order');
        break;
      case 2:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }

  void _checkAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role') ?? '';
    setState(() {
      _isAdmin = role == 'Admin';
    });
  }

  void _checkDeliveryStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role') ?? '';
    setState(() {
      _isCourier = role == 'Courier';
    });
  }

  void getNameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
    });
  }

  void getEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email") ?? "";
    });
  }

  void fetchRatingsFromDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('email') ?? '';

    if (userEmail.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference usersCollection = firestore.collection('users');

      usersCollection
          .where('email', isEqualTo: userEmail)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          QueryDocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          if (documentSnapshot.exists) {
            Map<String, dynamic>? data =
                documentSnapshot.data() as Map<String, dynamic>?;
            if (data != null && data['ratings'] != null) {
              setState(() {
                ratings =
                    (data['ratings'] as List<dynamic>).cast<double>().toList();
              });
            }
          }
        }
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    showCustomAlert() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Log out?"),
            actions: [
              TextButton(
                onPressed: () {
                  return Navigator.pop(context, false);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  return Navigator.pop(context, true);
                },
                child: Text("Yes"),
              ),
            ],
          ),
        );

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              "Options",
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
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30, width: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/account');
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg'),
                    backgroundColor: Colors.red.withOpacity(0.53),
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '( ${calculateAverageRating().toStringAsFixed(1)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            //Icon(IconData(0xe5f9, fontFamily: 'MaterialIcons')),
                            Text(
                              ' )',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Edit Personal Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.grey[600], size: 18),
                ],
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                toggleDarkMode(context);
              },
              child: buildRowWithIconAndText(
                icon: Icons.wb_sunny_outlined,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.grey[700]!,
                text: "Dark Mode",
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/courrier');
              },
              child: buildRowWithIconAndText(
                icon: Icons.article,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.orange,
                text: "Apply to be a courier",
                showTrailingIcon: true,
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/changepass');
              },
              child: buildRowWithIconAndText(
                icon: Icons.build,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.lightBlue[800]!,
                text: "Change password",
                showTrailingIcon: true,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
              child: buildRowWithIconAndText(
                icon: Icons.info_outline,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.lightGreen,
                text: "About us",
                showTrailingIcon: true,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/contact');
              },
              child: buildRowWithIconAndText(
                icon: Icons.call,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.purple,
                text: "Contact Us",
                showTrailingIcon: true,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                var stat = await showCustomAlert();
                if (stat) {
                  Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await prefs.setBool("isLoggedIn", false);
                  await prefs.setBool("isadmin", false);
                  await prefs.setBool("isCourier", false);

                  await prefs.setString('name', "");
                  await prefs.setString('role', "");
                  await prefs.setString('phone_number', "");
                  await prefs.setString('category', "");
                  await prefs.setString('email', "");
                  await prefs.setString('address', "");
                }
              },
              child: buildRowWithIconAndText(
                icon: Icons.logout,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.amber,
                text: "Logout",
                showTrailingIcon: true,
              ),
            ),
            if (_isAdmin)
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin');
                      },
                      child: buildRowWithIconAndText(
                        icon: Icons.admin_panel_settings,
                        iconColor: Colors.white,
                        iconBackgroundColor: Colors.deepPurpleAccent,
                        text: "Admin Panel",
                        showTrailingIcon: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/courier');
                      },
                      child: buildRowWithIconAndText(
                        icon: Icons.local_shipping,
                        iconColor: Colors.white,
                        iconBackgroundColor: Colors.deepPurpleAccent,
                        text: "Courier Panel",
                        showTrailingIcon: true,
                      ),
                    ),
                  ),
                ],
              ),
            if (_isCourier)
              Container(
                margin: EdgeInsets.only(top: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/courier');
                  },
                  child: buildRowWithIconAndText(
                    icon: Icons.local_shipping,
                    iconColor: Colors.white,
                    iconBackgroundColor: Colors.deepPurpleAccent,
                    text: "Courier Panel",
                    showTrailingIcon: true,
                  ),
                ),
              ),
            SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Row buildRowWithIconAndText({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String text,
    bool showTrailingIcon = false,
    VoidCallback? onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: iconBackgroundColor,
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        if (showTrailingIcon)
          Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 18),
      ],
    );
  }
}
