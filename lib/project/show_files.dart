import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
            _message = jsonResponse['message'];
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
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
