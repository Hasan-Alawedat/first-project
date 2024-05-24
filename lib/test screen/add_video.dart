import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Video extends StatefulWidget{
  @override
  State<Video> createState() => _FileState();
}

class _FileState extends State<Video> {

  List<Subject> _subjects = [];
  String? _selectedSubjectName;
  int? _selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? subjectsJson = prefs.getString('subjects');

    if (subjectsJson != null) {
      final List<dynamic> subjectsList = jsonDecode(subjectsJson);
      setState(() {
        _subjects = subjectsList.map((json) => Subject.fromJson(json)).toList();
      });
    }
  }

  void _onSubjectSelected(String? selectedName) {
    final selectedSubject = _subjects.firstWhere((subject) => subject.subjectName == selectedName);
    setState(() {
      _selectedSubjectName = selectedName;
      _selectedSubjectId = selectedSubject.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body:
      ListView(
        children: [
          SizedBox(height: 20,),

          Center(child: Text(" رفع  فيديو",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 40),)),
          SizedBox(height: 70,),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(15)),
              width: 500,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "         اسم  الملف",
                          labelStyle: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800)
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("اسم المادة",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),),
                    SizedBox(width: 150,),
                    SizedBox(
                      width:180,
                      child:  DropdownButton<String>(
                        hint: Text('اختر المادة'),
                        value: _selectedSubjectName,
                        items: _subjects.map((subject) {
                          return DropdownMenuItem<String>(
                            value: subject.subjectName,
                            child: Text(subject.subjectName),
                          );
                        }).toList(),
                        onChanged: _onSubjectSelected,
                      ),
                    ),
                  ],),
                SizedBox(height: 20,),

                if (_selectedSubjectId != null) ...[

                  SizedBox(height: 8),
                  Text(
                    'المادة: $_selectedSubjectName',
                    style: TextStyle(fontSize: 18),
                  ),
                ],

                SizedBox(height: 30),
                IconButton(
                  icon: Icon(Icons.video_collection_outlined),
                  color: Colors.amber[900],
                  iconSize: 50,
                  onPressed: () {
                    // Implement your file upload functionality here
                  },
                ),
                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber[900],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("حفظ", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
SizedBox(height: 10,)
              ],),
            ),
          ),
        ],
      ),
    );
  }
}


class Subject {
  final int id;
  final String subjectName;
  Subject({required this.id, required this.subjectName});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      subjectName: json['subject_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_name': subjectName,
  };
}
