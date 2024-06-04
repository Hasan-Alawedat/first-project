import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/show_subject_fields.dart';

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

class SubjectsScreen extends StatefulWidget {
  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getSubjects/admin'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody); // طباعة الرد في وحدة التحكم
      final List<dynamic> subjectsJson = responseBody['Subjects'];
      setState(() {
        _subjects = subjectsJson.map((json) => Subject.fromJson(json)).toList();
      });
      await _saveSubjects(_subjects);
    } else {
      showResponseDialog('حدث خطأ في تحميل البيانات');
      print('Failed to load subjects: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<void> deleteSubject(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/deleteSubject/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] == true) {
        setState(() {
          _subjects.removeWhere((subject) => subject.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
        await _saveSubjects(_subjects);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the subject')),
      );
    }
  }

  Future<void> _saveSubjects(List<Subject> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final String subjectsJson = jsonEncode(subjects.map((subject) => subject.toJson()).toList());
    await prefs.setString('subjects', subjectsJson);
  }

  void showResponseDialog(String responseMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رسالة النتيجة '),
          content: Text(responseMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _subjects.length,
        itemBuilder: (context, index) {
          final subject = _subjects[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectDetailsScreen(subjectId: subject.id),
                ),
              );
            },
            child: Card(
              elevation: 4.0,
              color: Colors.white70,
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${subject.id} ',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'المادة : ${subject.subjectName}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => deleteSubject(subject.id),
                          icon: Icon(
                            Icons.delete,
                            size: 25,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 100),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectDetailsScreen(subjectId: subject.id),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          child: Text('       دخول        ', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    Divider(color: Colors.blue),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
