import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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



  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: () {},
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