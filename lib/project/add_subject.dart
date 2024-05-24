import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';

// الكلاس الرئيسي
class AddSubjest extends StatefulWidget {
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<AddSubjest> {
  final TextEditingController subController = TextEditingController();


  @override
  void dispose() {
    subController.dispose();
    super.dispose();
  }

// تابع جلب التوكين
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }
// تابع api
  Future<void> postData() async {
    var token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/api/addSubject');
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    Map<String, dynamic> body = {
      "subject_name": subController.text,
    };
    try {
      final response = await http.post(url, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['messge'])),
        );

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Login();}));

      }
      else {
        showResponseDialog('البيانات فارغة');
      }
    } catch (e) {
      print('حدث خطأ في الاتصال: $e');
      showResponseDialog('حدث خطأ في الاتصال');


    }
  }

// تابع عرض رسالة الخطأ

  void showResponseDialog(String responseMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رسالة النتيجة'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: subController,
              decoration: InputDecoration(labelText: 'اسم المادة'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: postData,
              child: Text('إنشاء المادة'),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
