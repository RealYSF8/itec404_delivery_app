import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
class OrderPage extends StatefulWidget {

  @override
  State<OrderPage> createState() => _Order();

}

class _Order extends State<OrderPage>with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? _userId;
  String? _Name;

  String _image = 'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  File? _file;
  PlatformFile? _platformFile;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']
    );

    if (file != null) {
      setState(() {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
      });
    }

    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() { setState(() {}); });
    super.initState();
    super.initState();
    getNameFromSharedPreferences();
    _getUserData();
  }

  void getNameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _Name = prefs.getString("name") ?? "";
    });
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
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
              //Image.network(_image, width: 300,),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: selectFile,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      dashPattern: [10, 4],
                      strokeCap: StrokeCap.round,
                      color: Colors.blue.shade400,
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade50.withOpacity(.3),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.folder_open, color: Colors.blue, size: 35,),
                            SizedBox(height: 5),
                            Text('Select your file', style: TextStyle(fontSize: 15, color: Colors.grey.shade400),),
                              Text('File should be jpg, png', style: TextStyle(fontSize: 10, color: Colors.grey.shade500),),
                          ],
                        ),
                      ),
                    ),
                ),
              ),
              _platformFile != null
                  ? Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected File',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 15, ),),
                      SizedBox(height: 10,),
                      Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ]
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(_file!, width: 70,)
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_platformFile!.name,
                                      style: TextStyle(fontSize: 13, color: Colors.black),),
                                    SizedBox(height: 5,),
                                    Text('${(_platformFile!.size / 1024).ceil()} KB',
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                        height: 5,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.blue.shade50,
                                        ),
                                        child: LinearProgressIndicator(
                                          value: loadingController.value,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                            ],
                          )
                      ),
                    ],
                  ))
                  : Container(),



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