import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/pages/home.dart';
import 'package:itec404_delivery_app/pages/mainPage.dart';
import 'package:itec404_delivery_app/pages/register.dart';
import 'package:itec404_delivery_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/mainPage',
    routes: {
      '/': (context) => HomeScreen(),
      '/register': (context) => RegisterPage(),
      '/login': (context) => LoginPage(),
      '/mainPage': (context) => MainPage(),

    },
  ));
}
