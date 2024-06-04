import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';


//  الكلاس الرئيسي
class AddTeacher extends StatefulWidget {
  @override
  _AnotherScreenState createState() => _AnotherScreenState();
}

//  كلاس للمتغيرات والكورنترولات
class _AnotherScreenState extends State<AddTeacher> {
  List<Subject> _subjects = [];
  String? _selectedSubjectName;
  int? _selectedSubjectId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _teachingDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  // تابع تحميل معلومات المواد لعرضها ب قائمة منسدلة
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

  // تابع لتحديث حالة الدروب داون
  void _onSubjectSelected(String? selectedName) {
    final selectedSubject = _subjects.firstWhere((subject) => subject.subjectName == selectedName);
    setState(() {
      _selectedSubjectName = selectedName;
      _selectedSubjectId = selectedSubject.id;
    });
  }

  // تابع api
  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/addTeacher/admin/$_selectedSubjectId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "description": _descriptionController.text,
          "phone_no": _phoneNoController.text,
          "teaching_duration": int.parse(_teachingDurationController.text),
        }),
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Login();}));

      } else if (response.statusCode != 200 ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('المعلومات غير صحيحة')),
        );
      }
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
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
            SizedBox(height: 20),
            if (_selectedSubjectId != null) ...[
              SizedBox(height: 8),
              Text(
                'المادة: $_selectedSubjectName',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
            ],
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'الأسم '),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال اسم';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'الكنية'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال الكنية';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'معلومات عن المعلم'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال معلومات ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneNoController,
                    decoration: InputDecoration(labelText: 'رقم الهاتف'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال رقم';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _teachingDurationController,
                    decoration: InputDecoration(labelText: 'مدة التدريس'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '  الرجاء ادخال مدة بالارقام';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitForm,
                    child: Text('اضافة العلومات'),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// كلاس للمتغيرات وجلب معلومات المواد
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
