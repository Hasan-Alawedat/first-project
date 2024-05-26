import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// الكلاس الرئيسي للواجهة

class AddVideo extends StatefulWidget {
  @override
  State<AddVideo> createState() => _FileUploaderState();
}

//كلاس للمتغيرات المستخدمة
class _FileUploaderState extends State<AddVideo> {
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  double? _selectedFileSize; // لإضافة حجم الملف
  bool _isUploading = false;
  String _uploadMessage = '';
  List<Subject> _subjects = [];
  String? _selectedSubjectName;
  int? _selectedSubjectId;

  // تحديث الواجهة
  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  // تابع جلب البيانات للقائمة المنسدلة
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

  // تابع فظ id  للمادة التي تم اختيارها
  void _onSubjectSelected(String? selectedName) {
    final selectedSubject = _subjects.firstWhere((subject) => subject.subjectName == selectedName);
    setState(() {
      _selectedSubjectName = selectedName;
      _selectedSubjectId = selectedSubject.id;
    });
  }


  // تابع لاضافة الفيديو بالصيغ المختارة وحفظ اسمه وحجمه
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'avi', 'mov'],
      );
      if (result != null && result.files.isNotEmpty && result.files.single.bytes != null) {
        setState(() {
          _selectedFileBytes = result.files.single.bytes;
          _selectedFileName = result.files.single.name;
          _selectedFileSize = result.files.single.size / (1024 * 1024); // تحويل الحجم إلى ميغابايت
          print('File selected: $_selectedFileName, Size: $_selectedFileSize MB'); // Debug print
        });
      } else {
        print('No file selected or bytes are null'); // Debug print
      }
    } catch (e) {
      print('Error picking file: $e'); // Debug print
    }
  }


  Future<void> _uploadFile() async {
    if (_selectedFileBytes == null) return;

    setState(() {
      _isUploading = true;
    });
// تعديل الرابط للفيديو بعد اختياره
    final uploadUrl = Uri.parse('http://example.com/upload');

    try {
      var request = http.MultipartRequest('POST', uploadUrl)
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          _selectedFileBytes!,
          filename: _selectedFileName,
        ));
      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _uploadMessage = 'تم رفع الفيديو بنجاح';
        });
      } else {
        setState(() {
          _uploadMessage = 'فشل رفع الفيديو';
        });
      }
    } catch (e) {
      setState(() {
        _uploadMessage = 'حدث خطأ أثناء رفع الفيديو: $e';
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
                      child: Text('اختر فيديو'),
                    ),
                    SizedBox(height: 20),
                    _selectedFileName != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الفيديو المختار: $_selectedFileName',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'حجم الفيديو: ${_selectedFileSize!.toStringAsFixed(2)} ميغابايت',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                        : Text(
                      'لم يتم اختيار أي فيديو',
                      style: TextStyle(fontSize: 16, color: Colors.red),
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
                      SizedBox(height: 20),
                      _isUploading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _uploadFile,
                        child: Text('رفع الفيديو'),
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

// كلاس للمتغيرات لاستخدامها وحفظها
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
