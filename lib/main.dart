import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/pages/home.dart';
import 'package:itec404_delivery_app/pages/mainPage.dart';
import 'package:itec404_delivery_app/pages/register.dart';
import 'package:itec404_delivery_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:itec404_delivery_app/pages/order.dart';
import 'package:itec404_delivery_app/pages/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: isLoggedIn ? '/mainPage' : '/',
    routes: {
      '/': (context) => HomeScreen(),
      '/register': (context) => RegisterPage(),
      '/login': (context) => LoginPage(),
      '/mainPage': (context) => MainPage(),
      '/order': (context) => Order(),
      '/account': (context) => Account(),
    },
  ));
}
