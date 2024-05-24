
import 'package:flutter/material.dart';
import 'package:untitled34/project/signin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// الكلاس الرئيسي
class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _AdminState();
}

// كلاس api
class _AdminState extends State<Register> {
  final TextEditingController registerFirstNameController = TextEditingController();
  final TextEditingController registerLastNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPhoneController = TextEditingController();
  final TextEditingController registerPassController = TextEditingController();
  final TextEditingController registerConfPassController = TextEditingController();
  @override
  void dispose() {
    registerFirstNameController.dispose();
    registerLastNameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerPassController.dispose();
    registerConfPassController.dispose();
    super.dispose();
  }

  // تابع api
  Future<void> postData() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/registration/super_admin');
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    Map<String, dynamic> body = {
      "first_name": registerFirstNameController.text,
      "last_name": registerLastNameController.text,
      "email": registerEmailController.text,
      "password": registerPassController.text,
      "password_confirmation": registerConfPassController.text,
      "phone_no": registerPhoneController.text
    };

    try {
      final response = await http.post(url, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        print('تم الإرسال بنجاح: ${response.body}');

        Navigator.push(
          context, MaterialPageRoute(builder: (context) {
          return Signin();
        }),);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),);

      } else if ( response.statusCode != 200) {
        print('حدث خطأ: ${response.body}');
        showResponseDialog(json.decode(response.body)['message']);

      }
    } catch (e) {
      print('حدث خطأ في الاتصال: $e');
      showResponseDialog('خطأ في الاتصال');

    }
  }

  //  تابع لعرض رسالة الخطأ
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        style: TextStyle(fontSize: 30, color: Colors.purple),
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
                        "  سجل حسابك الأن على",
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
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 500,
                  height: 500,
                  color: Colors.black12,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                       Row(
                         mainAxisAlignment:MainAxisAlignment.center,
                         children: [
                           Container(
                             width: 200,
                             height: 50,
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(5)),
                             child: TextField(
                               controller: registerLastNameController,
                               decoration: InputDecoration(
                                   border: InputBorder.none,
                                   labelText: "    الأسم الأخير ",

                               ),
                             ),

                           ),
                           SizedBox(width: 40,),
                           Container(
                             width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                controller: registerFirstNameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "    الأسم الأول ",

                                ),
                              ),

                      ),
                         ],
                       ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(

                            controller: registerPhoneController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "    رقم الهاتف  ",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(

                            controller: registerEmailController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "    البريد الإلكتروني ",

                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(

                            controller: registerPassController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "     كلمة السر",

                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(

                            controller: registerConfPassController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "    أعد كتابة كلمة السر",

                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: postData,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                            ),
                            child: Text('       إنشاء        ', style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Signin();}));
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                child: Text(' تسجيل دخول', style: TextStyle(fontSize: 14)),
                              ),
                              Text("لديك حساب ؟ "),

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
