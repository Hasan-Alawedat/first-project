
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled34/project/home.dart';
import 'package:untitled34/project/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


//  الكلاس الرئيسي
class Signin extends StatefulWidget {
  Signin({super.key});
  @override

  State<Signin> createState() => AdminState();
}

// كلاس api
class AdminState extends State<Signin> {
  bool secur = true ;
  // الكونترولات
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


// تابع لل api
  Future<void> signin() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/login/admin');
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"};
    Map<String, dynamic> body = {
      "email": emailController.text,
      "password": passwordController.text,
    };


// معالجة الاخطاء
    // في تابع signin()
    try {
      final response = await http.post(url, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('تم تسجيل الدخول بنجاح: ${response.body}');
        final token = json.decode(response.body)['access_token'];
        await saveToken(token);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
        // بعد تحديث حالة تسجيل الدخول، قم بتوجيه المستخدم إلى الصفحة التالية
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      } else if (response.statusCode != 200) {
        print('حدث خطأ: ${response.body}');
        showResponseDialog(json.decode(response.body)['message']);
      }
    } catch (e) {
      showResponseDialog('خطأ في الاتصال');
      print('حدث خطأ في الاتصال: $e');
    }



    // تابع الاحتفاظ بالتوكين ومشاركته
  } Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

// تابع رسالة الخطأ
  void showResponseDialog(String responseMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رسالة  '),
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
  void initState() {
    super.initState();
  }



  Widget build(BuildContext context) {
    return Scaffold(
      body:  (ListView(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "مرحباً",
                      style: TextStyle(fontSize: 40, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          Text(
                            "A",
                            style: TextStyle(fontSize: 30, color: Colors.red),
                          ),
                          Text(
                            "O",
                            style: TextStyle(fontSize: 30, color: Colors.green),
                          ),
                          Text(
                            "T",
                            style: TextStyle(fontSize: 30, color: Colors.indigo),
                          ),
                          Text(
                            "H ",
                            style:
                                TextStyle(fontSize: 30, color: Colors.yellow),
                          ),
                          Text(
                            "  سجل الدخول الى حسابك على",
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 4,
                      width: 300,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 500,
                      height: 350,
                      color: Colors.black12,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25 ,vertical: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "     البريد الإلكتروني ",
                                    suffixIcon:
                                        Icon(Icons.account_circle_outlined)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                obscureText: secur,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "    كلمة السر",
                                  suffixIcon: IconButton(
                                    icon: Icon(secur ? Icons.visibility_off : Icons.visibility),
                                    onPressed: (
                                        ){
                                      setState(() {
                                        secur = !secur;
                                      });
                                    },
                                  )
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                           Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: signin,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                                ),
                                child: Text('       دخول        ', style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context, MaterialPageRoute(builder: (context) {
                                        return Register();
                                      }),);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.blue,
                                    ),
                                    child: Text('إنشاء حساب', style: TextStyle(fontSize: 14)),
                                  ),
                                  Text("لا تملك حساب ؟ "),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),

    );
  }
}
