import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// كلاس الواجهة لعرض الكتب
class BookList extends StatefulWidget {
  final int subjectId;

  BookList({required this.subjectId});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Book> _books = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  // تابع استرجاع الكتب من الAPI
  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
    });

    // قم بتحميل الرمز المميز للمستخدم (token)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      setState(() {
        _isLoading = false;
        _message = 'Error: Access token is null';
      });
      print('Error: Access token is null');
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/getBooks/admin/${widget.subjectId}');

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
            _books = (jsonResponse['data'] as List)
                .map((bookJson) => Book.fromJson(bookJson))
                .toList();
            _message = jsonResponse['message'];
          });
        } else {
          setState(() {
            _message = 'Failed to retrieve books.';
          });
        }
      } else {
        setState(() {
          _message = 'لا توجد كتب';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error fetching books: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // تابع حذف الكتاب
  Future<void> _deleteBook(int id) async {
    setState(() {
      _isLoading = true;
    });

    // قم بتحميل الرمز المميز للمستخدم (token)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('http://127.0.0.1:8000/api/deleteBook/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          // إزالة الكتاب من قائمة الكتب المعروضة بنجاح
          setState(() {
            _books.removeWhere((book) => book.id == id);
            _message = jsonResponse['message'];
          });
        } else {
          setState(() {
            _message = 'Failed to delete book.';
          });
        }
      } else {
        setState(() {
          _message = 'Failed to delete book. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error deleting book: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _books.isNotEmpty
          ? ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return Container(
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(book.bookName),
                    subtitle: Text(book.description),
                    trailing: IconButton(
                      icon: Icon(Icons.book),
                      onPressed: () {
                        // هنا يمكنك تنفيذ رمز لفتح الكتاب
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // عند الضغط على زر الحذف، قم بحذف الكتاب
                      _deleteBook(book.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(child: Text(_message)),
    );
  }
}

// كلاس الكتاب
class Book {
  final int id;
  final int subjectId;
  final String bookName;
  final String description;
  final int pagesNumber;
  final String url;

  Book({
    required this.id,
    required this.subjectId,
    required this.bookName,
    required this.description,
    required this.pagesNumber,
    required this.url,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      subjectId: int.parse(json['subject_id']),
      bookName: json['book_name'],
      description: json['description'],
      pagesNumber: json['pages_number'],
      url: json['url'],
    );
  }
}
