
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';
import 'signin.dart';
import 'package:untitled34/project/signin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// الكلاس الرئيسي
class RegisterAdmin extends StatefulWidget {
  RegisterAdmin({super.key});

  @override
  State<RegisterAdmin> createState() => _AdminState();
}

// كلاس api
class _AdminState extends State<RegisterAdmin> {
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

  // تابع جلب التوكين
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  // تابع api
  Future<void> postData() async {
    var token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/api/registration/admin');
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"

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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Login();}));
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
// تابع عرض رسالة الخطا
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

  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 829;
    final isDesk = MediaQuery.of(context).size.width >= 1470;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  (ListView(
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
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "مرحباً",
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
                SizedBox(
                  height: 5,
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
                        style: TextStyle(fontSize: 30, color: Colors.white),
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
                        "انشاء حساب معلم على",
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
                  height: 470,
                  color: Colors.black26,
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
                                labelText: "    الاسم الاخير ",

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
                                labelText: "    الاسم الاول ",

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
                              labelText: "    الايميل ",

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
                              labelText: "    اعادة كلمة السر",

                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                          SizedBox(width: 50,),
                          MaterialButton(
                            onPressed: postData,
                            color: Colors.green,
                            splashColor: Colors.cyan,
                            child:  Container( decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                              width: 170,
                              height: 40,
                              child:
                              Center(child: Text("إنشاء",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight:
                              FontWeight.w900),)),



                            ),
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
