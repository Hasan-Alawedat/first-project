import 'package:flutter/material.dart';
import 'package:untitled34/project/add_teacher.dart';
import 'package:untitled34/project/register_admin.dart';
import 'package:untitled34/project/show_subjects.dart';
import 'package:untitled34/project/show_teachers.dart';
import 'package:untitled34/project/signin.dart';
import 'package:untitled34/project/register.dart';
import 'package:untitled34/project/home.dart';
import 'package:untitled34/project/welcom_start_web.dart';
import 'package:untitled34/test%20screen/add_file.dart';
import '../test screen/add_video.dart';
import 'add_subject.dart';

void main() {
  runApp(MyWeb());
}

class MyWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  WelcomeScreen(),
    );
  }
}