import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/register_admin.dart';
import 'package:untitled34/project/add_video.dart';
import 'package:untitled34/project/add_file.dart';
import 'package:untitled34/project/add_teacher.dart';
import 'package:untitled34/project/show_admins.dart';
import 'package:untitled34/project/show_files.dart';
import 'package:untitled34/project/show_profile.dart';
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
    final isDesktop = MediaQuery.of(context).size.width >= 829;
    final isDesk = MediaQuery.of(context).size.width >= 1470;

    return Scaffold(

    body: ListView(children: [
        Row(

mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isDesk?Row(children: [
              Row(
                children: [
                  IconButton(
                      icon: const Icon(

                        Icons.account_circle_sharp
                        ,color: Colors.blueGrey,
                      ),onPressed: (){
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }),);
                  },),
                  Text("تفاصيل الملف الشخصي")
                ],
              ),

              SizedBox(width: 470,),
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
                                       Icon(Icons.supervised_user_circle,color:Colors.deepOrange,),

                                       Text("المستخدمين",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),)
                                     ],
                                   )

                               ),
                             ),


                           ],
                         ),

                         // لعرض معلومات المستخدمين
                         Row(children: [
                           Container(),
                           Container(),

                         ],),

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
               color: Colors.white70,
               borderRadius: BorderRadius.circular(3)),
             width: 230,
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
                       height: 40,
                       child:
                       Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           Text("   إضافة معلومات معلم",style: TextStyle(color: Colors.black,fontSize: 16),),
                           SizedBox(width: 15,),

                           Icon(Icons.person,color: Colors.brown,size: 27,),

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
                     height: 40,
                     child:
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [

                         Text("   رفع ملف",style: TextStyle(color: Colors.black,fontSize: 16),),
                         SizedBox(width: 15,),
                         Icon(Icons.file_upload,color: Colors.green,size: 27,),
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
                   height: 40,
                   child:
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [

                       Text("   رفع صورة",style: TextStyle(color: Colors.black,fontSize: 16),),
                       SizedBox(width: 15,),
                       Icon(Icons.image,color: Colors.purple,size: 27,),
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
                   height: 40,
                   child:
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [

                       Text("   رفع كتاب",style: TextStyle(color: Colors.black,fontSize: 16),),
                       SizedBox(width: 15,),
                       Icon(Icons.file_copy_sharp,color: Colors.amber,size: 27,),
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
                     height: 40,
                     child:
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [

                         Text("   رفع فيديو",style: TextStyle(color: Colors.black,fontSize: 16),),
                         SizedBox(width: 15,),
                         Icon(Icons.video_call,color: Colors.blue,size: 27,),
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
                     height: 40,
                     child:
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [

                         Text("   انشاء سبر",style: TextStyle(color: Colors.black,fontSize: 16),),
                         SizedBox(width: 15,),
                         Icon(Icons.question_mark,color: Colors.red,size: 27,),
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
                   height: 40,
                   child:
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [

                       Text("   اضافة مادة ",style: TextStyle(color: Colors.black,fontSize: 16),),
                       SizedBox(width: 15,),
                       Icon(Icons.subject,color: Colors.pinkAccent,size: 27,),
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
                   height: 40,
                   child:
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [

                       Text("   انشاء حساب معلم",style: TextStyle(color: Colors.black,fontSize: 16),),
                       SizedBox(width: 15,),
                       Icon(Icons.person_add,color: Colors.deepOrange,size: 27,),
                     ],
                   )
               ),
             ),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return Admins();
                 }),);
               },
               splashColor: Colors.cyan,
               child:  Container( decoration: BoxDecoration(
               ),
                   width: 230,
                   height: 40,
                   child:
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [

                       Text(" الأدوار بالموقع ",style: TextStyle(color: Colors.black,fontSize: 16),),
                       SizedBox(width: 15,),
                       Icon(Icons.admin_panel_settings,color: Colors.cyan,size: 27,),
                     ],
                   )
               ),
             ),

             SizedBox(height: 5,),

             Container(
               height: 200,
             ),

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
                     height: 40,
                     child:
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [

                         Text("   تسجيل خروج",style: TextStyle(color: Colors.black,fontSize: 13),),
                         SizedBox(width: 15,),
                         Icon(Icons.logout,color: Colors.brown,size: 12,),
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
