import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/register_admin.dart';
import 'package:untitled34/project/add_video.dart';
import 'package:untitled34/project/add_file.dart';
import 'package:untitled34/project/add_teacher.dart';
import 'package:untitled34/project/show_files.dart';
import 'package:untitled34/project/show_subjects.dart';
import 'package:untitled34/project/show_teachers.dart';
import 'package:untitled34/project/signin.dart';
import 'package:untitled34/project/add_subject.dart';
import 'add_book.dart';
import 'add_photo.dart';
class Login extends StatefulWidget {

  Login();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }
  String _responseMessage = '';

  Future<void> _makeApiCall() async {
    var token = await getToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/logout/admin'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _responseMessage = 'Status: ${data['status']}, Message: ${data['message']}';
      });
    } else {
      setState(() {
        _responseMessage = 'Request failed with status: ${response.statusCode}';
      });
    }
  }

  bool notify = false;
  bool night = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(children: [
        Row(
mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container( decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12)),
                width: 200,
                height: 25,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "  بحث",
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.search,color: Colors.black,)
                  ),
                ),),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  size: 30,
                  color: Colors.blue,
                )),
            Text("     "),
          ],
        ),
       Row(children: [
         Expanded(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 1),
             child: Container( decoration: BoxDecoration(
                 color: Colors.black12,
                 borderRadius: BorderRadius.circular(3)),
               width: 700 ,
               height: 672,
               child:       ListView(
                 scrollDirection: Axis.horizontal,
                 children: [
                   Container(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [

                         SizedBox(height: 100,),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [

                             SizedBox(width: 200,),
                             // معلمين
                             ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.white,),

                               onPressed: (){
                                 Navigator.push(
                                   context, MaterialPageRoute(builder: (context) {
                                   return Teachers();
                                 }),);
                               },
                               child:  Container(
                                   decoration: BoxDecoration(
                                   ),
                                   width: 200,
                                   height: 200,
                                   child:
                                   Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(Icons.account_box_outlined,color: Colors.amber,),
                                       Text("المعلمين",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),)
                                     ],)
                               ),
                             ),

                             SizedBox(width: 100,),
                             // مواد
                             ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.white,),
                               onPressed: (){
                                 Navigator.push(
                                   context, MaterialPageRoute(builder: (context) {
                                   return SubjectsScreen();
                                 }),);
                               },
                               child: Container( decoration: BoxDecoration(
                               ),
                                   width: 200,
                                   height: 200,
                                   child:
                                   Column(
                                     mainAxisAlignment: MainAxisAlignment.center,

                                     children: [
                                       Icon(Icons.file_copy,color: Colors.deepPurple,),
                                       Text("المواد",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),)
                                     ],
                                   )
                               ),


                             ),

                             SizedBox(width: 100,),

                             ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.white,),
                               onPressed: (){},
                               child:  Container( decoration: BoxDecoration(
                               ),
                                   width: 200,
                                   height: 200,
                                   child:
                                   Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(Icons.supervised_user_circle,color:Colors.yellow,),

                                       Text("المستخدمين",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),)
                                     ],
                                   )

                               ),
                             ),


                           ],
                         ),

                         SizedBox(height: 100,),


                       ],
                     ),
                   ),
                 ],
               )

             ),
           ),
         ),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 1),
           child: Container( decoration: BoxDecoration(
               color: Colors.black12,
               borderRadius: BorderRadius.circular(3)),
             width: 250,
             height: 672,
             child:
           Column(children: [

             SizedBox(height: 20,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return AddTeacher();
                 }),);
               },
               splashColor: Colors.cyan,
               child:  Container( decoration: BoxDecoration(
                       ),
                       width: 230,
                       height: 60,
                       child:
                       Row(
                         children: [
                           SizedBox(width: 15,),
                           Icon(Icons.person_add,color: Colors.deepOrange,size: 40,),
                           Text("   إضافة معلومات معلم",style: TextStyle(color: Colors.black,fontSize: 18),),
                         ],
                       )
               ),
             ),
             SizedBox(height: 5,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return AddFile();

                 }),);
               },
               splashColor: Colors.cyan,
               child: Container( decoration: BoxDecoration(
                 ),
                     width: 230,
                     height: 60,
                     child:
                     Row(
                       children: [
                         SizedBox(width: 15,),
                         Icon(Icons.file_upload,color: Colors.green,size: 40,),
                         Text("   رفع ملف",style: TextStyle(color: Colors.black,fontSize: 18),),
                       ],
                     )
                 ),


             ),
             SizedBox(height: 5,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return AddImageScreen();

                 }),);

               },
               splashColor: Colors.cyan,
               child: Container( decoration: BoxDecoration(
               ),
                   width: 230,
                   height: 60,
                   child:
                   Row(
                     children: [
                       SizedBox(width: 15,),
                       Icon(Icons.image,color: Colors.purple,size: 40,),
                       Text("   رفع صورة",style: TextStyle(color: Colors.black,fontSize: 18),),
                     ],
                   )
               ),


             ),
             SizedBox(height: 5,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return AddBook();

                 }),);
               },
               splashColor: Colors.cyan,
               child: Container( decoration: BoxDecoration(
               ),
                   width: 230,
                   height: 60,
                   child:
                   Row(
                     children: [
                       SizedBox(width: 15,),
                       Icon(Icons.file_copy_sharp,color: Colors.amber,size: 40,),
                       Text("   رفع كتاب",style: TextStyle(color: Colors.black,fontSize: 18),),
                     ],
                   )
               ),


             ),
             SizedBox(height: 5,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return AddVideo();
                 }),);
               },
               splashColor: Colors.cyan,
               child:  Container( decoration: BoxDecoration(
                 ),
                     width: 230,
                     height: 60,
                     child:
                     Row(
                       children: [
                         SizedBox(width: 15,),
                         Icon(Icons.video_call,color: Colors.blue,size: 40,),
                         Text("   رفع فيديو",style: TextStyle(color: Colors.black,fontSize: 18),),
                       ],
                     )
                 ),


             ),
             SizedBox(height: 5,),
             MaterialButton(
               onPressed: (){},
               splashColor: Colors.cyan,
               child: Container( decoration: BoxDecoration(
                 ),
                     width: 230,
                     height: 60,
                     child:
                     Row(
                       children: [
                         SizedBox(width: 15,),
                         Icon(Icons.question_mark,color: Colors.red,size: 40,),
                         Text("   انشاء سبر",style: TextStyle(color: Colors.black,fontSize: 18),),
                       ],
                     )


               ),
             ),
             SizedBox(height: 5,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return AddSubjest();
                 }),);
               },
               splashColor: Colors.cyan,
               child: Container( decoration: BoxDecoration(
               ),
                   width: 230,
                   height: 60,
                   child:
                   Row(
                     children: [
                       SizedBox(width: 15,),
                       Icon(Icons.subject,color: Colors.pinkAccent,size: 40,),
                       Text("   اضافة مادة ",style: TextStyle(color: Colors.black,fontSize: 18),),
                     ],
                   )
               ),
             ),
             SizedBox(height: 5,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return RegisterAdmin();
                 }),);
               },
               splashColor: Colors.cyan,
               child:  Container( decoration: BoxDecoration(
               ),
                   width: 230,
                   height: 60,
                   child:
                   Row(
                     children: [
                       SizedBox(width: 15,),
                       Icon(Icons.person_add,color: Colors.deepOrange,size: 40,),
                       Text("   انشاء حساب معلم",style: TextStyle(color: Colors.black,fontSize: 18),),
                     ],
                   )
               ),
             ),
           SizedBox(height: 50,),
             TextButton(
               onPressed: (){

                   showDialog(context: context, builder: (context){
                     return AlertDialog(
                       title: Text("تسجيل خروج"),
                       content: Text("هل انت متأكد من تسجيل الخروج"),
                       actions: [
                         TextButton(
                           onPressed: () async {
                             await _makeApiCall();
                             Navigator.of(context).pushAndRemoveUntil(
                               MaterialPageRoute(builder: (context) => Signin()),
                                   (Route<dynamic> route) => false,
                             );
                           },
                           child: Text("نعم"),
                         ),
                         TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("لا")),

                       ],
                     );
                   });

               },
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Container( decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10)),
                     width: 230,
                     height: 60,
                     child:
                     Row(
                       children: [
                         SizedBox(width: 15,),
                         Icon(Icons.logout,color: Colors.brown,size: 14,),
                         Text("   تسجيل خروج",style: TextStyle(color: Colors.black,fontSize: 15),),
                       ],
                     )
                 ),
               ),
             ),

           ],)
           ),
         ),
         SizedBox(width: 2,),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 1),
           child: Container( decoration: BoxDecoration(
               color: Colors.purple,
               borderRadius: BorderRadius.circular(3)),
             width: 1,
             height: 672,
             child:Text(""),),),
         SizedBox(width: 3,),

       ],)
      ],)
    );
  }
}
