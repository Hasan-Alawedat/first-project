import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';

class ImageList extends StatefulWidget {
  final int subjectId;

  ImageList({required this.subjectId});

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<ImageModel> _images = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('http://127.0.0.1:8000/api/retriveTHEPlanes/admin/${widget.subjectId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Response: $jsonResponse'); // Log the response
        if (jsonResponse['status'] == true) {
          setState(() {
            _images = (jsonResponse['data'] as List)
                .map((imageJson) => ImageModel.fromJson(imageJson))
                .toList();
            _message = jsonResponse['message'];
          });
        } else {
          setState(() {
            _message = 'Failed to retrieve images.';
          });
        }
      } else {
        setState(() {
          _message = 'Failed to retrieve images. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error fetching images: $e';
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _images.isNotEmpty
          ? ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final image = _images[index];
          return Card(
            child: ListTile(
              title: Text(image.name),
              subtitle: Text(image.url),
              trailing: IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(imageUrl: image.url),
                    ),
                  );
                },
              ),
            ),
          );
        },
      )
          : Center(child: Text(_message)),
    );
  }
}

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  ImageViewerScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            print('Error: $error'); // Log the error
            return Center(child: Text('Failed to load image'));
          },
        ),
      ),
    );
  }
}

class ImageModel {
  final int id;
  final int subjectId;
  final String name;
  final String url;

  ImageModel({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: int.parse(json['id'].toString()), // Convert to int
      subjectId: int.parse(json['subject_id'].toString()), // Convert to int
      name: json['name'],
      url: json['url'],
    );
  }
}
