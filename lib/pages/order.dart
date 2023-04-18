import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {

  @override
  State<OrderPage> createState() => _Order();
}

Future<void> getLostData() async {
  final ImagePicker picker = ImagePicker();
  final LostDataResponse response = await picker.retrieveLostData();
  if (response.isEmpty) {
    return;
  }
  final List<XFile>? files = response.files;
}

class _Order extends State<OrderPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? _userId;
  String? _Name;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _Name = user.displayName;
      });
    }
  }

  Future<void> _createOrder() async {
    // Get the data from the input fields
    String? from = fromController.text;
    String? to = toController.text;
    String? length = lengthController.text;
    String? width = widthController.text;
    String? height = heightController.text;

    // Get the current date and time
    Timestamp now = Timestamp.now();

    // Create a new order document with the data and timestamp
    await _db.collection('orders').add({
      'userId': _userId,
      'Name': _Name,
      'from': from,
      'to': to,
      'length': length,
      'width': width,
      'height': height,
      'status': 'pending',
      'createdAt': now, // add the current date and time to the document
    }).then((value) {
      // Display the order status in the database
      _db.collection('orders').doc(value.id).update({'status': 'pending'});
    });

    // Clear the input fields
    fromController.clear();
    toController.clear();
    lengthController.clear();
    widthController.clear();
    heightController.clear();
  }



  int _selectedIndex = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text("Orders",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              TextFormField(
                controller: fromController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'From',
                  suffixIcon: Icon(Icons.navigation_sharp),
                  suffix: Text('Source'),
                ),
              ),
              TextFormField(
                controller: toController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'To',
                  suffixIcon: Icon(Icons.assistant_navigation),
                  suffix: Text('Destination'),
                ),
              ),
              TextFormField(
                controller: lengthController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Length',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
              ),
              TextFormField(
                controller: widthController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Width',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
              ),
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Height',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  getLostData();
                },
                child: Text('Get Image'),
              ),
              ElevatedButton(
                onPressed: _createOrder,
                child: Text('Create Order'),
              ),
            ],
          ),
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
}