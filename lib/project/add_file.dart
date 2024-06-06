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
class AddFile extends StatefulWidget {
  @override
  State<AddFile> createState() => _FileUploaderState();
}

// كلاس للمتغيرات المستخدمة
class _FileUploaderState extends State<AddFile> {
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  double? _selectedFileSize; // لإضافة حجم الملف
  bool _isUploading = false;
  String _uploadMessage = '';
  List<Subject> _subjects = [];
  String? _selectedSubjectName;
  int? _selectedSubjectId;
  TextEditingController _fileNameController = TextEditingController(); // متغير لإدارة حقل النص

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
    if (_selectedFileBytes == null || _selectedSubjectId == null || _fileNameController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    final uploadUrl = Uri.parse('http://127.0.0.1:8000/api/storePdf/$_selectedSubjectId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      var request = http.MultipartRequest('POST', uploadUrl)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['file_name'] = _fileNameController.text // استخدام اسم الملف المدخل من قبل المستخدم
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          _selectedFileBytes!,
          filename: _selectedFileName,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _uploadMessage = 'تم رفع الملف بنجاح';
        });
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        showResponseDialog('الرجاء الانتظار لحظة');

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
    final isDesktop = MediaQuery.of(context).size.width >= 829;
    final isDesk = MediaQuery.of(context).size.width >= 1470;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            Row(

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
                  SizedBox(width: 300,),

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
            Divider(color: Colors.black12,),
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
                      controller: _fileNameController, // ربط حقل النص بالمتغير
                      decoration: InputDecoration(
                        labelText: 'اسم الملف',
                        border: OutlineInputBorder(),
                      ),
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
