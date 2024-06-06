import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';
import 'package:image_picker/image_picker.dart';

class AddImageScreen extends StatefulWidget {
  @override
  _AddImageScreenState createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  double? _selectedImageSize;
  bool _isUploading = false;
  String _uploadMessage = '';
  List<Subject> _subjects = [];
  String? _selectedSubjectName;
  int? _selectedSubjectId;
  TextEditingController _imageNameController = TextEditingController();

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


  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final fileName = pickedFile.path.split('/').last;
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = fileName;
          _selectedImageSize = bytes.lengthInBytes / (1024 * 1024); // Convert size to MB
          print('Image selected: $_selectedImageName, Size: $_selectedImageSize MB');
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }




  Future<void> _uploadImage() async {
    if (_selectedImageBytes == null || _selectedSubjectId == null || _imageNameController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    final uploadUrl = Uri.parse('http://127.0.0.1:8000/api/insertAPlne/$_selectedSubjectId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      var request = http.MultipartRequest('POST', uploadUrl)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['photo_name'] = _imageNameController.text
        ..files.add(http.MultipartFile.fromBytes(
          'photo_file',
          _selectedImageBytes!,
          filename: _selectedImageName,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _uploadMessage = 'تم رفع الصورة بنجاح';
        });
        Timer(Duration(seconds: 2), () {
          // Redirect to another page after 2 seconds (e.g., Home page)
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        });
        showResponseDialog('يرجى الانتظار قليلاً');

      } else {
        setState(() {
          _uploadMessage = 'فشل رفع الصورة';
        });
      }
    } catch (e) {
      setState(() {
        _uploadMessage = 'حدث خطأ أثناء رفع الصورة: $e';
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
    onPressed: _pickImage,
    child: Text('اختر صورة'),
    ),
    SizedBox(height: 20),
    _selectedImageName != null
    ? Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'الصورة المختارة: $_selectedImageName',
    style: TextStyle(fontSize: 16),
    ),
    Text(
    'حجم الصورة: ${_selectedImageSize!.toStringAsFixed(2)} ميغابايت',
    style: TextStyle(fontSize: 16),
    ),
    ],
    )
        : Text(
    'لم يتم اختيار أي صورة',
    style: TextStyle(fontSize: 16, color: Colors.red),
    ),
    SizedBox(height: 20),
    TextField(
    controller: _imageNameController,
    decoration: InputDecoration(
    labelText: 'اسم الصورة',
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
        style: TextStyle(fontSize:  18),
      ),
      _isUploading
          ? CircularProgressIndicator(
        color: Colors.cyan,
        strokeAlign: 1,
        strokeWidth: 2,
        semanticsLabel: "يرجي الانتظار",

      )
          : ElevatedButton(
        onPressed: _uploadImage,
        child: Text('رفع الصورة'),
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

