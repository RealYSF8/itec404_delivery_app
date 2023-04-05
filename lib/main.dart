import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/pages/home.dart';
import 'package:itec404_delivery_app/pages/mainPage.dart';
import 'package:itec404_delivery_app/pages/register.dart';
import 'package:itec404_delivery_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:itec404_delivery_app/pages/order.dart';
import 'package:itec404_delivery_app/pages/account.dart';
import 'package:itec404_delivery_app/pages/more.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/about.dart';
import 'Pages/contact.dart';
import 'Pages/courrier.dart';
import 'Pages/changepass.dart';




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
      '/more':(context) => More(),
      '/about':(context) => About(),
      '/contact':(context) => Contact(),
      '/courrier':(context) => Courrier(),
      '/changepass':(context) => Changepass(),

      // '/': (context) => HomeScreen(),
      // '/register': (context) =>customPageBuilder(context, RegisterPage()),
      // '/login': (context) => customPageBuilder(context, LoginPage()),
      // '/mainPage': (context) => MainPage(),
      // // '/mainPage': (context) => customPageBuilder(context, MainPage()),
      // '/order': (context) =>customPageBuilder(context, Order()),
      // '/account': (context) => customPageBuilder(context, Account()),
      // '/more':(context) => customPageBuilder(context, More()),
      // '/about':(context) => customPageBuilder(context, About()),
      // '/contact':(context) =>customPageBuilder(context, Contact()),
      // '/courrier':(context) => customPageBuilder(context, Courrier()),
      // '/changepass':(context) =>customPageBuilder(context, Changepass()),

    },
  ),);
}
