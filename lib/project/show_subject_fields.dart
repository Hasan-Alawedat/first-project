import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/show_book.dart';
import 'package:untitled34/project/show_files.dart';
import 'package:untitled34/project/show_photo.dart';
import 'package:untitled34/project/show_videos.dart';
import 'package:untitled34/project/home.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final int subjectId;

  SubjectDetailsScreen({required this.subjectId});

  @override
  _SubjectDetailsScreenState createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  Map<String, dynamic>? subjectDetails;

  @override
  void initState() {
    super.initState();
    _fetchSubjectDetails();
  }

  Future<void> _fetchSubjectDetails() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getSub/admin/${widget.subjectId}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody);
      setState(() {
        subjectDetails = responseBody['data'];
      });
    } else {
      print('Failed to load subject details: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 829;
    final isDesk = MediaQuery.of(context).size.width >= 1470;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:             Row(

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
            SizedBox(width: 280,),

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
        automaticallyImplyLeading: false, // هذا يمنع ظهور أيقونة الرجوع التلقائية

      ),
      body: subjectDetails == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildCardWithExpansionTile(
            icon: Icons.video_library,
            title: 'الفيديوهات',
            subtitle: '${subjectDetails!['videos_num'] ?? 'N/A'}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoList(subjectId: widget.subjectId),
                ),
              );
            },
          ),
          _buildCardWithExpansionTile(
            icon:
            Icons.image,
            title: 'الصور',

            subtitle: '${subjectDetails!['photos_num'] ?? 'N/A'}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageList(subjectId: widget.subjectId),
                ),
              );
            },
          ),
          _buildCardWithExpansionTile(
            icon: Icons.file_copy,
            title: 'الملفات',
            subtitle: '${subjectDetails!['files_num'] ?? 'N/A'}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfList(subjectId: widget.subjectId),
                ),
              );
            },
          ),
          _buildCardWithExpansionTile(
            icon: Icons.book,
            title: 'الكتب',

            subtitle: '${subjectDetails!['books_num'] ?? 'N/A'}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookList(subjectId: widget.subjectId),
                ),
              );
            },
          ),
          _buildCardWithExpansionTile(
            icon: Icons.quiz,
            title: 'الاختبارات',
            subtitle: '${subjectDetails!['exams_num'] ?? 'N/A'}',
          ),
        ],
      ),
    );
  }

  Widget _buildCardWithExpansionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap, // إضافة هذا المعامل لاستخدامه في التنقل
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge,),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        onTap: onTap,
      ),
    );
  }
}
