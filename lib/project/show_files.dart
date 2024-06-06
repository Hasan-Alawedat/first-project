import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:untitled34/project/home.dart';

class PdfList extends StatefulWidget {
  final int subjectId;

  PdfList({required this.subjectId});

  @override
  _PdfListState createState() => _PdfListState();
}

class _PdfListState extends State<PdfList> {
  List<Pdf> _pdfs = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchPdfs();
  }

  Future<void> _fetchPdfs() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('http://127.0.0.1:8000/api/retrivePdf/admin/${widget.subjectId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            _pdfs = (jsonResponse['data'] as List)
                .map((pdfJson) => Pdf.fromJson(pdfJson))
                .toList();
            _message = "لا يوجد ملفات لعرضها";
          });
        } else {
          setState(() {
            _message = 'Failed to retrieve PDFs.';
          });
        }
      } else {
        setState(() {
          _message = 'Failed to retrieve PDFs. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error fetching PDFs: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 829;
    final isDesk = MediaQuery.of(context).size.width >= 1470;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _pdfs.isNotEmpty
            ? ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: _pdfs.length,
          itemBuilder: (context, index) {
            final pdf = _pdfs[index];
            return Card(
              child: ListTile(
                title: Text(pdf.name),
                subtitle: Text(pdf.url),
                trailing: IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(pdfUrl: pdf.url),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        )
            : Center(child: Text(_message)),
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PdfViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}

class Pdf {
  final int id;
  final int subjectId;
  final String name;
  final String url;

  Pdf({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.url,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      id: json['id'],
      subjectId: int.parse(json['subject_id']),
      name: json['name'],
      url: json['url'],
    );
  }
}
