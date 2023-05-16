import 'dart:math';

import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/pages/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itec404_delivery_app/pages/blank_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../main.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}
void _setCategoryName(String categoryName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("category", categoryName);
}

class _MainPage extends State<MainPage> {
  String address = "";

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page', style: optionStyle),
    Text('Order Page', style: optionStyle),
    Text('Account', style: optionStyle),
    Text('Blank Page', style: optionStyle),
  ];
  @override
  void initState() {
    super.initState();
    getAddressFromSharedPreferences();
  }
  void getAddressFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("address") ?? "";
    });
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlankPage()),
      );
    } else {
      List<String> routes = ['/mainPage', '/order', '/more'];
      Navigator.pushNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(children: <Widget>[
          Text("Swift",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xffffffff))),
          Text("Delivery",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xfffba808))),
        ]),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Color(0xffe2e5e7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.orange[500],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              color: Color(0xffffffff), size: 20),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(address,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xffffffff))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, position) {
                              List<String> imagePaths = [
                                "assets/dev.png",
                                "assets/effe.png",
                                "assets/reliable.png"
                              ];
                              return Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.asset(
                                    imagePaths[position],
                                    height: 300,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SmoothPageIndicator(
                              controller: pageController,
                              count: 3,
                              axisDirection: Axis.horizontal,
                              effect: WormEffect(
                                dotColor: Color(0xff9e9e9e),
                                activeDotColor: Color(0xff3f51b5),
                                dotHeight: 12,
                                dotWidth: 12,
                                radius: 16,
                                spacing: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Color(0x1fffffff),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
              physics: NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to orders page for Electronics
                    Navigator.pushNamed(context, '/order');
                  },
                  child: buildCategory("Electronics", "assets/elect.png"),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to orders page for Food
                    Navigator.pushNamed(context, '/order');
                  },
                  child: buildCategory("Food", "assets/food.png"),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to orders page for Clothing
                    Navigator.pushNamed(context, '/order');
                  },
                  child: buildCategory("Clothing", "assets/clothing.png"),
                ),
              ],
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


  Widget buildCategory(String name, String imagePath) {
    return InkWell(
      onTap: () {
        _setCategoryName(name);
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0x00ffffff),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image(
                image: AssetImage(imagePath),
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(
                name,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
