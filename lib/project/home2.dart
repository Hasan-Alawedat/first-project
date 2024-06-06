import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled34/project/show_subjects.dart';
import 'package:untitled34/project/show_teachers.dart';

class Home2 extends StatefulWidget{
  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

        ),
      ),
    );
  }
}