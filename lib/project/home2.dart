import 'dart:async';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled34/project/show_subjects.dart';
import 'package:untitled34/test%20screen/remember.dart';
import 'package:untitled34/project/show_teachers.dart';
import 'package:untitled34/test%20screen/videos.dart';

import '../test screen/add_video.dart';
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override

  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1000;
    return Scaffold(
backgroundColor: Colors.white70,
      body:
       ListView(
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
                onPressed: (){
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) {
                    return Videos();
                  }),);
                },
                child:  Container( decoration: BoxDecoration(
                     ),
                        width: 200,
                        height: 200,
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.ondemand_video,color: Colors.blue,),

                            Text("الفيديوهات",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),)
                          ],
                        )
                    ),
                  ),
      ],
    ),

                  SizedBox(height: 100,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 200,),

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
                                  Icon(Icons.menu_book_outlined,color: Colors.red,),

                                  Text("خطة  درسية",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),)
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

                      SizedBox(width: 100,),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,),
                        onPressed: (){},
                        child: Container( decoration: BoxDecoration(
                        ),
                              width: 200,
                              height: 200,
                              child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.notification_important_outlined,color: Colors.green,),

                                  Text("  الاشعارات المرسلة",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),)
                                ],
                              )
                          ),
                      ),
                    ],
                  ),

                ],
              ),
           ),
         ],
       )


    );
  }
}
