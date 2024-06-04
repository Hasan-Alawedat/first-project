
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';
import 'package:untitled34/project/signin.dart';

// الكلاس الرئيسي للواجهة
class AddBook extends StatefulWidget {
  @override
  State<AddBook> createState() => _BookUploaderState();
}

// كلاس للمتغيرات المستخدمة
class _BookUploaderState extends State<AddBook> {
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  double? _selectedFileSize;
  bool _isUploading = false;
  String _uploadMessage = '';
  List<Subject> _subjects = [];
  String? _selectedSubjectName;
  int? _selectedSubjectId;
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _pagesNumberController = TextEditingController();

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

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty && result.files.single.bytes != null) {
        setState(() {
          _selectedFileBytes = result.files.single.bytes;
          _selectedFileName = result.files.single.name;
          _selectedFileSize = result.files.single.size / (1024 * 1024);
        });
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> _uploadBook() async {
    if (_selectedFileBytes == null || _selectedSubjectId == null || _bookNameController.text.isEmpty || _descriptionController.text.isEmpty || _pagesNumberController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    final uploadUrl = Uri.parse('http://127.0.0.1:8000/api/store-book/$_selectedSubjectId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      var request = http.MultipartRequest('POST', uploadUrl)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['book_name'] = _bookNameController.text
        ..fields['description'] = _descriptionController.text
        ..fields['pages_number'] = _pagesNumberController.text
        ..files.add(http.MultipartFile.fromBytes(
          'book_file',
          _selectedFileBytes!,
          filename: _selectedFileName,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _uploadMessage = 'تم رفع الكتاب بنجاح';
        });
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        showResponseDialog('الرجاء الانتظار لحظة');

      } else {
        setState(() {
          _uploadMessage = 'فشل رفع الكتاب';
        });
      }
    } catch (e) {
      setState(() {
        _uploadMessage = 'حدث خطأ أثناء رفع الكتاب: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void showResponseDialog(String responseMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: Text(responseMessage),
          actions: [
            Text(''),
          ],
        );
      },
    );
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
                    _selectedFileName != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الملف المختار : $_selectedFileName',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'حجم الملف : ${_selectedFileSize!.toStringAsFixed(2)} ميغابايت',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                        : Text(
                      'لم يتم اختيار أي ملف',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _bookNameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الكتاب',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'الوصف',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _pagesNumberController,
                      decoration: InputDecoration(
                        labelText: 'عدد الصفحات',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
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
                      _isUploading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _uploadBook,
                        child: Text('رفع الكتاب'),
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
