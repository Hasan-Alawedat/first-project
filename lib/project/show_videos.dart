import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart'; // استيراد حزمة مشغل الفيديو

// الكلاس الرئيسي للواجهة
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

// كلاس للمتغيرات المستخدمة
class _VideoListState extends State<VideoList> {
  List<Video> _videos = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('http://127.0.0.1:8000/api/getVideos/admin/1');

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
            _videos = (jsonResponse['data'] as List)
                .map((videoJson) => Video.fromJson(videoJson))
                .toList();
            _message = jsonResponse['message'];
          });
        } else {
          setState(() {
            _message = 'Failed to retrieve videos.';
          });
        }
      } else {
        setState(() {
          _message = 'Failed to retrieve videos. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error fetching videos: $e';
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
        appBar: AppBar(
          title: Text('Video List'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _videos.isNotEmpty
            ? ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: _videos.length,
          itemBuilder: (context, index) {
            final video = _videos[index];
            return Card(
              child: ListTile(
                title: Text(video.name),
                subtitle: Text(video.url),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(videoUrl: video.url),
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

// شاشة مشغل الفيديو
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // تحديث حالة الشاشة بعد التهيئة
        _controller.play(); // تشغيل الفيديو تلقائيًا
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // تحرير الموارد عند التخلص من الشاشة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
            _isPlaying = !_isPlaying;
          });
        },
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

// نموذج بيانات الفيديو
class Video {
  final int id;
  final int subjectId;
  final String name;
  final String url;

  Video({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.url,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      subjectId: int.parse(json['subject_id']),
      name: json['name'],
      url: json['url'],
    );
  }
}
