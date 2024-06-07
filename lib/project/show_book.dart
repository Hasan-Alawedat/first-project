import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';

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
            _message = "لا يوجد كتب لعرضها";
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
                  icon: const Icon(Icons.person, color: Colors.blueGrey),
                  onPressed: () {},
                ),
                SizedBox(width: 600),
              ],
            ) : Container(),
            isDesktop ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notification_important, color: Colors.blueGrey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.forward_to_inbox, color: Colors.blueGrey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home, color: Colors.blueGrey),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 280),
              ],
            ) : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 230,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "                                       بحث  ",
                    hoverColor: Colors.cyan,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search_rounded, color: Colors.black12),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false, // هذا يمنع ظهور أيقونة الرجوع التلقائية
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _books.isNotEmpty
          ? ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return BookCard(
            book: book,
            onDelete: () => _deleteBook(book.id),
          );
        },
      )
          : Center(child: Text(_message)),
    );
  }
}

// ويدجيت مخصص لعرض بطاقة الكتاب
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onDelete;

  BookCard({required this.book, required this.onDelete});

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
              leading: Icon(Icons.book, color: Colors.blue, size: 40),
              title: Text(
                book.bookName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              subtitle: Text(
                book.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey[300],
                ),
              ),
              trailing:
              TextButton(
                onPressed: () {
                  // هنا يمكنك تنفيذ رمز لفتح الكتاب
                },
                child: Text(
                  "فتح الكتاب",
                  style: TextStyle(color: Colors.blue),
                ),
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
