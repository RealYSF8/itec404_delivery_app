import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();

}

class _MoreState extends State<More> {
  String name = "";
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


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch(index) {
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
  @override
  void initState() {
    super.initState();
    getNameFromSharedPreferences();
    _checkAdminStatus();
    _checkDeliveryStatus();
    print(_isAdmin);
    print(_isCourier); // add this line to check the value of _isAdmin
// add this line to check the value of _isAdmin
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

  @override
  Widget build(BuildContext context) {
    showCustomAlert() => showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Log out?"),
      actions: [
        TextButton(onPressed: (){ return Navigator.pop(context, false);}, child: Text("Cancel")),
        TextButton(onPressed: (){ return Navigator.pop(context, true);}, child: Text("Yes")),
      ],
    )

    );

    return Scaffold(
      backgroundColor: Colors.white,
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
              Text("Options",
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
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Edit Personal Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black,
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
            buildRowWithIconAndText(
              icon: Icons.wb_sunny_outlined,
              iconColor: Colors.white,
              iconBackgroundColor: Colors.grey[700]!,
              text: "Dark Mode",
            ),
            SizedBox(height:15),
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
              child :buildRowWithIconAndText(
                icon: Icons.build,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.lightBlue[800]!,
                text: "Change password",
                showTrailingIcon: true,
              ),),
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
              ),),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/contact');
              },
              child:buildRowWithIconAndText(
                icon: Icons.call,
                iconColor: Colors.white,
                iconBackgroundColor: Colors.purple,
                text: "Contact Us",
                showTrailingIcon: true,
              ),),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {

                var stat = await showCustomAlert();
                if(stat){
                  Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
                  SharedPreferences prefs = await SharedPreferences.getInstance();

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
            if (_isAdmin) Container(
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
            if (_isCourier) Container(
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
  }) {
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
              color: Colors.black,
            ),
          ),
        ),
        if (showTrailingIcon)
          Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 18),
      ],
    );

  }
}

