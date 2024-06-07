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
            _message = "لا يوجد صور لعرضها";
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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _deleteImage(int id) async {
    setState(() {
      _isLoading = true;
    });

    final token = await _getToken();

    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
        _message = 'Error: Access token is null or empty';
      });
      print('Error: Access token is null or empty');
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/deletePhoto/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json', // تأكد من إضافة مفتاح Accept
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            _images.removeWhere((image) => image.id == id); // Remove the deleted image from the list
            _message = jsonResponse['message'];
          });
        } else {
          setState(() {
            _message = 'Failed to delete image.';
          });
        }
      } else {
        setState(() {
          _message = 'Failed to delete image. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error deleting image: $e';
      });
      print('Error deleting image: $e'); // نقطة تصحيح
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isDesk ? Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.person, color: Colors.blueGrey,
                  ), onPressed: () {},),

                SizedBox(width: 600,),
              ],
            ) : Container(),

            isDesktop ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12)),
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notification_important, color: Colors.blueGrey,
                          ), onPressed: () {},),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Container(decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12)),
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.forward_to_inbox, color: Colors.blueGrey,
                          ), onPressed: () {

                        },),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12)),
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.home, color: Colors.blueGrey,
                          ), onPressed: () {
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

              ],
            ) : Container(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Container(decoration: BoxDecoration(
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
                        Icons.search_rounded, color: Colors.black12,
                      ), onPressed: () {},),
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
          return ImageCard(
            image: image,
            onView: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageViewerScreen(imageUrl: image.url),
                ),
              );
            },
            onDelete: () {
              _deleteImage(image.id);
            },
          );
        },
      )
          : Center(child: Text(_message)),
    );
  }
}

class ImageCard extends StatelessWidget {
  final ImageModel image;
  final VoidCallback onView;
  final VoidCallback onDelete;

  ImageCard({required this.image, required this.onView, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.image, color: Colors.blue, size: 40),
              title: Text(
                image.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              subtitle: Text(
                image.url,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey[300],
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.visibility, color: Colors.green, size: 30),
                onPressed: onView,
              ),
            ),
            SizedBox(height: 8),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 30),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
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
