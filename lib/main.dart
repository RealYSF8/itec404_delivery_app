import 'package:flutter/material.dart';
import 'package:itec404_delivery_app/pages/home.dart';
import 'package:itec404_delivery_app/pages/loading.dart';
import 'package:itec404_delivery_app/pages/register.dart';
import 'package:itec404_delivery_app/pages/login.dart';


void main() {
  runApp(MaterialApp(
     // home: HomeScreen(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      //'/':(context)=>Loading(),
      '/':(context)=>HomeScreen(),
      '/register':(context)=>RegisterPage(),
      '/login':(context)=>LoginPage(),
    },
  ));
}
