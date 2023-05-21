import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/pages/courier.dart';
import 'package:itec404_delivery_app/pages/home.dart';
import 'package:itec404_delivery_app/pages/mainPage.dart';
import 'package:itec404_delivery_app/pages/register.dart';
import 'package:itec404_delivery_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:itec404_delivery_app/pages/order.dart';
import 'package:itec404_delivery_app/pages/makeOrder.dart';
import 'package:itec404_delivery_app/pages/account.dart';
import 'package:itec404_delivery_app/pages/more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itec404_delivery_app/pages/passwordreset.dart';
import 'package:itec404_delivery_app/pages/review.dart';

import 'Pages/about.dart';
import 'Pages/contact.dart';
import 'Pages/courrier.dart';
import 'Pages/changepass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Pages/admin.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDC1WkdzulAQvZtlBTSQMCZlMmiWgrP4A0",
        appId: "1:655429434868:android:e994b0a3f99ccfbe3bcda1",
        messagingSenderId: "655429434868",
        projectId: "itec404deliveryapp",
      ),
  );
  bool _isAdmin = false;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String role = prefs.getString('role') ?? '';

    _isAdmin = role == 'Admin';

  bool _isCourier = false;

  SharedPreferences prefs1 = await SharedPreferences.getInstance();
  String role1 = prefs1.getString('role') ?? '';

  _isCourier = role == 'Courier';

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: isLoggedIn ? '/mainPage' : '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/mainPage': (context) => MainPage(),
        '/order': (context) => OrderPage(),
        '/makeorder': (context) => MakeOrderPage(controller: TextEditingController()),
        '/account': (context) => Account(firestore: firestore),
        '/more': (context) => More(),
        '/about': (context) => About(),
        '/contact': (context) => Contact(),
        '/courrier': (context) => Courrier(),
        '/changepass': (context) => Changepass(),
        '/reset': (context) => PasswordResetForm(),
        '/review': (context) => review(),
        '/admin': (context) {
          if (_isAdmin) {
            return AdminPage();
          } else {
            // Redirect to a different page or show an error message
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text('Access Denied'),
              ),
            );
          }
        },
        '/courier': (context) {
          if (_isCourier||_isAdmin) {
            return CourierPage();
          } else {
            // Redirect to a different page or show an error message
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text('Access Denied'),
              ),
            );
          }
        },
      },
    ),
  );
}