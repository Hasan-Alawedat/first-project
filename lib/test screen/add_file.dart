import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../project/add_teacher.dart';

class FileUploader extends StatefulWidget {
  FileUploader(String s);

  @override
  State<FileUploader> createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  late File _selectedFile;
  bool _isUploading = false;
  late String _uploadMessage;
  List<Subject> _subjects = [];
  String? _selectedSubjectName;
  int? _selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    _selectedFile = File('');
    _uploadMessage = '';
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile.path.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    final uploadUrl = Uri.parse('http://example.com/upload');

    try {
      var request = http.MultipartRequest('POST', uploadUrl)
        ..files.add(await http.MultipartFile.fromPath('file', _selectedFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _uploadMessage = 'تم رفع الملف بنجاح';
        });
      } else {
        setState(() {
          _uploadMessage = 'فشل رفع الملف';
        });
      }
    } catch (e) {
      setState(() {
        _uploadMessage = 'حدث خطأ أثناء رفع الملف: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 50),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: Text('اختر ملف PDF'),
                    ),
                    SizedBox(height: 20),
                    _selectedFile.path.isNotEmpty
                        ? Text(
                      'الملف المختار: ${_selectedFile.path.split('/').last}',
                      style: TextStyle(fontSize: 16),
                    )
                        : SizedBox.shrink(),
                    SizedBox(height: 20),
                    _isUploading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _uploadFile,
                      child: Text('رفع الملف'),
                    ),
                    SizedBox(height: 20),
                    _uploadMessage.isNotEmpty
                        ? Text(
                      _uploadMessage,
                      style: TextStyle(
                        color: _uploadMessage.contains('نجاح') ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : SizedBox.shrink(),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("اسم المادة", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800)),
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
                      ],
                    ),
                    if (_selectedSubjectId != null) ...[
                      SizedBox(height: 20),
                      Text(
                        'المادة: $_selectedSubjectName',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
