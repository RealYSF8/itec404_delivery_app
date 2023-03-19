import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();

}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin{

  Widget build(BuildContext context) {
    Navigator.pushNamed(context, '/login');
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body:Center(
        child:SpinKitFadingCube (
          color: Colors.white,
          size: 80.0,
          controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 3600)),
      ),
      ),
    );
  }
}
