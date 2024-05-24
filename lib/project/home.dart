import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled34/project/register_admin.dart';
import 'package:untitled34/test%20screen/add_file.dart';
import 'package:untitled34/project/add_teacher.dart';
import 'package:untitled34/test%20screen/add_video.dart';
import 'package:untitled34/project/signin.dart';
import 'package:untitled34/project/home2.dart';
import 'package:untitled34/project/add_subject.dart';

class Login extends StatefulWidget {

  Login();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool notify = false;
  bool night = false;
  @override
  Widget build(BuildContext context) {

    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Row(
          children: [
            isDesktop
                ? Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                "A",
                                style: TextStyle(color: Colors.red, fontSize: 35,fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "O",
                                style: TextStyle(color: Colors.purple, fontSize: 35,fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "T",
                                style: TextStyle(color: Colors.green, fontSize: 35,fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "H",
                                style: TextStyle(color: Colors.yellow, fontSize: 35,fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  )
                : Container(),
            Expanded(child: Text("")),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container( decoration: BoxDecoration(
                      color: Colors.white,
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
                )
              ],
            ),
            Expanded(child: Text("")),
            Container(
              child: Row(
                children: [
                  Container(
                    color: Color(0xff3379Bf),
                    width: 3,
                    height: 25,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications,
                            size: 25,
                            color: Colors.black,
                          )),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer:

      Drawer(
        backgroundColor: Colors.white,

        child: Column(children: [
UserAccountsDrawerHeader(
    decoration: BoxDecoration(color: Colors.black38),
    accountName: Center(child: Text(" الاعدادات ",style: TextStyle(fontSize: 31,fontWeight: FontWeight.w900),)), accountEmail: Text("")),

          ListTile(
            title: Text("   الاشعارات"),
            leading: Switch(value:notify , onChanged: (val){
              setState(() {
                notify = val;
              });

            }),
            onTap: (){},
          ), ListTile(
            title: Text("   الوضع المظلم"),
            leading: Switch(value:night , onChanged: (val){
              setState(() {
                night = val;
              });

            }),
            onTap: (){},
          ),
          ListTile(
            title: Text(" كلمة السر"),
            leading: Icon(Icons.lock_open_outlined,color: Colors.deepPurple,),
            onTap: (){},
          ),
          ListTile(
            title: Text(" اللغة"),
            leading: Icon(Icons.language,color: Colors.deepPurple,),
            onTap: (){},
          ),

          ListTile(
            title: Text(" تواصل معنا"),
            leading: Icon(Icons.phone,color: Colors.deepPurple,),
            onTap: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("رقم المطور "),
                  content: Text("+(963)997 119 361"),
                  actions: [ TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("حسنا")),

                  ],
                );
              });
            },
          ),
          ListTile(
            title: Text(" مركز المساعدة"),
            leading: Icon(Icons.help_outline,color: Colors.deepPurple,),
            onTap: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("علاوي حبيب قلبي "),
                  content: Text("ربك بساعد الجميع"),
                  actions: [ TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("حسنا")),

                  ],
                );
              });
            },
          ),
        ],),
      ),

      body: ListView(children: [
       Row(children: [
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 1),
           child: Container( decoration: BoxDecoration(
               color: Colors.black12,
               borderRadius: BorderRadius.circular(3)),
             width: 250,
             height: 672,
             child:
           Column(children: [

             SizedBox(height: 40,),
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
             SizedBox(height: 20,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return FileUploader('/path/to/your/file');

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
             SizedBox(height: 20,),
             MaterialButton(
               onPressed: (){
                 Navigator.push(
                   context, MaterialPageRoute(builder: (context) {
                   return Video();
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
             SizedBox(height: 20,),
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
             SizedBox(height: 20,),
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
             SizedBox(height: 20,),
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
           SizedBox(height: 100,),
             TextButton(
               onPressed: (){

                   showDialog(context: context, builder: (context){
                     return AlertDialog(
                       title: Text("تسجيل خروج"),
                       content: Text("هل انت متأكد من تسجيل الخروج"),
                       actions: [
                         TextButton(onPressed: (){
                           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Signin();}));
                         }, child: Text("نعم")),
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
         Padding(
         padding: const EdgeInsets.symmetric(horizontal: 1),
         child: Container( decoration: BoxDecoration(
         color: Colors.purple,
         borderRadius: BorderRadius.circular(3)),
         width: 1,
         height: 672,
         child:Text(""),),),
         SizedBox(width: 2,),
         Expanded(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 1),
             child: Container( decoration: BoxDecoration(
                 color: Colors.black12,
                 borderRadius: BorderRadius.circular(3)),
                 width: 700 ,
                 height: 672,
                 child: Home(),
           ),
           ),
         ),
         SizedBox(width: 3,),

       ],)
      ],)
    );
  }
}
