import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';

class Teacher {
  final int id;
  final String firstName;
  final String lastName;
  final String subjectName;
  final String phoneNo;
  final String description;
  final int teachingDuration;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.subjectName,
    required this.phoneNo,
    required this.description,
    required this.teachingDuration,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      subjectName: json['subject_name'],
      phoneNo: json['phone_no'],
      description: json['description'],
      teachingDuration: json['teaching_duration'],
    );
  }
}
class Teachers extends StatefulWidget{
  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {

  List<Teacher> teachers = [];
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<void> fetchTeachers() async {
    setState(() {
    });

    var token = await getToken();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/showingAllTeachers'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",},
    );

    if (response.statusCode == 200) {
      final List<dynamic> teacherJson = json.decode(response.body)['data'];
      setState(() {
        teachers = teacherJson.map((json) => Teacher.fromJson(json)).toList();
      });
    } else {
      // Handle the error
    }
  }
  Future<void> deleteTeacher(int id) async {
    var token = await getToken();

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/deleteTeacher/admin/$id'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        teachers.removeWhere((teacher) => teacher.id == id);
      });
    } else {
      // Handle the error
    }
  }


  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 829;
    final isDesk = MediaQuery.of(context).size.width >= 1470;
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.white,
        title:   Row(

        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isDesk?Row(children: [
            IconButton(
              icon: const Icon(
                Icons.person,color: Colors.blueGrey,
              ),onPressed: (){},),

            SizedBox(width: 600,),
          ],):Container(),

          isDesktop?Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Container( decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(12)),
                height: 40,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notification_important,color: Colors.blueGrey,
                      ),onPressed: (){},),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
              child: Container( decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(12)),
                height: 40,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.forward_to_inbox,color: Colors.blueGrey,
                      ),onPressed: (){

                    },),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Container( decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(12)),
                height: 40,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.home,color: Colors.blueGrey,
                      ),onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false,
                      );
                    },),

                  ],
                ),
              ),
            ),
            SizedBox(width: 280,),

          ],):Container(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 7),
            child: Container( decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12)),
              width: 230,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "                                       بحث  ",
                  hoverColor: Colors.cyan,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search_rounded,color: Colors.black12,
                    ),onPressed: (){},),
                ),
              ),),
          ),

        ],
      ),
        automaticallyImplyLeading: false, // هذا يمنع ظهور أيقونة الرجوع التلقائية
      ),
      body: ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return Card(
            elevation: 4.0,
            color: Colors.white70,
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '  ${teacher.firstName} ${teacher.lastName} ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'المادة : ${teacher.subjectName}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(width: 150,),
                      Text(
                        'الخبرة : ${teacher.teachingDuration}  سنة ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'رقم الهاتف : ${teacher.phoneNo} ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(width: 150,),

                      Text(
                        'معلومات أخرى : ${teacher.description}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.0),

                  IconButton(
                    onPressed: () {
                      deleteTeacher(teacher.id);
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.red,
                    ),
                  ),
                  Divider(color: Colors.blue),
                ],
              ),
            ),
          );
        },
      ),

    );
  }
}