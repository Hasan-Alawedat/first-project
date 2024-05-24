
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled34/project/home.dart';
import 'package:untitled34/project/register.dart';
import 'package:untitled34/project/signin.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signin()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:                     Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            Text(
              "A",
              style: TextStyle(fontSize: 100, color: Colors.red,fontWeight: FontWeight.w900),
            ),
            Text(
              "O",
              style: TextStyle(fontSize: 100, color: Colors.green,fontWeight: FontWeight.w900),
            ),
            Text(
              "T",
              style: TextStyle(fontSize: 100, color: Colors.indigo,fontWeight: FontWeight.w900),
            ),
            Text(
              "H ",
              style:
              TextStyle(fontSize: 100, color: Colors.yellow,fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),

    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية'),
      ),
      body: Center(
        child: Text('هذه هي الصفحة الرئيسية للتطبيق'),
      ),
    );
  }
}