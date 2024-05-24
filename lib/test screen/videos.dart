import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Videos extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title:
        Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
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

          ],
        ),

      ),
      body: Container(color: Colors.cyan,),
    );
  }


}